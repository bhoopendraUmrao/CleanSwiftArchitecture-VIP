//
//  SearchCriteriaInteractorTests.swift
//  ItunesTests
//
//  Created by bhoopendra.umrao on 03/09/22.
//

import XCTest
@testable import Itunes

class SearchCriteriaInteractorTests: XCTestCase {
    // MARK: - Subject under test
    var sut: SearchCriteriaInteractor!
    var searchCriteriaPresentationLogicSpy: SearchCriteriaPresentationLogicSpy!
    var searchCriteriaWorker: SearchCriteriaWorkerSpy!
    // MARK: - Test lifecycle
    override func setUp() {
        super.setUp()
        setupSearchResultInteractor()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        searchCriteriaPresentationLogicSpy = nil
        searchCriteriaWorker = nil
    }

    // MARK: - Test setup
    func setupSearchResultInteractor() {
        searchCriteriaPresentationLogicSpy = SearchCriteriaPresentationLogicSpy()
        searchCriteriaWorker = SearchCriteriaWorkerSpy()
        sut = SearchCriteriaInteractor(presenter: searchCriteriaPresentationLogicSpy, worker: searchCriteriaWorker)
    }

    // MARK: - Test doubles
    final class SearchCriteriaPresentationLogicSpy: SearchCriteriaPresentationLogic {
        var presentSelectedCalled = false
        var presentItunesSearchResultCalled = false
        var presentErrorCalled = false
        var presentLoaderCalled = false
        var dismissLoaderCalled = false

        func presentSelected(mediaTypes: [MediaType]) {
            presentSelectedCalled = true
        }

        func presentItunesSearchResult(_ result: [SearchList.SearchItunes.Response]) {
            presentItunesSearchResultCalled = true
        }

        func presentError(errorMsg: String) {
            presentErrorCalled = true
        }

        func presentLoader() {
            presentLoaderCalled = true
        }

        func dismissLoader() {
            dismissLoaderCalled = true
        }
    }

    final class SearchCriteriaWorkerSpy: SearchCriteriaWorkerLogic {
        var searchResultResponse: Result<SearchList.SearchItunes.Response, Error>!

        func getSearchResult(request: SearchList.SearchItunes.Request,
                             completion: @escaping (Result<SearchList.SearchItunes.Response, Error>) -> Void) {
            completion(searchResultResponse)
        }
    }

    // MARK: - Tests
    func testGetSelected() {
        // given
        let mediaTypes: [MediaType] = [.album, .artist, .musicVideo]
        // when
        sut.getSelected(mediaTypes: mediaTypes)
        // then
        XCTAssertEqual(searchCriteriaPresentationLogicSpy.presentSelectedCalled, true)
    }

    func testGetSearchResultSuccess() {
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
        searchCriteriaWorker.searchResultResponse = .success(response)

        // when
        let request: [SearchList.SearchItunes.Request] = [
            SearchList.SearchItunes.Request(term: "Jack", type: .musicVideo),
            SearchList.SearchItunes.Request(term: "Jack", type: .artist),
            SearchList.SearchItunes.Request(term: "Jack", type: .album)
        ]
        sut.getSearchResult(for: request)

        // then
        let expectation = XCTestExpectation(description: "Search result success response")
        DispatchQueue.main.async {
            XCTAssertEqual(self.searchCriteriaPresentationLogicSpy.presentItunesSearchResultCalled, true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testGetSearchNoResult() {
        // given
        let response = SearchList.SearchItunes.Response(results: [])
        searchCriteriaWorker.searchResultResponse = .success(response)

        // when
        let request: [SearchList.SearchItunes.Request] = [
            SearchList.SearchItunes.Request(term: "Jack", type: .musicVideo),
            SearchList.SearchItunes.Request(term: "Jack", type: .artist),
            SearchList.SearchItunes.Request(term: "Jack", type: .album)
        ]
        sut.getSearchResult(for: request)

        // then
        let expectation = XCTestExpectation(description: "Search no result response")
        DispatchQueue.main.async {
            XCTAssertEqual(self.searchCriteriaPresentationLogicSpy.presentErrorCalled, true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testGetSearchResultFailure() {
        // given
        searchCriteriaWorker.searchResultResponse = .failure(APIError.unknown)

        // when
        let request: [SearchList.SearchItunes.Request] = [
            SearchList.SearchItunes.Request(term: "Jack", type: .musicVideo),
            SearchList.SearchItunes.Request(term: "Jack", type: .artist),
            SearchList.SearchItunes.Request(term: "Jack", type: .album)
        ]
        sut.getSearchResult(for: request)

        // then
        let expectation = XCTestExpectation(description: "Search result failure")
        DispatchQueue.main.async {
            XCTAssertEqual(self.searchCriteriaPresentationLogicSpy.presentErrorCalled, true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
