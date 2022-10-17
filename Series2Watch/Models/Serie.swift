//
//  Serie.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 14/10/22.
//

import Foundation

struct Serie {
    let id: Int
    let name: String
    let posterUrl: String
    let timeAirs: String
    let genres: [String]
    let summary: String
    let seasons: Int
    let episodes: [Episode]
    
    init(response: SerieResponse) {
        id = response.id
        name = response.name
        posterUrl = response.image.medium
        timeAirs = "\(response.premiered) - \(response.ended ?? "Present")"
        genres = response.genres
        summary = response.summary
        episodes = response._embedded?.episodes.map(Episode.init) ?? []
        var season = 0
        for episode in episodes {
            if let epSeason = Int(episode.season), epSeason > season {
                season = epSeason
            }
        }
        seasons = season
    }
}
