//
//  SearchResult.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import Foundation

struct SearchItem: Decodable {
    let wrapperType: String?
    let artistId: Int?
    let artistName: String?
    let currency: String?
    let artworkUrl: String?
    let artistViewUrl: String?
    let releaseDate: String?
    let previewUrl: String?

    enum CodingKeys: String, CodingKey {
        case wrapperType = "wrapperType"
        case artistId = "artistId"
        case artistName = "artistName"
        case currency = "currency"
        case artworkUrl = "artworkUrl100"
        case artistViewUrl = "artistViewUrl"
        case releaseDate = "releaseDate"
        case previewUrl = "previewUrl"
    }
}

struct SearchResult {
    var mediaType: MediaType?
    var items: [SearchItem]
}
