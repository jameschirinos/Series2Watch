//
//  AllSeriesViewModel.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 14/10/22.
//

import Foundation

protocol AllSeriesVMProtocol {
    var gotAllSeries: (([Serie]) -> ())? { get set }
    var isLoading: ((Bool) -> ())? { get set }
    var seriesAPI: SeriesAPIProtocol? { get set }
    func getAllSeries() async
    func goToDetail(serieID: Int, serieName: String)
}

class AllSeriesViewModel: AllSeriesVMProtocol {
    var gotAllSeries: (([Serie]) -> ())?
    var isLoading: ((Bool) -> ())?
    var seriesAPI: SeriesAPIProtocol?
    var coordinator: AllSeriesCoordinator?

    init(seriesAPI: SeriesAPIProtocol?, coordinator: AllSeriesCoordinator) {
        self.seriesAPI = seriesAPI
        self.coordinator = coordinator
    }
    
    func getAllSeries() async {
        do {
            isLoading?(true)
            let seriesResponse = try await seriesAPI?.getAllSeries()
            isLoading?(false)
            let series = seriesResponse?.map({ Serie.init(response: $0) }) ?? []
            gotAllSeries?(series)
        } catch {
            print(error)
        }
        
    }
    
    func goToDetail(serieID: Int, serieName: String) {
        coordinator?.openSerieDetail(serieID: serieID, serieName: serieName)
    }
    
}
