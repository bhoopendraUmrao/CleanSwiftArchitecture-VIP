//
//  SearchCriteriaPresenterTests.swift
//  ItunesTests
//
//  Created by bhoopendra.umrao on 03/09/22.
//

import XCTest
@testable import Itunes

final class SearchCriteriaPresenterTests: XCTestCase {
    // MARK: - Subject under test
    var sut: SearchCriteriaPresenter!
    var searchCriteriaDisplayLogicSpy: SearchCriteriaDisplayLogicSpy!

    // MARK: - Test lifecycle
    override func setUp() {
        super.setUp()
        setUpSearchDeatilPresenter()
    }

    override func tearDown() {
        super.tearDown()
        searchCriteriaDisplayLogicSpy = nil
        sut = nil
    }

    // MARK: - Test setup
    func setUpSearchDeatilPresenter() {
        searchCriteriaDisplayLogicSpy = SearchCriteriaDisplayLogicSpy()
        sut = SearchCriteriaPresenter(viewController: searchCriteriaDisplayLogicSpy)
    }

    // MARK: - Test doubles
    final class SearchCriteriaDisplayLogicSpy: SearchCriteriaDisplayLogic {
        var displaySelectedCalled = false
        var displayErrorCalled = false
        var displaySearchResultCalled = false
        var showLoaderCalled = false
        var hideLoaderCalled = false

        func displaySelected(mediaTypes: [MediaType]) {
            displaySelectedCalled = true
        }

        func displayError(message: String) {
            displayErrorCalled = true
        }

        func displaySearchResult() {
            displaySearchResultCalled = true
        }

        func showLoader() {
            showLoaderCalled = true
        }

        func hideLoader() {
            hideLoaderCalled = true
        }
    }

    // MARK: - Tests
    func testPresentSelected() {
        // given
        let mediaTypes: [MediaType] = [.artist, .musicVideo]
        // when
        sut.presentSelected(mediaTypes: mediaTypes)
        // then
        XCTAssertEqual(searchCriteriaDisplayLogicSpy.displaySelectedCalled, true)
    }

    func testPresentItunesSearchResult() {
        // given
        let searchItem = SearchItem(
            wrapperType: "track",
            artistId: 2226112,
            artistName: "Widespread Panic",
            currency: "USD",
            artworkUrl: "https://is2-ssl.mzstatic.com/image/thumb/Music/9f/ee/25/mzi.ygppkzdh.jpg/100x100bb.jpg",
            artistViewUrl: "https://music.apple.com/us/artist/widespread-panic/2226112?uo=4",
            releaseDate: "2010-03-26T12:00:00Z",
            previewUrl: nil
        )
        let response = SearchList.SearchItunes.Response(results: [searchItem])
        // when
        sut.presentItunesSearchResult([response])
        // then
        XCTAssertEqual(searchCriteriaDisplayLogicSpy.displaySearchResultCalled, true)
    }

    func testPresentError() {
        // given
        let errorMsg = "unknown error"
        // when
        sut.presentError(errorMsg: errorMsg)
        // then
        XCTAssertEqual(searchCriteriaDisplayLogicSpy.displayErrorCalled, true)
    }

    func testPresentLoader() {
        sut.presentLoader()
    }

    func testDismissLoader() {
        sut.dismissLoader()
    }
}
