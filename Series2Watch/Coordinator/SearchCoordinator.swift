//
//  SearchCoordinator.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 16/10/22.
//

import Foundation
import UIKit

class SearchCoordinator: Coordinator, SerieDetailCoordinatorProtocol, EpisodeDetailCoordinatorProtocol {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = SearchSerieViewModel(coordinator: self, serieAPI: SeriesAPI())
        let vc = SearchSerieViewController(viewModel: vm)
        vc.navigationItem.title = "Search"
        navigationController.pushViewController(vc, animated: false)
    }
    
    func openSerieDetail(serieID: Int, serieName: String) {
        let vm = SerieDetailViewModel(seriesAPI: SeriesAPI(), serieID: serieID, serieName: serieName, coordinator: self)
        let vc = SerieDetailViewController(viewModel: vm)
        vc.navigationItem.title = serieName
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openEpisodeDetail(episode: Episode) {
        let vm = EpisodeDetailViewModel(episode: episode)
        let vc = EpisodeDetailViewController(viewModel: vm)
        vc.navigationItem.title = episode.name
        navigationController.pushViewController(vc, animated: true)
    }
}
