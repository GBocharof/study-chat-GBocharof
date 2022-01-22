//
//  ExtConversationViewController.swift
//  studyChat
//
//  Created by Gleb Bocharov on 26.10.2021.
//

import UIKit
import CoreData

extension ConversationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextView.textColor == .gray {
            messageTextView.text = ""
            messageTextView.textColor = .black
            sentButton.isEnabled = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        setPlaceHolderInfoTextView()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            sentButton.isEnabled = false
        } else {
            sentButton.isEnabled = true
        }
    }
    
    func setPlaceHolderInfoTextView() {
        if messageTextView.text.isEmpty {
            messageTextView.text = "Write a message..."
            messageTextView.textColor = .gray
        } else {
            messageTextView.textColor = .black
        }
    }
}

extension ConversationViewController {
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ConversationViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    
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

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = self.fetchedResultsController.object(at: indexPath)
        guard let userId = userId else { return UITableViewCell() }
        if userId == message.senderId {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: sentCellIdentifier, for: indexPath) as? SentMessageTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: message, networkService: networkService)
            cell.layoutIfNeeded()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: inboxCellIdentifier, for: indexPath) as? InboxMessageTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: message, networkService: networkService)
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ConversationViewController: ImageCollectionDelegate {
    
    func setSelectedImage(imageUrl: String) {
        sentMessage(content: imageUrl)
    }
}
