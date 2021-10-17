//
//  MainCoordinator.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    var naviagtionController: UINavigationController

    func start() {
        let homeVC = HomeViewController.instatiate(StoryboardName.main)
        self.naviagtionController.pushViewController(homeVC, animated: false)
    }
    
    init(naviagtionController: UINavigationController){
        self.naviagtionController = naviagtionController
        self.naviagtionController.navigationBar.isHidden = true
    }
    
    
}
