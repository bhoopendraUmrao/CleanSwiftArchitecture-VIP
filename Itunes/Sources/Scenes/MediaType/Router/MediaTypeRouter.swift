//
//  MediaTypeRouter.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 31/08/22.
//

import Foundation

protocol MediaTypeRoutingLogic {
    func routeToSearchCriteria()
}

protocol MediaTypeDataPassing {
}

final class MediaTypeRouter: MediaTypeRoutingLogic, MediaTypeDataPassing {
    private weak var viewController: MediaTypeViewController?

    /// Init with viewcontroller and data store
    /// - Parameters:
    ///   - viewController: MediaTypeViewController
    ///   - dataStore: MediaTypeDataStoreProtocol
    init(viewController: MediaTypeViewController) {
        self.viewController = viewController
    }

    // MARK: - Routing handling
    func routeToSearchCriteria() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
