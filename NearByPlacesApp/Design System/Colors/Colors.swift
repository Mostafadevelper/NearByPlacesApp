//
//  Colors.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import UIKit

extension DesignSystem {
    
    enum Colors: String {
        case primary = "primary"
        case secondary = "secondary"
        case darkLine = "darkLine"
        case bgColor = "bgColor"
        case headerBGColor = "headerBGColor"
        
        var color: UIColor {
            return UIColor(named: self.rawValue)!
        }
    }
}
