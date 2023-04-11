//
//  SearchCriteriaPresenter.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 30/08/22.
//

import Foundation

protocol SearchCriteriaPresentationLogic: BasePresentationLogic {
    func presentSelected(mediaTypes: [MediaType])
    func presentItunesSearchResult(_ result: [SearchList.SearchItunes.Response])
    func presentError(errorMsg: String)
}

final class SearchCriteriaPresenter: SearchCriteriaPresentationLogic {
    private weak var viewController: SearchCriteriaDisplayLogic?

    /// Intialize SearchDetailPresenter with SearchCriteriaDisplayLogic
    /// - Parameter viewController: SearchCriteriaDisplayLogic
    init(viewController: SearchCriteriaDisplayLogic) {
        self.viewController = viewController
    }

    // MARK: - Presentation handling
    func presentSelected(mediaTypes: [MediaType]) {
        viewController?.displaySelected(mediaTypes: mediaTypes)
    }

    func presentItunesSearchResult(_ result: [SearchList.SearchItunes.Response]) {
        viewController?.displaySearchResult()
    }

    func presentError(errorMsg: String) {
        viewController?.displayError(message: errorMsg)
    }

    func presentLoader() {
        viewController?.showLoader()
    }

    func dismissLoader() {
        viewController?.hideLoader()
    }
}
