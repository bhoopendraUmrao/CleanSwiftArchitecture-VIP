//
//  SearchCriteriaViewControllerTests.swift
//  ItunesTests
//
//  Created by bhoopendra.umrao on 03/09/22.
//

import XCTest
@testable import Itunes

final class SearchCriteriaViewControllerTests: XCTestCase {
    // MARK: - Subject under test
    var sut: SearchCriteriaViewController!
    var spy: SearchCriteriaBusinessLogicSpy!
    var window: UIWindow!

    // MARK: - Test lifecycle
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupSearchCriteriaViewController()
    }

    override func tearDown() {
        super.tearDown()
        window = nil
        sut = nil
        spy = nil
    }

    // MARK: - Test setup
    func setupSearchCriteriaViewController() {
        spy = SearchCriteriaBusinessLogicSpy()
        sut = SearchCriteriaViewController()
        sut.interactor = spy
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: - Test doubles
    final class SearchCriteriaBusinessLogicSpy: SearchCriteriaBusinessLogic {
        // MARK: Method call expectations
        var getSelectedCalled = false
        var getSearchResultCalled = false

        // MARK: Spied methods
        func getSelected(mediaTypes: [MediaType]) {
            getSelectedCalled = true
        }

        func getSearchResult(for requests: [SearchList.SearchItunes.Request]) {
            getSearchResultCalled = true
        }
    }

    // MARK: - Tests
    func testViewLoad() {
        // given
        loadView()
        // when
        sut.viewDidLoad()
    }

    func testDisplaySelected() {
        // given
        loadView()
        // when
        let mediaTypes: [MediaType] = [.album, .artist, .book]
        sut.displaySelected(mediaTypes: mediaTypes)
        // then
        XCTAssertEqual(mediaTypes, [.album, .artist, .book])
    }

    func testDisplayError() {
        // when
        let errorMsg = "unknown error"
        sut.displayError(message: errorMsg)
        // then
        XCTAssertEqual(errorMsg, "unknown error")
    }

    func testDisplaySearchResult() {
        sut.displaySearchResult()
    }

    func testInitWithCoder() {
        let searchDeatilView = SearchCriteriaViewController(coder: NSCoder())
        XCTAssertNil(searchDeatilView)
    }

    func testShowLoader() {
        sut.showLoader()
        let subView = sut.view.subviews.first { $0.restorationIdentifier == "activityIndicatorView" }
        XCTAssertNotNil(subView)
    }

    func testHideLoader() {
        sut.hideLoader()
        let subView = sut.view.subviews.first { $0.restorationIdentifier == "activityIndicatorView" }
        XCTAssertNil(subView)
    }

    func testNavigationBar() {
        // Then
        XCTAssertEqual(sut.shouldShowNavigationBar, true)
    }
}
