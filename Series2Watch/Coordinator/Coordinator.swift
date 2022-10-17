//
//  coordinator.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 16/10/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
}

protocol SerieDetailCoordinatorProtocol {
    func openSerieDetail(serieID: Int, serieName: String)
}

protocol EpisodeDetailCoordinatorProtocol {
    func openEpisodeDetail(episode: Episode)
}
