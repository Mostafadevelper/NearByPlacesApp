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

//extension UITableViewCell {
//    var tableView: UITableView? {
//        self.next(of: UITableView.self)
//    }
//
//    var indexpath: IndexPath? {
//        self.tableView?.indexPath(for: self)
//    }
//}

extension UITableView {
    
    func register<T>(cell: T.Type) where T: UITableViewCell {
        register(cell, forCellReuseIdentifier: cell.cellIdentifier)
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
    
    ///Get visible cell height
//    var visibleCellsHeight: CGFloat {
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//        return visibleCells.reduce(0) {
//            $0 + $1.frame.height
//        }
//    }
//
    
    /// Check if cell at the specific section and row is visible
    /// - Parameters:
    /// - section: an Int reprenseting a UITableView section
    /// - row: and Int representing a UITableView row
    /// - Returns: True if cell at section and row is visible, False otherwise
//    func isCellVisible(section: Int, row: Int) -> Bool {
//        guard let indexes = self.indexPathsForVisibleRows else {
//            return false
//        }
//        return indexes.contains {
//            $0.section == section && $0.row == row
//        }
//    }
    
//    func update(action:(()->())? = nil) {
//        DispatchQueue.main.async
//            {
//                UIView.animate(withDuration:0) {[weak self] in
//                    guard let self = self else {return}
//                    self.beginUpdates()
//                    if let action = action {
//                        action()
//                    }
//                    self.endUpdates()
//                    self.layoutIfNeeded()
//                }
//        }
//    }
}

//extension UIResponder {
//    /**
//     * Returns the next responder in the responder chain cast to the given type, or
//     * if nil, recurses the chain until the next responder is nil or castable.
//     */
//    func next<U: UIResponder>(of type: U.Type = U.self) -> U? {
//        return self.next.flatMap({ $0 as? U ?? $0.next() })
//    }
//}
