//
//  LocationTracker.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import Foundation
import CoreLocation
import UIKit

typealias LocateMeCallback = (_ location: CLLocation?,_ address:String) -> Void

class LocationTracker: NSObject {
    
    static var shared :LocationTracker? = LocationTracker()
    private var lastLocation: CLLocation?
    private var locations: [CLLocation] = []
//    private var previousLocation: CLLocation?
    private var localizedLocationAddress = ""
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
    
    func locateMeOnLocationChange(distanceFilter: CLLocationDistance = 10,callback: @escaping LocateMeCallback) {
        self.locationManager.distanceFilter = distanceFilter
        self.locateMeCallback = callback
        if lastLocation == nil {
            enableLocationServices()
//            self.getAdressName(coords: lastLocation!)
        } else {
            callback(lastLocation,localizedLocationAddress)
        }
    }
    
    private   func startTracking() {
        enableLocationServices()
    }
    
    private    func stopTracking() {
        
    }
     override init() {}
    
    
   func getAdressName(coords: CLLocation)   {
          var addressString = ""
          
          CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
              if error != nil { print("Hay un error") }
              else {
                  let place = placemark! as [CLPlacemark]
                  if place.count > 0 {
                      let place = placemark![0]
                      if place.thoroughfare != nil {
                          addressString = addressString + place.thoroughfare! + ", "
                      }
                      if place.subThoroughfare != nil {
                          addressString = addressString + place.subThoroughfare! + "\n"
                      }
                      if place.locality != nil {
                          addressString = addressString + place.locality! + " - "
                      }
                      if place.postalCode != nil {
                          addressString = addressString + place.postalCode! + "\n"
                      }
                      if place.subAdministrativeArea != nil {
                          addressString = addressString + place.subAdministrativeArea! + " - "
                      }
                      if place.country != nil {
                          addressString = addressString + place.country!
                        self.localizedLocationAddress = addressString
                      }
                    
                  }
              }
            self.localizedLocationAddress = addressString
            self.locateMeCallback?(coords,self.localizedLocationAddress)

            print(self.localizedLocationAddress)
            print(addressString)
          }

      }
}


// MARK: - CLLocationManagerDelegate
extension LocationTracker: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.locations.append(location)
//        previousLocation = lastLocation
        lastLocation = location
        self.getAdressName(coords: location)
        manager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        enableLocationServices()
    }
}

