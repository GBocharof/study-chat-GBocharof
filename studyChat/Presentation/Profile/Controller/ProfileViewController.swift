//
//  ProfileViewController.swift
//  studyChat
//
//  Created by Gleb Bocharov on 22.09.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var saveLoadDataManager: SaveLoadService?
    var presentationAssembly: PresentationAssembly?
    var serviceAssembly: ServiceAssembly?
    var profileData: ProfileData?
    var networkService: NetworkService?
    var delegate: ConversationsListVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func view() -> ProfileViewImpl {
        guard let profileView = self.view as? ProfileViewImpl else { return ProfileViewImpl() }
        return profileView
    }
    
    func setupView() {
        view.backgroundColor = .white
        view().closeButton.addTarget(self, action: #selector(tapOnClose), for: .touchUpInside)
        view().editImageButton.addTarget(self, action: #selector(alertPhotoOrCamera), for: .touchUpInside)
        view().profileEditButton.addTarget(self, action: #selector(tapProfileEdit), for: .touchUpInside)
        view().cancelButton.addTarget(self, action: #selector(tapOnCancel), for: .touchUpInside)
        view().saveGCDButton.addTarget(self, action: #selector(tapSaveGCD), for: .touchUpInside)
        view().nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view().nameTextField.delegate = self
        view().infoTextView.delegate = self
        editModeOff()
        registerForKeyboardNotifications()
        
    }
    
    @objc
    func tapOnClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func tapOnCancel() {
        guard let profileData = profileData else { return }
        editModeOff()
        view().nameTextField.text = profileData.name
        view().infoTextView.text = profileData.info
        setPlaceHolderInfoTextView()
        if profileData.photo.isEmpty {
            self.view().imageView.image = UIImage(named: "defaultContact")
        } else {
            if let imageData = Data(base64Encoded: profileData.photo, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: imageData)
                self.view().imageView.image = image
            }
        }
    }
    
    @objc
    func tapProfileEdit() {
        editModeOn()
        view().nameTextField.becomeFirstResponder()
    }
    
    @objc
    func tapSaveGCD() {
        guard let dataSaver = saveLoadDataManager else { return }
        saveProfileData(dataSaver: dataSaver)
        view().saveGCDButton.isEnabled = false
    }
    
    @objc
    func kbWillShow(_ notification: Notification) {
        
        guard let info = notification.userInfo else { return }
        guard let value: NSValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let newFrame = value.cgRectValue
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: newFrame.height, right: 0.0)
        view().scrollView.contentInset = contentInsets
        view().scrollView.scrollIndicatorInsets = contentInsets
        view().scrollView.contentOffset = CGPoint(x: 0, y: view().nameTextField.frame.height)
    }
    
    @objc
    func kbWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        view().scrollView.contentInset = contentInsets
        view().scrollView.scrollIndicatorInsets = contentInsets
        view().scrollView.contentOffset = CGPoint.zero
    }

    @objc
    private func textFieldDidChange(textField: UITextField) {
        enableSaveButtons()
    }
    
    func editModeOn() {
        view().nameTextField.isEnabled = true
        view().infoTextView.isEditable = true
        showSaveButtons()
    }
    
    func editModeOff() {
        view().nameTextField.isEnabled = false
        view().infoTextView.isEditable = false
        hideSaveButtons()
        serviceAssembly?.animationService.stopShakeButton(for: view().editImageButton)
    }
    
    func showSaveButtons() {
        view().profileEditButton.isHidden = true
        view().saveGCDButton.isHidden = false
        view().cancelButton.isHidden = false
        disableSaveButtons()
    }
    
    func hideSaveButtons () {
        view().saveGCDButton.isHidden = true
        view().cancelButton.isHidden = true
        view().profileEditButton.isHidden = false
    }
    
    func disableSaveButtons() {
        view().saveGCDButton.isEnabled = false
    }
    
    func enableSaveButtons() {
        view().saveGCDButton.isEnabled = true
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
