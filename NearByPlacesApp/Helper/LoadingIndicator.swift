//
//  LoadingIndicator.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 18/10/2021.
//

import UIKit

class LoadingIndicator: UIView {
    
    public static var shared = LoadingIndicator()
    
    
    
    private var indicator : UIActivityIndicatorView =  {
        
        let indicator = UIActivityIndicatorView()
        indicator.color = DesignSystem.Colors.primary.color
        indicator.backgroundColor = .clear
        
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            // Fallback on earlier versions
        }
//        indicator.textInputMode = ""
        indicator.translatesAutoresizingMaskIntoConstraints = false

        return indicator

    }()
    
    func show(for view: UIView)  {
        
        indicator.startAnimating()
        view.addSubview(indicator)
//        indicator.frame = CGRect(x: view.center.x, y: view.center.y, width: 60, height: 60)
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 60).isActive = true
        indicator.bringSubviewToFront(view)
    }
        
    func hide (){
        indicator.stopAnimating()
    }
}
