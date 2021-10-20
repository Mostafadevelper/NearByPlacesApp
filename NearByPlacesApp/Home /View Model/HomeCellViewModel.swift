//
//  HomeCellViewModel.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//


import Foundation

class HomeCellViewModel {
    
    //MARK:- Variable:-
    private let homeApi = HomeApi()
    var updateLocation: ((String) -> ())!
    var name: String?
    var imageUrl: String?
    var formattedAddress: String?
    var id: String?
    
    init(){}
    
    init(
        id: String?,
        name: String?,
        formattedAddress: String?,
        imageUrl: String? ){
            self.id = id
            self.name = name
            self.formattedAddress = formattedAddress
            self.imageUrl = imageUrl
        }
    
    func fetchPhotoOfVenuoWithId(_ id: String?) {
        
        homeApi.getPhotosWithVenue(id ?? "").get { response in
            guard let items = response.response?.photos?.items else {return}
            self.updatePhotes(photto: items )
        }.catch { [weak self] error in
            guard let _ = self else {return}
            print(error)
        }
    }
    
    private func updatePhotes(photto: [Items] ) {
        
        let prefix = photto.first?.prefix ?? ""
        let imageSize = "\(photto.first?.width ?? 100 )x\(photto.first?.height ?? 100)"
        let suffix = photto.first?.suffix ?? ""
        self.imageUrl = prefix + imageSize + suffix
        self.updateLocation(self.imageUrl ?? "")
    }
    
}



