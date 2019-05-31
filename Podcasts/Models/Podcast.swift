//
//  Podcast.swift
//  Podcasts
//
//  Created by We//Yes on 18/05/2019.
//  Copyright © 2019 Daniil Vereschagin. All rights reserved.
//

import Foundation

struct Podcast: Decodable {
    
    let trackName: String?
    let artistName: String?
    let country: String?
    let artworkUrl100: String
    let trackCount: Int?
    let previewUrl: String?
    let feedUrl: String?
    let trackTimeMillis: Date?
    let trackPrice: Float?
}

struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
