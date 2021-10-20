//
//  TableView+EX.swift
//  NearByPlacesApp
//
//  Created by Mostafa on 17/10/2021.
//


import UIKit

protocol IdentifiableCell: AnyObject {
    static var cellIdentifier: String { get }
}

extension UITableViewCell: IdentifiableCell {
    static var cellIdentifier: String {
        "\(self)"
    }
}


extension UITableView {
    
    func register<T>(cell: T.Type) where T: UITableViewCell {
        register(cell.nib, forCellReuseIdentifier: cell.cellIdentifier)
    }
    
    func dequeueReusableCell<T: IdentifiableCell>(with cell: T.Type) -> T? {
        dequeueReusableCell(withIdentifier: cell.cellIdentifier) as? T
    }
    
    func dequeue<Cell: UITableViewCell>() -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else {
            fatalError("Error in cell")
        }
        
        return cell
    }
    
}


