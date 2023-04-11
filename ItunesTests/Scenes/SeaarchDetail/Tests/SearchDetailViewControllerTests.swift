//
//  SearchDetailViewControllerTests.swift
//  ItunesTests
//
//  Created by bhoopendra.umrao on 03/09/22.
//

import XCTest
@testable import Itunes

final class SearchDetailViewControllerTests: XCTestCase {
    // MARK: - Subject under test
    var sut: SearchDetailViewController!
    var spy: SearchDetailBusinessLogicSpy!
    var window: UIWindow!

    // MARK: - Test lifecycle
    override func setUp() {
      super.setUp()
      window = UIWindow()
      setupSearchDetailViewController()
    }

    override func tearDown() {
        super.tearDown()
        window = nil
        sut = nil
        spy = nil
    }

    // MARK: - Test setup
    func setupSearchDetailViewController() {
        spy = SearchDetailBusinessLogicSpy()
        sut = SearchDetailViewController()
        sut.interactor = spy
    }

    func loadView() {
      window.addSubview(sut.view)
      RunLoop.current.run(until: Date())
    }

    // MARK: - Test doubles
    final class SearchDetailBusinessLogicSpy: SearchDetailBusinessLogic, SearchDetailDataStore {
        // MARK: Method call expectations
        var getSearchDetailCalled = false
        var previewMediaCalled = false

        // MARK: Spied methods
        func getSearchDetail() {
            getSearchDetailCalled = true
        }

        func previewMedia() {
            previewMediaCalled = true
        }

        var searchItem: SearchItem? = SearchItem(
            wrapperType: "track",
            artistId: 2226112,
            artistName: "Widespread Panic",
            currency: "USD",
            artworkUrl: "https://is2-ssl.mzstatic.com/image/thumb/Music/9f/ee/25/mzi.ygppkzdh.jpg/100x100bb.jpg",
            artistViewUrl: "https://music.apple.com/us/artist/widespread-panic/2226112?uo=4",
            releaseDate: "2010-03-26T12:00:00Z",
            previewUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        )
    }

    // MARK: - Tests
    func testViewLoad() {
        // given
        loadView()

        // when
        sut.viewDidLoad()

        // then
        XCTAssertEqual(spy.getSearchDetailCalled, true)
    }

    func testDisplayPreviewMedia() {
        // given
        let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        // when
        sut.displayPreviewMedia(url: url)
        // then
        XCTAssertNotNil(url)
    }

    func testDisplaySearchResultSuccess() {
        // given
        loadView()
        let searchItem: SearchItem = SearchItem(
            wrapperType: "track",
            artistId: 2226112,
            artistName: "Widespread Panic",
            currency: "USD",
            artworkUrl: "https://is2-ssl.mzstatic.com/image/thumb/Music/9f/ee/25/mzi.ygppkzdh.jpg/100x100bb.jpg",
            artistViewUrl: "https://music.apple.com/us/artist/widespread-panic/2226112?uo=4",
            releaseDate: "2010-03-26T12:00:00Z",
            previewUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        )
        let viewModel = SearchDetail.GetSearchDetail.ViewModel(displayedResult: searchItem)
        // when
        sut.displaySearchResult(viewModel: viewModel)
        // then
        XCTAssertNotNil(viewModel.displayedResult)
    }

    func testDisplaySearchResultArtWorkFail() {
        // given
        loadView()
        let searchItem: SearchItem = SearchItem(
            wrapperType: "track",
            artistId: 2226112,
            artistName: "Widespread Panic",
            currency: "USD",
            artworkUrl: nil,
            artistViewUrl: "https://music.apple.com/us/artist/widespread-panic/2226112?uo=4",
            releaseDate: "2010-03-26T12:00:00Z",
            previewUrl: nil
        )
        let viewModel = SearchDetail.GetSearchDetail.ViewModel(displayedResult: searchItem)
        // when
        sut.displaySearchResult(viewModel: viewModel)
        // then
        XCTAssertNotNil(viewModel.displayedResult)
        XCTAssertNil(viewModel.displayedResult.previewUrl)
        XCTAssertNil(viewModel.displayedResult.artworkUrl)
    }

    func testInitWithCoder() {
        let searchDeatilView = SearchDetailViewController(coder: NSCoder())
        XCTAssertNil(searchDeatilView)
    }

    func testNavigationBar() {
        // Then
        XCTAssertEqual(sut.shouldShowNavigationBar, true)
    }
  }
