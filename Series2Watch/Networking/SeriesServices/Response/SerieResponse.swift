//
//  SerieResponse.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 17/10/22.
//

import Foundation

struct SerieResponse: Codable {
    let id: Int
    let name: String
    let genres: [String]
    let premiered: String
    let ended: String?
    let image: MediaImage
    let summary: String
    let _embedded: SerieEpEmbedded?
}

struct SerieEpEmbedded: Codable {
    var episodes: [EpisodeResponse]
}
