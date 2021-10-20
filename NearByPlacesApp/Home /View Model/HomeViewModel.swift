//
//  HomeViewModel.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import Foundation

enum OperationalMode: String {
    case realTime = "RealTime"
    case singleUpdate = "Single Update"
}

class HomeViewModel {
    
    //MARK:- Variable & Constants:-
    private let homeApi = HomeApi()
    private var nearLocations : [Venue] = [Venue]()
    var cellViewModels: [HomeCellViewModel] = [HomeCellViewModel]()
    var locationsList :(([HomeCellViewModel])->())!
    var loading :((Bool) ->())!
    var error: ((String)-> ())!
    private var operatorMode: OperationalMode = .realTime
    var isFetch = false
    var isRefresh: ((Bool) -> ())!
    
    //MARK:- To Get Current Location Of Users
    func fetchLocations(_ mode: OperationalMode = AppUpdateStatus.getCurrentUpdateType()){
        
        self.operatorMode = mode
        LocationTracker.shared().locateMeOnLocationChange(callback: { [weak self] location in
            guard location != nil else {
                return }
            switch mode {
            case .singleUpdate:
                LocationTracker.stopUpdateing()
            default:
                break
            }
            self?.fetchData(lat: (location?.coordinate.latitude)!, long: (location?.coordinate.longitude)!)
        })
    }
    
    //MARK:- NetWork
   private func fetchData(lat: Double = 40.7099 , long: Double = -73.9622){
        if !isFetch { self.loading?(true) }
        homeApi
            .getLocationsList(
                lat: lat,
                long: long
            ).get { [weak self] responseData in
            guard let self = self else { return }
            self.loading(false)
            self.isRefresh(false)
            self.isFetch = false
            self.processFetchedResult(result: responseData.response?.venues ?? [])
        }.catch { [weak self] error in
            guard let self = self else { return }
            self.loading(false)
            self.isRefresh(false)
            self.error(error.localizedDescription)
        }
    }
    
    //MARK:- Setup Cell View Model
    private func processFetchedResult(result : [Venue]) {
        
        self.nearLocations = result
        var list = [HomeCellViewModel]()
        for location in nearLocations {
            list.append(createCellViewModel(at: location))
        }
        self.cellViewModels = list
        
        self.locationsList(self.cellViewModels)
    }
    
    //MARK:- Create Cell View Model
    private func createCellViewModel(at result: Venue) -> HomeCellViewModel {
        
        HomeCellViewModel(id: result.id, name: result.name, formattedAddress: result.location?.formattedAddress?.first, imageUrl: nil)
    }
    
    //MARK:- To Switch between location mode
    func switchBetweenMode() -> String {
        guard operatorMode == .realTime else {
            self.operatorMode = .realTime
            AppUpdateStatus.setCurrentUpdateType(operatorMode)
            self.fetchLocations(self.operatorMode)
            return operatorMode.rawValue
        }
        self.operatorMode = .singleUpdate
        AppUpdateStatus.setCurrentUpdateType(operatorMode)
        self.fetchLocations(self.operatorMode)
        return operatorMode.rawValue
    }
    
}
