//
//  SearchResultInteractorTests.swift
//  ItunesTests
//
//  Created by bhoopendra.umrao on 03/09/22.
//

import XCTest
@testable import Itunes

final class SearchResultInteractorTests: XCTestCase {
    // MARK: - Subject under test
    var sut: SearchResultInteractor!
    var searchResultPresentationLogicSpy: SearchResultPresentationLogicSpy!

    // MARK: - Test lifecycle
    override func setUp() {
        super.setUp()
        setupSearchResultInteractor()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        searchResultPresentationLogicSpy = nil
    }

    // MARK: - Test setup
    func setupSearchResultInteractor() {
        searchResultPresentationLogicSpy = SearchResultPresentationLogicSpy()
        sut = SearchResultInteractor(presenter: searchResultPresentationLogicSpy)
    }

    // MARK: - Test doubles
    final class SearchResultPresentationLogicSpy: SearchResultPresentationLogic {
        var presentSearchResultCalled = false
        var presentSearchDetailCalled = true
        func presentSearchResult(searchResult: [SearchResult]) {
            presentSearchResultCalled = true
        }

        func presentSearchDetail() {
            presentSearchDetailCalled = true
        }
    }

    // MARK: - Tests
    func testGetSearchResult() {
        // when
        sut.getSearchResult()
        // then
        XCTAssertEqual(searchResultPresentationLogicSpy.presentSearchResultCalled, true)
    }

    func testSearcItemSelection() {
        // Given
        let indexPath = IndexPath(item: 0, section: 0)
        // when
        sut.searchItemSelection(indexPath: indexPath)
        // then
        XCTAssertEqual(searchResultPresentationLogicSpy.presentSearchDetailCalled, true)
    }
}
