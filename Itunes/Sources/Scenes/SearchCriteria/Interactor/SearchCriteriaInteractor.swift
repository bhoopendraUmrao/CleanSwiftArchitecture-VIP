//
//  SearchCriteriaInteractor.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 30/08/22.
//

import Foundation

protocol SearchCriteriaDataStore {
    var selectedMediaTypes: [MediaType] { get }
    var searchResult: [SearchResult] { get }
}

protocol SearchCriteriaBusinessLogic {
    func getSelected(mediaTypes: [MediaType])
    func getSearchResult(for requests: [SearchList.SearchItunes.Request])
}

final class SearchCriteriaInteractor: SearchCriteriaBusinessLogic, SearchCriteriaDataStore {
    private let presenter: SearchCriteriaPresentationLogic
    private let worker: SearchCriteriaWorkerLogic
    var selectedMediaTypes: [MediaType] = []
    var searchResult: [SearchResult] = []

    /// Initialize SearchCriteriaInteractor
    /// - Parameters:
    ///   - presenter: SearchCriteriaPresentationLogic
    ///   - worker: SearchCriteriaWorkerLogic
    init(presenter: SearchCriteriaPresentationLogic, worker: SearchCriteriaWorkerLogic) {
        self.presenter = presenter
        self.worker = worker
    }

    // MARK: - Buniness logic handling
    /// Get selected media types
    /// - Parameter mediaTypes: [MediaType]
    func getSelected(mediaTypes: [MediaType]) {
        selectedMediaTypes = mediaTypes
        presenter.presentSelected(mediaTypes: mediaTypes)
    }

    /// Get Search Resuls
    /// - Parameter requests: Request for Api
    func getSearchResult(for requests: [SearchList.SearchItunes.Request]) {
        presenter.presentLoader()
        let group = DispatchGroup()
        var results: [SearchResult] = []
        var searchResponse: [SearchList.SearchItunes.Response] = []
        for request in requests {
            group.enter()
            worker.getSearchResult(request: request) { response in
                switch response {
                case .success(let data):
                    if data.results.count > 0 {
                        results.append(SearchResult(mediaType: request.type, items: data.results))
                        searchResponse.append(data)
                    }
                case .failure:
                    break
                }
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.presenter.dismissLoader()
            self.searchResult = results
            guard results.count > 0 else {
                self.presenter.presentError(errorMsg: "No result found.")
                return
            }
            self.presenter.presentItunesSearchResult(searchResponse)
        }
    }
}
