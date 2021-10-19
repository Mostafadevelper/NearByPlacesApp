//
//  HomeTableCell.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import UIKit

class HomeTableCell: UITableViewCell {
    
    //MARK:- Layout:-
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var formattedAddressLB: UILabel!
    @IBOutlet weak var iconIMG: UIImageView!
    
    //MARK:- Life Cycle:-
    override func awakeFromNib() {
        super.awakeFromNib()
        loadFonts()
    }
    
    //MARK:- View Model Home cell
    var listCellViewModel: HomeCellViewModel? {
        didSet {
            iconIMG.loadImage(urlName: listCellViewModel?.imageUrl)
            nameLB.text = listCellViewModel?.name
            formattedAddressLB.text = listCellViewModel?.formattedAddress
        }
    }
    
    //MARK:- To Load Fonts
    private func loadFonts(){
        self.nameLB.font = UIFont.fonts(name: .meduim, size: .size_xl)
        self.formattedAddressLB.font = UIFont.fonts(name: .regular, size: .size_m)
    }
    
}
