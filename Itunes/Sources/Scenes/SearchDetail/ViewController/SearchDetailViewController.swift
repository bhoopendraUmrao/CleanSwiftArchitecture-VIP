//
//  SearchDetailViewController.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import UIKit
import AVKit

protocol SearchDetailDisplayLogic: AnyObject {
    func displaySearchResult(viewModel: SearchDetail.GetSearchDetail.ViewModel)
    func displayPreviewMedia(url: URL)
}

final class SearchDetailViewController: BaseViewController, SearchDetailDisplayLogic {

    override var shouldShowNavigationBar: Bool { true }
    override var navigationTitle: String { "Search Detail" }

    var interactor: SearchDetailBusinessLogic?
    var router: SearchDetailDataPassing?
    private var displayedResult: SearchItem?

    // @IBOutlets
    @IBOutlet weak private var artWorkImageView: UIImageView!
    @IBOutlet weak private var artistName: UILabel!
    @IBOutlet weak private var previewButton: UIButton!

    init() {
        super.init(nibName: "SearchDetailViewController", bundle: nil)
        configurator()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getSearchDetail()
    }

    /// Configure interactor, presenter, router
    private func configurator() {
        let viewController = self
        let presenter = SearchDetailPresenter(viewController: viewController)
        let interactor = SearchDetailInteractor(presenter: presenter)
        let router = SearchDetailRouter(viewController: viewController, dataStore: interactor)
        viewController.interactor = interactor
        viewController.router = router
    }

    /// Preview the content from url in player
    /// - Parameter url: URL to preivew
    private func playPreview(url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

    func displaySearchResult(viewModel: SearchDetail.GetSearchDetail.ViewModel) {
        displayedResult = viewModel.displayedResult
        artistName.text = viewModel.displayedResult.artistName
        previewButton.isHidden = viewModel.displayedResult.previewUrl != nil ? false : true
        guard let urlString = viewModel.displayedResult.artworkUrl, let url = URL(string: urlString)
        else { return }
        artWorkImageView.loadImage(at: url)
    }

    func displayPreviewMedia(url: URL) {
        playPreview(url: url)
    }

    // MARK: - @IBAction
    @IBAction private func previewBtnClicked(_ sender: UIButton) {
        interactor?.previewMedia()
    }
}
