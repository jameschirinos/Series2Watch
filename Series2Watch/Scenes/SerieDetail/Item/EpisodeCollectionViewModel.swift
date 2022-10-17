//
//  EpisodeCollectionViewModel.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 15/10/22.
//

import Foundation

struct EpisodeCollectionViewModel: Hashable {
    var name: String?
    var imageUrl: String?
    var number: String
    var season: String
    var summary: String
    
    
    init(episode: Episode) {
        self.name = episode.name
        self.imageUrl = episode.imageUrl
        self.summary = episode.summary
        self.season = episode.season
        self.number = episode.number
    }
}
