//
//  TabBar.swift
//  Series2Watch
//
//  Created by James Junior Chirinos Pinedo on 16/10/22.
//

import Foundation
import UIKit
import Rswift

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    func setupVCs() {
        let allSeriesNav = createNavController(title: "Series", image: R.image.movies()!)
        let allSeriesCoordinator = AllSeriesCoordinator(navigationController: allSeriesNav)
        allSeriesCoordinator.start()
        
        
        
        let searchNav = createNavController(title: "Search", image: R.image.search()!)
        let searchCoordinator = SearchCoordinator(navigationController: searchNav)
        searchCoordinator.start()
        
        viewControllers = [
            allSeriesNav,
            searchNav        ]
    }
    
    func createNavController(title: String,
                             image: UIImage) -> UINavigationController {
        let navController = UINavigationController()
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
    
}
