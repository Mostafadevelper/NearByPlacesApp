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
        
        var parameters: Parameters? {
            switch self {
            case let .getLocation(_, lat, long):
                return [
                    "client_id": Keys.client_id ,
                    "client_secret": Keys.client_secret ,
                    "v": Keys.date ,
                    "ll": "\(lat),\(long)"]
            case .getPhoto:
                return [
                    "client_id": Keys.client_id,
                    "client_secret": Keys.client_secret,
                    "v": Keys.date ,
                    "group": Keys.group]
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

