//
//  PhotosResponse.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 18/10/2021.
//

struct PhotosResponse: Codable {
    
    let response: Response?
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
    
}


struct Response: Codable {
    
    let photos: Photos?
    
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
    }
}

struct Photos: Codable {
    
    let items: [Items]?
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
}

struct Items: Codable {
    
    let prefix: String?
    let suffix: String?
    let width: Int?
    let height: Int?
    
    enum CodingKeys: String, CodingKey {
        case prefix
        case suffix
        case width
        case height
    }
    
}

