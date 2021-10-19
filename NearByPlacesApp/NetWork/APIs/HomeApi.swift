//
//  HomeApi.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import Alamofire
import PromiseKit

class HomeApi: Api {
    
    enum APIRouter: Requestable {
        
        case getLocation(HomeApi, lat: Double, long: Double )
        case getPhoto(HomeApi, venueID: String)
        
        var baseUrl: URL {
            return URL(string: "https://api.foursquare.com/v2")!
        }
        
        var path: String {
            switch self {
            case .getLocation:
                return "/venues/search"
            case .getPhoto(_, let venueID):
                return "venues/\(venueID)/photos"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getLocation:
                return .post
            case .getPhoto:
                return .get
            }
        }
        
        var isWWWFormUrlEncoded: Bool? {
            return true
        }
        
        var header: [String : String]? {
            return nil
        }
        
        var parameters: Parameters? {
            switch self {
            case let .getLocation(_, lat, long):
                return [
                    "client_id":"4V5SLNWK2XWSOZKPTHEOOJR3VQAPQNKZHD1RZX3IBLRF4YGU" ,
                    "client_secret": "IYQ5QF4KR24NLJNAZLZCQRT3OIZJU1WVNNE4MBJJL4WVNBM3" ,
                    "v" : "20211017" ,
                    "ll" : "\(lat),\(long)"]
            case .getPhoto:
                return [
                    "client_id": "4V5SLNWK2XWSOZKPTHEOOJR3VQAPQNKZHD1RZX3IBLRF4YGU",
                    "client_secret": "IYQ5QF4KR24NLJNAZLZCQRT3OIZJU1WVNNE4MBJJL4WVNBM3",
                    "v" : "20211017" ,
                    "group": "venue"]
            }
        }
        
    }
}


extension HomeApi {
    
    func getLocationsList( lat: Double , long: Double) -> Promise<NearLocationsResponse> {
        return fireRequestWithSingleResponse(requestable: APIRouter.getLocation(self, lat: lat, long: long))
    }
    
    func getPhotosWithVenue(_ venueID: String) -> Promise<PhotosResponse> {
        return fireRequestWithSingleResponse(requestable: APIRouter.getPhoto(self, venueID: venueID))
    }
    
}

