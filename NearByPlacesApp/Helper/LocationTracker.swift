//
//  LocationTracker.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import Foundation
import CoreLocation
import UIKit

typealias LocateMeCallback = (_ location: CLLocation?) -> Void

class LocationTracker: NSObject {
    
    override init() {}

    static private var privateShared :LocationTracker? = LocationTracker()
    class func shared() -> LocationTracker { // change class to final to prevent override
        guard let uwShared = privateShared else {
            privateShared = LocationTracker()
            return privateShared!
        }
        return uwShared
    }
    private var lastLocation: CLLocation?
    private var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.activityType = .automotiveNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 500
        return locationManager
    }()
    private var isShowAlertOfPermission = true
    private  var locateMeCallback: LocateMeCallback?
    
    private var isCurrentLocationAvailable: Bool {
        if lastLocation != nil, lastLocation!.timestamp.timeIntervalSinceNow < 10 {
            return true
        }
        return false
    }
    
    private func enableLocationServices() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // Disable location features
            if isShowAlertOfPermission {
                UIApplication.getTopViewController()!.showAlert("Attension", "go to app Setting", addCancelAction: true, okayHandler: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        self.isShowAlertOfPermission = true
                    }
                },  {
                    self.isShowAlertOfPermission = true
                })
            }
            self.isShowAlertOfPermission = false
            print("Fail permission to get current location of user")
        case .authorizedWhenInUse:
            // Enable basic location features
            enableMyWhenInUseFeatures()
        case .authorizedAlways:
            // Enable any of your app's location features
            enableMyAlwaysFeatures()
        @unknown default:
            break
        }
    }
    
    private   func enableMyWhenInUseFeatures() {
        locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        escalateLocationServiceAuthorization()
        locationManager.distanceFilter = 500
    }
    
    private func escalateLocationServiceAuthorization() {
        // Escalate only when the authorization is set to when-in-use
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func enableMyAlwaysFeatures() {
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func locateMeOnLocationChange(distanceFilter: CLLocationDistance = 500,callback: @escaping LocateMeCallback) {
        self.locationManager.distanceFilter = distanceFilter
        self.locateMeCallback = callback
        if lastLocation == nil {
            enableLocationServices()
        } else {
            callback(lastLocation)
        }
    }
    
    private func startTracking() {
        enableLocationServices()
    }
    
    class func stopUpdateing(){
        LocationTracker.privateShared?.locationManager.stopUpdatingLocation()
        LocationTracker.privateShared = nil
    }
}


// MARK: - CLLocationManagerDelegate
extension LocationTracker: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        self.locateMeCallback?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        enableLocationServices()
    }
}

