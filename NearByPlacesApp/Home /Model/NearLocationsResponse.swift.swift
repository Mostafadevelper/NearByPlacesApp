//
//  NearLocationsResponse.swift.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import Foundation



struct NearLocationsResponse: Codable {
    
    let meta: Meta?
    let response: VenuesResponse?

    enum CodingKeys: String, CodingKey {
            case meta = "meta"
            case response = "response"
    }

}

struct Meta : Codable {
    
    let code : Int?
    let requestId : String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case requestId = "requestId"
    }
}

struct VenuesResponse: Codable {
    
    let venues : [Venue]?
    
    enum CodingKeys: String, CodingKey {
        case venues = "venues"
    }
}


struct Venue : Codable {
    
    let id : String?
    let location : Location?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case location = "location"
        case name = "name"
    }
    
}


struct VenuePage : Codable {
    
    let id : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
}


struct Location : Codable {
    
    let formattedAddress : [String]?
    
    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formattedAddress"
    }
    
}




