//
//  UIView+EX.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 19/10/2021.
//

import UIKit


extension UIView {
    
    
    func instanceFromNib(name: String) -> UIView {
        let bundle  = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: name , bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight , .flexibleWidth ]
        addSubview(view)
        return view
    }

}
