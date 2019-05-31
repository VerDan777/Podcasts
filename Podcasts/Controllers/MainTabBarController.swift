//
//  MainTabBarController.swift
//  Podcasts
//
//  Created by We//Yes on 18/05/2019.
//  Copyright © 2019 Daniil Vereschagin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .purple;

        
        viewControllers = [
            createNavController(for: PodcastsSearchViewController(), title: "Favorietes", image: #imageLiteral(resourceName: "favorites"), largeTitle: true),
            createNavController(for: UIViewController(), title: "Search", image: #imageLiteral(resourceName: "search"), largeTitle: nil),
            createNavController(for: UIViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"), largeTitle: true)
        ];
        // Do any additional setup after loading the view.
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage, largeTitle: Bool?) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController);
        if largeTitle != nil {
            navController.navigationBar.prefersLargeTitles = true
        }
        rootViewController.navigationItem.title = title;
        navController.tabBarItem.title = title;
        navController.tabBarItem.image = image;
        return navController;
    }

}
