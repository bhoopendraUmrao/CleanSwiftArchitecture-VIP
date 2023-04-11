//
//  SearchResultPresenterTests.swift
//  ItunesTests
//
//  Created by bhoopendra.umrao on 03/09/22.
//

import XCTest
@testable import Itunes

final class SearchResultPresenterTests: XCTestCase {
    // MARK: - Subject under test
    var sut: SearchResultPresenter!
    var searchResultDisplayLogicSpy: SearchResultDisplayLogicSpy!

    // MARK: - Test lifecycle
    override func setUp() {
        super.setUp()
        setUpSearchDeatilPresenter()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        searchResultDisplayLogicSpy = nil
    }

    // MARK: - Test setup
    func setUpSearchDeatilPresenter() {
        searchResultDisplayLogicSpy = SearchResultDisplayLogicSpy()
        sut = SearchResultPresenter(viewController: searchResultDisplayLogicSpy)
    }

    // MARK: - Test doubles
    final class SearchResultDisplayLogicSpy: SearchResultDisplayLogic {

        var displaySearchResultCalled = false
        var displaySearchDetailCalled = false

        func displaySearchResult(viewModel: ShowSearchResult.GetSearchResult.ViewModel) {
            displaySearchResultCalled = true
        }

        func displaySearchDetail() {
            displaySearchDetailCalled = true
        }
    }

    // MARK: - Tests
    func testPresentSearchDetail() {
        // when
        sut.presentSearchDetail()
        // then
        XCTAssertEqual(searchResultDisplayLogicSpy.displaySearchDetailCalled, true)
    }

    func testPresentSearchResult() {
        // given
        let searchItem = SearchItem(
            wrapperType: "track",
            artistId: 2226112,
            artistName: "Widespread Panic",
            currency: "USD",
            artworkUrl: "https://is2-ssl.mzstatic.com/image/thumb/Music/9f/ee/25/mzi.ygppkzdh.jpg/100x100bb.jpg",
            artistViewUrl: "https://music.apple.com/us/artist/widespread-panic/2226112?uo=4",
            releaseDate: "2010-03-26T12:00:00Z",
            previewUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        )
        let searchResult = SearchResult(mediaType: .artist, items: [searchItem])
        // when
        sut.presentSearchResult(searchResult: [searchResult])
        // then
        XCTAssertEqual(searchResultDisplayLogicSpy.displaySearchResultCalled, true)
    }
}
