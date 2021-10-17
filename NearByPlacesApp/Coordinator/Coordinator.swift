//
//  Coordinator.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] {get set}
    var naviagtionController: UINavigationController {get set}
    func start()
}


extension UIViewController {
    
    static func instatiate(_ storyboardName: String) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name:storyboardName , bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }

}
