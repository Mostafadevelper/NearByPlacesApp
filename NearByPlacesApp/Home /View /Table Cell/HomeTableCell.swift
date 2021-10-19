//
//  HomeTableCell.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//

import UIKit

class HomeTableCell: UITableViewCell {

    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var formattedAddressLB: UILabel!
    @IBOutlet weak var iconIMG: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var listCellViewModel: HomeCellViewModel? {
        didSet {
            iconIMG.loadImage(urlName: listCellViewModel?.imageUrl)
            nameLB.text = listCellViewModel?.name
            formattedAddressLB.text = listCellViewModel?.formattedAddress
        }
    }


    
}
