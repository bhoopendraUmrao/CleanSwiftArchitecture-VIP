//
//  SearchCriteriaWorker.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 30/08/22.
//

import Foundation

protocol SearchCriteriaWorkerLogic {
    func getSearchResult(request: SearchList.SearchItunes.Request,
                         completion: @escaping (Result<SearchList.SearchItunes.Response, Error>) -> Void)
}

final class SearchCriteriaWorker: SearchCriteriaWorkerLogic {

    private let serviceManager: ServiceManager

    init(serviceManager: ServiceManager = ServiceManager.shared) {
        self.serviceManager = serviceManager
    }

    // MARK: - Search Result request 
    func getSearchResult(request: SearchList.SearchItunes.Request,
                         completion: @escaping (Result<SearchList.SearchItunes.Response, Error>) -> Void) {
        let parameter = ["term": request.term.trimmingCharacters(in: .whitespacesAndNewlines)
                            .replacingOccurrences(of: " ", with: "+"),
                         "entity": request.type.rawValue]
        serviceManager.getResults(SearchList.SearchItunes.Response.self,
                                  endPoint: .search,
                                  method: .get,
                                  params: parameter) { result in
            completion(result)
        }
    }
}
