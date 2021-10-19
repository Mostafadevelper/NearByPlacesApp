//
//  HomeNaviagtionView.swift
//  Millensys
//
//  Created by Mostafa on 19/09/2021.
//  Copyright © 2021 Hussein Kishk. All rights reserved.
//

import UIKit

enum AlertType {
    case error
    case empty
}

class AlertView: UIView {
    
    //MARK:- Layout:-
    @IBOutlet private weak var iconIMG: UIImageView!
    @IBOutlet private weak var messageLB: UILabel!
   
    //MARK:- Init Func
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let _ =   self.instanceFromNib(name: "AlertView")
        loadFonts()
    }
    
    //MARK:- To Load The View :-
//    func instanceFromNib() -> UIView {
//        let bundle  = Bundle.init(for: type(of: self))
//        let nib = UINib(nibName: "AlertView" , bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
//        view.frame = bounds
//        view.autoresizingMask = [.flexibleHeight , .flexibleWidth ]
//        addSubview(view)
//        return view
//    }
    
    
}

extension AlertView {
    
  private  func loadFonts(){
        self.messageLB.font = UIFont.fonts(name: .regular, size: .size_xl)
    }
    
    func loadAlert(_ type: AlertType = .error){
        switch type {
        case .error:
            self.messageLB.text = "Something went wrong !!"
            self.iconIMG.image = UIImage(named: "error")
        case .empty:
            self.messageLB.text = "No data found !!"
            self.iconIMG.image = UIImage(named: "empty")
        }
    }
    
}
