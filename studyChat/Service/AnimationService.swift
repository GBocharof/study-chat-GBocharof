//
//  AnimationService.swift
//  studyChat
//
//  Created by Gleb Bocharov on 30.11.2021.
//

import Foundation
import UIKit

protocol AnimationService {
    
    func startShakeButton(for button: UIButton)
    func stopShakeButton(for button: UIButton)
    func showLogoAnimation(sender: UILongPressGestureRecognizer)
    
}

class AnimationServiceImpl: AnimationService {
    
    let animationCore: AnimationCore
    
    init(animationCore: AnimationCore) {
        self.animationCore = animationCore
    }
    
    func showLogoAnimation(sender: UILongPressGestureRecognizer) {
        guard let view = sender.view else { return }
       
        let logoLayer = animationCore.getLogoLayer()
        logoLayer.emitterPosition = sender.location(in: view)
        view.layer.addSublayer(logoLayer)
        
        switch sender.state {
        case .began:
            logoLayer.lifetime = 1.0
        case .changed:
            logoLayer.lifetime = 1.0
        default:
            logoLayer.lifetime = 0.0
        }
    }
    
    func startShakeButton(for button: UIButton) {
        
        let rotate = CAKeyframeAnimation(keyPath: #keyPath(CALayer.transform))
        rotate.values = [
            CATransform3DMakeRotation(-Double.pi / 10, 0, 0, 1),
            CATransform3DMakeRotation(Double.pi / 10, 0, 0, 1)
        ]
        rotate.keyTimes = [0.0, 1.0]
        
        let changePosition = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        changePosition.values = [
            CGPoint(x: button.center.x - 5, y: button.center.y),
            CGPoint(x: button.center.x + 5, y: button.center.y),
            CGPoint(x: button.center.x, y: button.center.y - 5),
            CGPoint(x: button.center.x, y: button.center.y + 5)
        ]
        changePosition.keyTimes = [0.0, 0.25, 0.5, 0.75]
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.autoreverses = true
        group.animations = [rotate, changePosition]
        
        button.layer.add(group, forKey: AnimationKeys.shake.key)
    }
    
    func stopShakeButton(for button: UIButton) {
        
        let originTranform = CATransform3DIdentity
        guard let currentTransform = button.layer.presentation()?.transform else { return }
        guard let currentPosition = button.layer.presentation()?.position else { return }
        
        let returnToOriginRotation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.transform))
        returnToOriginRotation.values = [
            currentTransform,
            originTranform
        ]
        returnToOriginRotation.keyTimes = [0.0, 1.0]
        
        let returnToOriginPosition = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        returnToOriginPosition.values = [
            currentPosition,
            CGPoint(x: button.center.x, y: button.center.y)
        ]
        returnToOriginPosition.keyTimes = [0.0, 1.0]
        
        let group = CAAnimationGroup()
        group.duration = 1
        group.animations = [returnToOriginRotation, returnToOriginPosition]
        
        button.layer.add(group, forKey: AnimationKeys.shake.key)
    }
}

class TransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        containerView.addSubview(toView)
        toView.alpha = 0.0
        
        UIView.animate(withDuration: 1.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.2,
                       animations: {
            toView.alpha = 1.0
        },
                       completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
