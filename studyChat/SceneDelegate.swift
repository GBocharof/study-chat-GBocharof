//
//  SceneDelegate.swift
//  studyChat
//
//  Created by Gleb Bocharov on 11.01.2022.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let rootAssembly = RootAssembly()
    
    lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        return gesture
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        
        let navigationController = rootAssembly.presentationAssembly.rootViewController()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        window.addGestureRecognizer(longPressGesture)
        self.window = window
        
    }
    
    @objc
    func didLongPress(_ sender: UILongPressGestureRecognizer) {
        rootAssembly.serviceAssembly.animationService.showLogoAnimation(sender: sender)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

