//
//  MediaTypeViewControllerTests.swift
//  ItunesTests
//
//  Created by bhoopendra.umrao on 03/09/22.
//

import XCTest
@testable import Itunes

final class MediaTypeViewControllerTests: XCTestCase {
    // MARK: - Subject under test
    var sut: MediaTypeViewController!
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
    }

    // MARK: - Test setup
    func setupSearchDetailViewController() {
        sut = MediaTypeViewController(selectedMediaTypes: [.album, .musicVideo, .artist],
                                      doneAction: nil)
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    // MARK: - Tests
    func testViewLoad() {
        // given
        loadView()
        // when
        sut.viewDidLoad()
    }

    func testInitWithCoder() {
        let searchDeatilView = MediaTypeViewController(coder: NSCoder())
        XCTAssertNil(searchDeatilView)
    }

    func testNavigationBar() {
        // Then
        XCTAssertEqual(sut.shouldShowNavigationBar, true)
    }
}
