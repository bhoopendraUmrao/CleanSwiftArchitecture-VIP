//
//  SearchList.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 01/09/22.
//

import Foundation

enum SearchList {
    enum SearchItunes {
        struct Request {
            let term: String
            let type: MediaType
        }
        struct Response: Decodable {
            let results: [SearchItem]
        }
    }
}
