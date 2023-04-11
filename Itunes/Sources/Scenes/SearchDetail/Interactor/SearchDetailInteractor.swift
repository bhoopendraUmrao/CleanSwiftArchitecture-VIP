//
//  SearchDetailInteractor.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import Foundation

protocol SearchDetailDataStore {
    var searchItem: SearchItem? { get set }
}

protocol SearchDetailBusinessLogic {
    func getSearchDetail()
    func previewMedia()
}

final class SearchDetailInteractor: SearchDetailBusinessLogic, SearchDetailDataStore {
    var searchItem: SearchItem?
    private let presenter: SearchDetailPresentationLogic

    /// Initialize SearchDetailInteractor
    /// - Parameters:
    ///   - presenter: SearchDetailPresentationLogic
    init(presenter: SearchDetailPresentationLogic) {
        self.presenter = presenter
    }

    // MARK: - Business logic handling
    func getSearchDetail() {
        guard let item = searchItem else { return }
        presenter.presentSearchDetail(item: item)
    }

    func previewMedia() {
        guard let urlString = searchItem?.previewUrl, let url = URL(string: urlString) else { return }
        presenter.presentPreviewMedia(url: url)
    }
}
