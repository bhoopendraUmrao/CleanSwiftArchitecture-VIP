//
//  SearchResultViewControllerTest.swift
//  ItunesTests
//
//  Created by bhoopendra.umrao on 03/09/22.
//

import XCTest
@testable import Itunes

final class SearchResultViewControllerTest: XCTestCase {
    // MARK: - Subject under test
    var sut: SearchResultViewController!
    var spy: SearchResultBusinessLogicSpy!
    var window: UIWindow!

    // MARK: - Test lifecycle
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupSearchResultViewController()
    }

    override func tearDown() {
        super.tearDown()
        window = nil
        sut = nil
        spy = nil
    }

    // MARK: - Test setup
    func setupSearchResultViewController() {
        spy = SearchResultBusinessLogicSpy()
        sut = SearchResultViewController()
        sut.interactor = spy
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: - Test doubles
    final class SearchResultBusinessLogicSpy: SearchResultBusinessLogic {
        var getSearchResultCalled = false
        var searchItemSelection = false
        func getSearchResult() {
            getSearchResultCalled = true
        }

        func searchItemSelection(indexPath: IndexPath) {
            searchItemSelection = true
        }
    }

    // MARK: - Tests
    func testViewLoad() {
        // given
        loadView()

        // when
        sut.viewDidLoad()

        // then
        XCTAssertEqual(spy.getSearchResultCalled, true)
    }

    func testDisplaySearchResult() {
        // given
        loadView()
        let item = ShowSearchResult.GetSearchResult.ViewModel.Item(
            artworkUrl: "https://is2-ssl.mzstatic.com/image/thumb/Music/9f/ee/25/mzi.ygppkzdh.jpg/100x100bb.jpg",
            artistName: "Widespread Panic"
        )
        let displayResult = ShowSearchResult.GetSearchResult.ViewModel.DisplayedResult(type: .artist, items: [item])
        let viewModel = ShowSearchResult.GetSearchResult.ViewModel(displayedResults: [displayResult])
        // when
        sut.displaySearchResult(viewModel: viewModel)
        // then
        XCTAssertNotNil(viewModel.displayedResults)
    }

    func testDisplaySearchDetail() {
        // when
        sut.displaySearchDetail()
    }

    func testInitWithCoder() {
        let searchDeatilView = SearchResultViewController(coder: NSCoder())
        XCTAssertNil(searchDeatilView)
    }

    func testNavigationBar() {
        // Then
        XCTAssertEqual(sut.shouldShowNavigationBar, true)
    }
}
