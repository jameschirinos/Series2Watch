//
//  SearchSerieViewModel.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 16/10/22.
//

import Foundation

protocol SearchSerieVMProtocol {
    var gotSerieSearch: (([Serie]) -> ())? { get set }
    var isLoading: ((Bool) -> ())? {get set}
    
    func searchSerie(text: String) async
    func goToSerieDetail(serieID: Int, serieName: String)
}

class SearchSerieViewModel: SearchSerieVMProtocol {
    
    var gotSerieSearch: (([Serie]) -> ())?
    var isLoading: ((Bool) -> ())?
    var coordinator: SearchCoordinator
    var serieAPI: SeriesAPIProtocol
    
    init(coordinator: SearchCoordinator, serieAPI: SeriesAPIProtocol) {
        self.coordinator = coordinator
        self.serieAPI = serieAPI
    }
    
    func searchSerie(text: String) async {
        isLoading?(true)
        let seriesResult = try? await serieAPI.searchSerie(text: text)
        isLoading?(false)
        let series = seriesResult?.map({ Serie.init(response: $0.show) }) ?? []
        gotSerieSearch?(series)
    }
    
    func goToSerieDetail(serieID: Int, serieName: String) {
        coordinator.openSerieDetail(serieID: serieID, serieName: serieName)
    }
    
}
