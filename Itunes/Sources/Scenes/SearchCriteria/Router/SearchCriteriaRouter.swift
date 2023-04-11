//
//  SearchCriteriaRouter.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 30/08/22.
//

import Foundation
import UIKit

protocol SearchCriteriaRoutingLogic {
    func routeToMediaType()
    func routeToSearchResult()
}

protocol SearchCriteriaDataPassing {
    var dataStore: SearchCriteriaDataStore {get}
}

final class SearchCriteriaRouter: SearchCriteriaRoutingLogic, SearchCriteriaDataPassing {
    let dataStore: SearchCriteriaDataStore
    private weak var viewController: SearchCriteriaViewController?

    /// Init with viewcontroller and data store
    /// - Parameters:
    ///   - viewController: SearchCriteriaViewController
    ///   - dataStore: SearchCriteriaDataStore
    init(viewController: SearchCriteriaViewController, dataStore: SearchCriteriaDataStore) {
        self.dataStore = dataStore
        self.viewController = viewController
    }

    // MARK: - Routing logic handling
    func routeToMediaType() {
        let mediaTypeViewController = MediaTypeViewController(
            selectedMediaTypes: dataStore.selectedMediaTypes
        ) { [weak self] selectedMediaTypes in
            guard let self = self else { return }
            self.viewController?.interactor?.getSelected(mediaTypes: selectedMediaTypes)
        }
        viewController?.navigationController?.pushViewController(mediaTypeViewController, animated: true)
    }

    func routeToSearchResult() {
        let destinationVC = SearchResultViewController()
        var destinationDS = destinationVC.router?.dataStore
        passDataToSearchResult(source: dataStore, destination: &destinationDS)
        navigateToSearchResult(source: viewController, destination: destinationVC)
    }

    // MARK: - Navigation
    private func navigateToSearchResult(source: SearchCriteriaViewController?,
                                        destination: SearchResultViewController) {
        source?.navigationController?.pushViewController(destination, animated: true)
    }

    // MARK: - Passing data
    private func passDataToSearchResult(source: SearchCriteriaDataStore,
                                        destination: inout SearchResultDataStore?) {
        destination?.searchResult = source.searchResult
    }
}
