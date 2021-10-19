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

//typealias Action = (Any) -> ()

class HomeViewModel {
    
    //MARK:- Variable & Constants:-
    private let homeApi = HomeApi()
    private var nearLocations : [Venue] = [Venue]()
    var cellViewModels: [HomeCellViewModel] = [HomeCellViewModel]()
    var locationsList :(([HomeCellViewModel])->())!
    var loading :((Bool) ->())!
    var error: ((String)-> ())!
    var modeAction: ((String)-> ())!
    //    var loading :Action!
    //    var error: Action!
    //    var modeAction: Action!
    
    var operatorMode: OperationalMode = .singleUpdate
    var isFetch = false
    private var coordinate: String = ""
    var isRefresh: ((Bool) -> ())!
    
    
    func fetchLocations(_ mode: OperationalMode = .singleUpdate){
        
        self.operatorMode = mode
        LocationTracker.shared?.locateMeOnLocationChange(callback: { [weak self] location, _ in
            guard location != nil else {
                return }
            switch mode {
            case .realTime:
                self?.modeAction?(mode.rawValue)
            case .singleUpdate:
                self?.modeAction?(mode.rawValue)
            }
            self?.fetchData(lat: (location?.coordinate.latitude)!, long: (location?.coordinate.longitude)!)
            //            self?.fetchData()
        })
    }
    
    //MARK:- NetWork
    func fetchData(lat: Double = 40.7099 , long: Double = -73.9622){
        if !isFetch {  self.loading?(true) }
        homeApi.getLocationsList(lat: lat, long: long).get { [weak self] responseData in
            guard self != nil else { return }
            self?.loading(false)
            self?.isRefresh(false)
            self?.isFetch = false
            self?.processFetchedResult(result: responseData.response?.venues ?? [])
        }.catch { error in
            self.loading(false)
            self.isRefresh(false)
            self.error(error.message)
        }
    }
    
    func fetchPhotoOfVenuoWithId() {
        
        //        for (index , location) in nearLocations.enumerated() {
        //            homeApi.getPhotosWithVenue(location.id ?? "").get { response in
        //                self.updatePhotes(photto: response.response?.photos?.items ?? [] , index: index)
        //            }.catch { error in
        //                print(error)
        //            }
        //        }
        
        homeApi.getPhotosWithVenue(nearLocations.first?.id ?? "").get { response in
            self.updatePhotes(photto: response.response?.photos?.items ?? [] , index: 0)
        }.catch { error in
            print(error)
        }
    }
    
    func updatePhotes(photto: [Items] , index: Int) {
        
        let prefix = photto.first?.prefix ?? ""
        let imageSize = "\(photto.first?.width ?? 100 )x\(photto.first?.height ?? 100)"
        let suffix = photto.first?.suffix ?? ""
        self.cellViewModels[index].imageUrl = prefix + imageSize + suffix
        
        print("=============================================================")
        print(cellViewModels[index].imageUrl)
        self.locationsList(self.cellViewModels)
    }
    
    private func processFetchedResult(result : [Venue]) {
        
        self.nearLocations = result
        var list = [HomeCellViewModel]()
        for location in nearLocations {
            list.append(createCellViewModel(at: location))
        }
        self.cellViewModels = list
        
        self.locationsList(self.cellViewModels)
        fetchPhotoOfVenuoWithId()
    }
    
    private func createCellViewModel(at result: Venue) -> HomeCellViewModel {
        
        return HomeCellViewModel(
            name: result.name ?? "",
            imageUrl: "imageURl",
            formattedAddress: result.location?.formattedAddress?.first ?? "")
    }
    
    //MARK:- To Switch between location mode
    func switchBetweenMode() -> String {
        guard operatorMode != .singleUpdate else {
            self.operatorMode = .realTime
            self.fetchLocations(self.operatorMode)
            return operatorMode.rawValue
        }
        self.operatorMode = .singleUpdate
        self.fetchLocations(self.operatorMode)
        return operatorMode.rawValue
    }
    
    
}
