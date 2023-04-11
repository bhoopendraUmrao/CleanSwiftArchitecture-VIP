//
//  SearchResultPresenter.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import Foundation

protocol SearchResultPresentationLogic {
    func presentSearchResult(searchResult: [SearchResult])
    func presentSearchDetail()
}

final class SearchResultPresenter: SearchResultPresentationLogic {

    private weak var viewController: SearchResultDisplayLogic?

    /// Intialize SearchDetailPresenter
    /// - Parameter viewController: SearchResultDisplayLogic
    init(viewController: SearchResultDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Presentation logic handling
    func presentSearchResult(searchResult: [SearchResult]) {
        var displayedResult: [ShowSearchResult.GetSearchResult.ViewModel.DisplayedResult] = []
        for item in searchResult {
            let artItem = item.items.map {
                 ShowSearchResult.GetSearchResult.ViewModel.Item(
                    artworkUrl: $0.artworkUrl,
                    artistName: $0.artistName
                 )
            }
            let result = ShowSearchResult.GetSearchResult.ViewModel.DisplayedResult(
                type: item.mediaType,
                items: artItem
            )
            displayedResult.append(result)
        }
        viewController?.displaySearchResult(
            viewModel: ShowSearchResult.GetSearchResult.ViewModel(displayedResults: displayedResult)
        )
    }

    func presentSearchDetail() {
        viewController?.displaySearchDetail()
    }
}
