//
//  HomeTableCell.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import UIKit

class HomeTableCell: UITableViewCell {
    
    //MARK:- Varibale
    lazy private var viewModel: HomeCellViewModel  = {
        return HomeCellViewModel()
    }()

    //MARK:- Layout:-
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var formattedAddressLB: UILabel!
    @IBOutlet weak var iconIMG: UIImageView!
    
    //MARK:- Life Cycle:-
    override func awakeFromNib() {
        super.awakeFromNib()
        loadFonts()
        bind()
    }
    
    //MARK:- View Model Home cell
    var listCellViewModel: HomeCellViewModel? {
        didSet {
            self.setup()
        }
    }
    
    //MARK:- To Load Fonts
    private func loadFonts(){
        self.nameLB.font = UIFont.fonts(name: .meduim, size: .size_xl)
        self.formattedAddressLB.font = UIFont.fonts(name: .regular, size: .size_m)
    }
    
}

//MARK:- Network:-
extension HomeTableCell {
    
    //MARK:- Setup & Load Data
   fileprivate func setup(){
       iconIMG.loadImage(urlName: listCellViewModel?.imageUrl)
       nameLB.text = listCellViewModel?.name
       formattedAddressLB.text = listCellViewModel?.formattedAddress
       if listCellViewModel?.imageUrl == nil {
       viewModel.fetchPhotoOfVenuoWithId(listCellViewModel?.id)
       }
    }
    
    //MARK:- To Bind Changes From APi
    func bind(){
        viewModel.updateLocation = { [weak self] image in
            guard let self = self else {return}
            print("=======================")
            print(image)
            self.listCellViewModel?.imageUrl = image
            self.iconIMG.loadImage(urlName:  self.listCellViewModel?.imageUrl )
        }
    }
}
