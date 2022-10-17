//
//  EpisodeDetailViewModel.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 17/10/22.
//

import Foundation

protocol EpisodeDetailVMProtocol {
    var gotEpisodeDetail: ((Episode) -> ())? { get set }
    var isLoading: ((Bool) -> ())? { get set }
    
    func getEpisodeInfo()
}

class EpisodeDetailViewModel: EpisodeDetailVMProtocol {
    
    var gotEpisodeDetail: ((Episode) -> ())?
    var episode: Episode
    var isLoading: ((Bool) -> ())?
    var coorinator: EpisodeDetailCoordinatorProtocol?
    
    init(episode: Episode) {
        self.episode = episode
    }
    
    func getEpisodeInfo() {
        gotEpisodeDetail?(self.episode)
    }
    
}
