//
//  ExtProfileViewController.swift
//  studyChat
//
//  Created by Gleb Bocharov on 21.10.2021.
//

import UIKit

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        view().imageView.image = info[.editedImage] as? UIImage
        dismiss(animated: true)
        editModeOn()
        enableSaveButtons()
    }
    
    @objc
    func alertPhotoOrCamera() {
        
        serviceAssembly?.animationService.startShakeButton(for: view().editImageButton)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera",
                                                style: .default,
                                                handler: { _ in self.openCamera()}))
        alertController.addAction(UIAlertAction(title: "Photo Library",
                                                style: .default,
                                                handler: { _ in self.openLibrary()}))
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: { _ in self.serviceAssembly?.animationService.stopShakeButton(for: self.view().editImageButton)}))
        alertController.addAction(UIAlertAction(title: "Download",
                                                style: .default,
                                                handler: { _ in self.openPhotoCV()}))
        
        present(alertController, animated: true)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have a camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.serviceAssembly?.animationService.stopShakeButton(for: self.view().editImageButton)}))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func openLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.serviceAssembly?.animationService.stopShakeButton(for: self.view().editImageButton)}))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func openPhotoCV() {
        guard let presentationAssembly = presentationAssembly else { return }
        let controller = presentationAssembly.imageCollectionViewController(delegate: self)
        self.present(controller, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if view().infoTextView.textColor == .gray {
            view().infoTextView.text = ""
            view().infoTextView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        setPlaceHolderInfoTextView()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        enableSaveButtons()
        if textView.text.last == "\n" {
            textView.text.removeLast()
            textView.resignFirstResponder()
        }
    }
    
    func setPlaceHolderInfoTextView() {
        if view().infoTextView.text.isEmpty {
            view().infoTextView.text = "Type some info"
            view().infoTextView.textColor = .gray
        } else {
            view().infoTextView.textColor = .black
        }
    }
    
    func fillProfileData() {
        guard let profileData = profileData else { return }
        view().nameTextField.text = profileData.name
        view().infoTextView.text = profileData.info
        setPlaceHolderInfoTextView()
        if profileData.photo.isEmpty {
            view().imageView.image = UIImage(named: "defaultContact")
        } else {
            if let imageData = Data(base64Encoded: profileData.photo, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: imageData)
                view().imageView.image = image
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileViewController {
    func saveProfileData(dataSaver: SaveLoadService) {
        
        view().activityIndicator.startAnimating()
        lazy var failureAlert: UIAlertController = {
            let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { _ in
                self.editModeOff()
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { _ in self.saveProfileData(dataSaver: dataSaver)}))
            return alert
        }()
        
        guard let newProfileData = profileData else { return }
        
        if let imageData = view().imageView.image?.jpegData(compressionQuality: 1.0) {
            let imageString64 = imageData.base64EncodedString(options: .lineLength64Characters)
            if newProfileData.photo != imageString64 {
                newProfileData.photo = imageString64
            }
        } else {
            self.view().activityIndicator.stopAnimating()
            self.present(failureAlert, animated: true, completion: nil)
            return
        }
        
        if let text: String = view().infoTextView.text {
            let infoText = view().infoTextView.textColor == .gray ? "" : text
            if newProfileData.info != infoText {
                newProfileData.info = infoText
            }
        } else {
            self.view().activityIndicator.stopAnimating()
            self.present(failureAlert, animated: true, completion: nil)
            return
        }
        
        if let text: String = view().nameTextField.text {
            if newProfileData.name != text {
                newProfileData.name = text
            }
        }
        
        dataSaver.saveData(profileData: newProfileData) { [weak self] in
            switch $0 {
            case .success:
                self?.profileData = newProfileData
                let successAlert: UIAlertController = UIAlertController(title: "Данные сохранены", message: "", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { _ in
                    self?.delegate?.updateProfileLogo(with: newProfileData.photo)
                    self?.editModeOff()
                    self?.dismiss(animated: true, completion: nil)
                }))
                self?.view().activityIndicator.stopAnimating()
                self?.present(successAlert, animated: true, completion: nil)
            case .failure:
                self?.view().activityIndicator.stopAnimating()
                self?.present(failureAlert, animated: true, completion: nil)
            }
        }
    }
}

extension ProfileViewController: ImageCollectionDelegate {
    func setSelectedImage(imageUrl: String) {
        if #available(iOS 15.0, *) {
            fetchRequestImage(url: imageUrl)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 15.0, *)
    func fetchRequestImage(url: String) {
        Task {
            do {
                guard let networkService = networkService else { return }
                let image = try await networkService.sendImageRequest(url: url)
                updateProfileImge(with: image)
            }
        }
    }
    
    func updateProfileImge(with image: UIImage) {
        view().imageView.image = image
        editModeOn()
        enableSaveButtons()
    }
}

protocol ProfileViewControllerDelegate: UIViewController {
    func setDelegate(with delegate: ConversationsListVC)
}

extension ProfileViewController: ProfileViewControllerDelegate {
    public func setDelegate(with delegate: ConversationsListVC) {
        self.delegate = delegate
    }
}
