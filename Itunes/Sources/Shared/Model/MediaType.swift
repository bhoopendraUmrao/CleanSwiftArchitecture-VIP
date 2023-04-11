//
//  MediaType.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 31/08/22.
//

import Foundation

enum MediaType: String, CaseIterable {
    case album = "album"
    case artist = "musicArtist"
    case book = "ebook"
    case movie = "movie"
    case musicVideo = "musicVideo"
    case podcast = "podcast"
    case song = "song"

    var title: String {
        switch self {
        case .album:
            return "Album"
        case .artist:
            return "Artist"
        case .book:
            return "Book"
        case .movie:
            return "Movie"
        case .musicVideo:
            return "Music Video"
        case .podcast:
            return "Podcast"
        case .song:
            return "Song"
        }
    }
}

extension MediaType: TypeSelectionProtocol {
}
