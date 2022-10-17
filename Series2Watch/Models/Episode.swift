//
//  Episode.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 14/10/22.
//

import Foundation

struct Episode {
    let name: String
    let number: String
    let season: String
    let summary: String
    let imageUrl: String?
    
    init(episodeResponse: EpisodeResponse) {
        self.name = episodeResponse.name
        self.number = String(episodeResponse.number)
        self.season = String(episodeResponse.season)
        self.summary = episodeResponse.summary ?? ""
        self.imageUrl = episodeResponse.image?.original
    }
    
    init(episodeViewModel: EpisodeCollectionViewModel) {
        self.name = episodeViewModel.name ?? ""
        self.number = episodeViewModel.number
        self.season = episodeViewModel.season
        self.summary = episodeViewModel.summary
        self.imageUrl = episodeViewModel.imageUrl
    }
}
