//
//  AppUpdateStatus.swift.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 20/10/2021.
//

import Foundation

class AppUpdateStatus {
    
    class func getCurrentUpdateType() -> OperationalMode {
        let defaults =  UserDefaults.standard
        let value = defaults.object(forKey: "SaveAppMode1") as? String
        switch value {
        case "RealTime":
            return OperationalMode.realTime
        case "Single Update":
            return OperationalMode.singleUpdate
        default:
            return OperationalMode.realTime
        }
    }
    
    class func setCurrentUpdateType(_ mode: OperationalMode = .realTime){
        let defaults =  UserDefaults.standard
        defaults.set(mode.rawValue , forKey: "SaveAppMode1")
        defaults.synchronize()
    }
}
