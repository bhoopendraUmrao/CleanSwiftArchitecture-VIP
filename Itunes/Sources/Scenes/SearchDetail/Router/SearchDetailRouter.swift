//
//  SearchDetailRouter.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import Foundation

protocol SearchDetailDataPassing {
    var dataStore: SearchDetailDataStore? { get }
}

final class SearchDetailRouter: SearchDetailDataPassing {
    var dataStore: SearchDetailDataStore?

    private weak var viewController: SearchDetailViewController?

    /// Init with viewcontroller and data store
    /// - Parameters:
    ///   - viewController: SearchDetailViewController
    ///   - dataStore: SearchDetailDataStore
    init(viewController: SearchDetailViewController, dataStore: SearchDetailDataStore) {
        self.dataStore = dataStore
        self.viewController = viewController
    }
}
