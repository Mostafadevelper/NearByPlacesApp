//
//  AppDelegate.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 16/10/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadApp()
        
        return true
    }
    
    private func loadApp(){
        let navigationController = UINavigationController()
        let mainVC = MainCoordinator(naviagtionController: navigationController)
        mainVC.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}

