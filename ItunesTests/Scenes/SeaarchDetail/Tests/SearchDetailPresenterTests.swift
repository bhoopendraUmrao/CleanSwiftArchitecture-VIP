//
//  SearchDetailPresenterTests.swift
//  ItunesTests
//
//  Created by bhoopendra.umrao on 03/09/22.
//

import XCTest
@testable import Itunes

final class SearchDetailPresenterTests: XCTestCase {
    // MARK: - Subject under test
    var sut: SearchDetailPresenter!
    var searchDetailDisplayLogicSpy: SearchDetailDisplayLogicSpy!

    // MARK: - Test lifecycle
    override func setUp() {
        super.setUp()
        setUpSearchDeatilPresenter()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        searchDetailDisplayLogicSpy = nil
    }

    // MARK: - Test setup
    func setUpSearchDeatilPresenter() {
        searchDetailDisplayLogicSpy = SearchDetailDisplayLogicSpy()
        sut = SearchDetailPresenter(viewController: searchDetailDisplayLogicSpy)
    }

    // MARK: - Test doubles
    final class SearchDetailDisplayLogicSpy: SearchDetailDisplayLogic {

        var displaySearchResultCalled =  false
        var displayPreviewMediaCalled =  false

        func displaySearchResult(viewModel: SearchDetail.GetSearchDetail.ViewModel) {
            displaySearchResultCalled = true
        }

        func displayPreviewMedia(url: URL) {
            displayPreviewMediaCalled = true
        }
    }

    // MARK: - Tests
    func testPresentSearchDetail() {
        // Given
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
        // When
        sut.presentSearchDetail(item: searchItem)
        // then
        XCTAssertEqual(searchDetailDisplayLogicSpy.displaySearchResultCalled, true)
    }

    func testPresentPreviewMedia() {
        // given
        let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        // when
        sut.presentPreviewMedia(url: url)
        // then
        XCTAssertEqual(searchDetailDisplayLogicSpy.displayPreviewMediaCalled, true)
    }
}
