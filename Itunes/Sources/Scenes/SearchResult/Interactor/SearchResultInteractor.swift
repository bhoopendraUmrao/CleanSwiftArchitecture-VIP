//
//  SearchResultInteractor.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import Foundation

protocol SearchResultDataStore {
    var searchResult: [SearchResult] { get set }
    var selectedIndexPath: IndexPath? { get }
}

protocol SearchResultBusinessLogic {
    func getSearchResult()
    func searchItemSelection(indexPath: IndexPath)
}

final class SearchResultInteractor: SearchResultBusinessLogic, SearchResultDataStore {
    // Properties
    private let presenter: SearchResultPresentationLogic
    var searchResult: [SearchResult] = []
    var selectedIndexPath: IndexPath?

    /// Initialize SearchResultInteractor
    /// - Parameters:
    ///   - presenter: SearchResultPresentationLogic
    ///   - worker: SearchResultWorkerLogic
    init(presenter: SearchResultPresentationLogic) {
        self.presenter = presenter
    }

    // MARK: - Buniness logic handling
    func getSearchResult() {
        presenter.presentSearchResult(searchResult: searchResult)
    }

    func searchItemSelection(indexPath: IndexPath) {
        selectedIndexPath = indexPath
        presenter.presentSearchDetail()
    }
}
