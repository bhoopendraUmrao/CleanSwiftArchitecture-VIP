//
//  SearchResultRouter.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import Foundation

protocol SearchResultRoutingLogic {
    func routeToSearchDetail()
}

protocol SearchResultDataPassing {
    var dataStore: SearchResultDataStore? { get }
}

final class SearchResultRouter: SearchResultRoutingLogic, SearchResultDataPassing {
    let dataStore: SearchResultDataStore?

    private weak var viewController: SearchResultViewController?

    /// Init with viewcontroller and data store
    /// - Parameters:
    ///   - viewController: SearchResultViewController
    ///   - dataStore: SearchResultDataStore
    init(viewController: SearchResultViewController, dataStore: SearchResultDataStore) {
        self.dataStore = dataStore
        self.viewController = viewController
    }

    // MARK: - Routing logic handling
    func routeToSearchDetail() {
        guard let indexPath = dataStore?.selectedIndexPath else { return }
        let destinationVC = SearchDetailViewController()
        var destinationDS = destinationVC.router?.dataStore
        passDataToSearchResult(source: dataStore, selectedIndexpath: indexPath, destination: &destinationDS)
        navigateToSearchDetail(source: viewController, destination: destinationVC)
    }

    // MARK: - Navigation
    private func navigateToSearchDetail(source: SearchResultViewController?,
                                        destination: SearchDetailViewController) {
        source?.navigationController?.pushViewController(destination, animated: true)
    }

    // MARK: - Passing data
    private func passDataToSearchResult(source: SearchResultDataStore?,
                                        selectedIndexpath: IndexPath,
                                        destination: inout SearchDetailDataStore?) {
        destination?.searchItem = source?.searchResult[selectedIndexpath.section].items[selectedIndexpath.item]
    }
}
