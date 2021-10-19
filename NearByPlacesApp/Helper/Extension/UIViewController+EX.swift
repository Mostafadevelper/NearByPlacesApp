//
//  UIViewController+EX.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import UIKit


extension UIViewController {
    
    typealias AlertCompletionHandler = () -> Void
    
    func showAlert(_ title:String,_ message: String, addCancelAction:Bool = true,  okayHandler: AlertCompletionHandler? = nil,_ cancelHandler: AlertCompletionHandler? = nil, okTitle: String = "Okey" ) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (alertAction) in
            if let okayHandler = okayHandler {
                okayHandler()
            }
        }))
        
        if (addCancelAction){
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { alert in
                if let cancelHandler = cancelHandler {
                    cancelHandler()
                }
            }))
        }
        weak var weakSelf = self
        DispatchQueue.main.async(execute: {
            //create textPrompt here in Main Thread
            weakSelf?.present(alert,animated: true,completion: nil)
        })
    }
    
}
