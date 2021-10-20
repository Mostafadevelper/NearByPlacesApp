//
//  UIImageView+EX.swift.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 18/10/2021.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func loadImage(urlName: String?){
        
        if urlName != nil {
            self.alpha = 0.0
            self.sd_setImage(with: URL(string: urlName!), placeholderImage: UIImage(named: "defaultIMG"), options: .highPriority, progress: { (value, toValue, nil) in
            }) { (_, _, _, _) in
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.alpha = 1.0
                    self?.layoutIfNeeded()
                }
            }
        }else {
            self.image = UIImage(named: "defaultIMG")
        }
    }
}
