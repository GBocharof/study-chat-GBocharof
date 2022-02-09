//
//  ExtConversaionListViewController.swift
//  studyChat
//
//  Created by Gleb Bocharov on 08.11.2021.
//

import Foundation
import CoreData
import UIKit

//extension ConversationsListViewController: ThemesViewControllerDelegate {
//
//    @objc
//    func logThemeChanging(selectedTheme: UIColor) {
//        print(selectedTheme)
//    }
//
//    @objc
//    func themesViewController(_ controller: UIViewController, didSelectTheme selectedTheme: UIColor) {
//        controller.view.backgroundColor = selectedTheme
//        logThemeChanging(selectedTheme: selectedTheme)
//    }
//}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            fatalError()
        }
    }
}

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomConversationTableViewCell else {
            return UITableViewCell()
        }
        let channel = self.fetchedResultsController.object(at: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: channel)
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presentationAssembly = presentationAssembly else { return }
        let channel = self.fetchedResultsController.object(at: indexPath)
        let conversationVC = presentationAssembly.conversationViewController(channel: channel)
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = self.fetchedResultsController.object(at: indexPath)
            print(channel.identifier)
            guard let firebaseService = self.firebaseService else { return }
            firebaseService.deleteChannel(channelId: channel.identifier)
        }
    }
}

extension ConversationsListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimation
    }
}

protocol ConversationsListVC {
    
    var profileButton: UIButton { get }
    func updateProfileLogoFromDB()
    func updateProfileLogo(with image: UIImage)
    func updateProfileLogo(with imageString: String)
}

extension ConversationsListViewController: ConversationsListVC {
   
    func updateProfileLogo(with image: UIImage) {
        profileButton.setImage(image, for: .normal)
    }
    
    func updateProfileLogo(with imageString: String) {
        if let imageData = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: imageData)
            profileButton.setImage(image, for: .normal)
        }
    }
    
    func updateProfileLogoFromDB() {
        if let serviceAssembly = serviceAssembly {
            serviceAssembly.saveLoadService.loadData { [weak self] in
                switch $0 {
                case .success(let profileData):
                    if let imageData = Data(base64Encoded: profileData.photo, options: .ignoreUnknownCharacters) {
                        self?.profileButton.setImage(UIImage(data: imageData), for: .normal)
                    }
                case .failure:
                    print("error loading profile data")
                }
            }
        }
    }
}
