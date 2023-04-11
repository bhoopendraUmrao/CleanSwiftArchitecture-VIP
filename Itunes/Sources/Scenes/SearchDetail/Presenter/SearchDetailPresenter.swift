//
//  SearchDetailPresenter.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import Foundation

protocol SearchDetailPresentationLogic {
    func presentSearchDetail(item: SearchItem)
    func presentPreviewMedia(url: URL)
}

final class SearchDetailPresenter: SearchDetailPresentationLogic {
    private weak var viewController: SearchDetailDisplayLogic?

    /// Intialize SearchDetailPresentar with SearchDetailDisplayLogic
    /// - Parameter viewController: SearchDetailDisplayLogic
    init(viewController: SearchDetailDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Presentation logic handling
    func presentSearchDetail(item: SearchItem) {
        viewController?.displaySearchResult(
            viewModel: SearchDetail.GetSearchDetail.ViewModel(displayedResult: item)
        )
    }

    func presentPreviewMedia(url: URL) {
        viewController?.displayPreviewMedia(url: url)
    }
}
