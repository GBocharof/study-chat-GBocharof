//
//  UITableView.swift
//  studyChat
//
//  Created by Gleb Bocharov on 28.10.2021.
//

import UIKit

extension UITableView {
    func scrollToBottom(isAnimated: Bool = true) {
        
        DispatchQueue.main.async {
            let section = self.numberOfSections - 1
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection: section) != 0 ? self.numberOfRows(inSection: section) - 1 : 0,
                section: section)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
