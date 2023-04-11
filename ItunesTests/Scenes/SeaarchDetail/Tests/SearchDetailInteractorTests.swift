//
//  SearchDetailInteractorTests.swift
//  ItunesTests
//
//  Created by bhoopendra.umrao on 03/09/22.
//

import XCTest
@testable import Itunes

final class SearchDetailInteractorTests: XCTestCase {
    // MARK: - Subject under test
    var sut: SearchDetailInteractor!
    var searchDetailPresentationLogicSpy: SearchDetailPresentationLogicSpy!
    // MARK: - Test lifecycle
    override func setUp() {
        super.setUp()
        setupSearchDetailInteractor()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        searchDetailPresentationLogicSpy = nil
    }

    // MARK: - Test setup
    func setupSearchDetailInteractor() {
        searchDetailPresentationLogicSpy = SearchDetailPresentationLogicSpy()
        sut = SearchDetailInteractor(presenter: searchDetailPresentationLogicSpy)
    }

    // MARK: - Test doubles
    final class SearchDetailPresentationLogicSpy: SearchDetailPresentationLogic {

        // MARK: Method call expectations
        var presentSearchDetailCalled = false
        var presentPreviewMediaCalled = false

        // MARK: Spied methods
        func presentSearchDetail(item: SearchItem) {
            presentSearchDetailCalled = true
        }

        func presentPreviewMedia(url: URL) {
            presentPreviewMediaCalled  = true
        }
    }

    // MARK: - Tests
    func testGetSearchResult() {
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
        sut.searchItem = searchItem
        // when
        sut.getSearchDetail()
        // then
        XCTAssertEqual(searchDetailPresentationLogicSpy.presentSearchDetailCalled, true)
    }

    func testPreviewMediaFail() {
        // given
        sut.searchItem = nil
        // when
        sut.previewMedia()
        // then
        XCTAssertEqual(searchDetailPresentationLogicSpy.presentPreviewMediaCalled, false)
    }

    func testPreviewMediaSuccess() {
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
        sut.searchItem = searchItem
        // when
        sut.previewMedia()

        // then
        XCTAssertEqual(searchDetailPresentationLogicSpy.presentPreviewMediaCalled, true)
    }
}
