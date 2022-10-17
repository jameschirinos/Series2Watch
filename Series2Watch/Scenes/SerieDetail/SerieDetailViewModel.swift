//
//  SerieDetailViewModel.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 15/10/22.
//

import Foundation

protocol SerieDetailVMProtocol {
    var gotSerieDetail: ((Serie) -> ())? { get set }
    var isLoading: ((Bool) -> ())? { get set }
    
    func getSerieDetail() async
    func goToEpisodeDetail(episode: Episode)
}

class SerieDetailViewModel: SerieDetailVMProtocol {
    
    var seriesAPI: SeriesAPIProtocol
    var serieID: Int
    var serieName: String
    var gotSerieDetail: ((Serie) -> ())?
    var isLoading: ((Bool) -> ())?
    var coordinator: EpisodeDetailCoordinatorProtocol?
    
    init(seriesAPI: SeriesAPIProtocol, serieID: Int, serieName: String, coordinator: EpisodeDetailCoordinatorProtocol) {
        self.seriesAPI = seriesAPI
        self.serieID = serieID
        self.serieName = serieName
        self.coordinator = coordinator
    }
    
    func getSerieDetail() async {
        do {
            isLoading?(true)
            let serieResponse = try await seriesAPI.getSerieDetail(id: serieID)
            isLoading?(false)
            let serie = Serie(response: serieResponse)
            gotSerieDetail?(serie)
        } catch {
            print(error)
        }
    }
    
    func goToEpisodeDetail(episode: Episode) {
        coordinator?.openEpisodeDetail(episode: episode)
    }
    
}
