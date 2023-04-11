//
//  SearchResultModel.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import Foundation

protocol ArtWorkDisplayProtocol {
    var artworkUrl: String? { get }
    var artistName: String? { get }
}

enum ShowSearchResult {
    enum GetSearchResult {
        struct Response {
            var searchResults: [SearchResult]
        }
        struct ViewModel {
            struct Item: ArtWorkDisplayProtocol {
                let artworkUrl: String?
                let artistName: String?
            }
            struct DisplayedResult {
                let type: MediaType?
                let items: [Item]
            }
            var displayedResults: [DisplayedResult]
        }
    }
}
