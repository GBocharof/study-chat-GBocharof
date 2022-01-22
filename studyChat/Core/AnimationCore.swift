//
//  AnimationCore.swift
//  studyChat
//
//  Created by Gleb Bocharov on 30.11.2021.
//

import Foundation
import UIKit

enum AnimationKeys {
    case shake
    case stopShake
    case bubbles
}

extension AnimationKeys {
    public var key: String {
        switch self {
        case .shake:
            return "shake"
        case .stopShake:
            return "stopShake"
        case .bubbles:
            return "bubbles"
        }
    }
}

protocol AnimationCore {
    func getLogoLayer() -> CAEmitterLayer
}

class AnimationCoreImpl: AnimationCore {

    lazy var logoCell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "chatEmitterLogo")?.cgImage
        cell.scale = 0.06
        cell.scaleRange = 0.05
        cell.emissionRange = .pi
        cell.emissionLatitude = 50
        cell.emissionLatitude = 50
        cell.lifetime = 3.0
        cell.birthRate = 15
        cell.velocity = -30
        cell.velocityRange = -20
        cell.yAcceleration = 40
        cell.xAcceleration = 10
        cell.spin = -0.5
        cell.spinRange = 1.0
        return cell
    }()
    
    lazy var logoLayer: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.emitterShape = CAEmitterLayerEmitterShape.circle
        layer.beginTime = CACurrentMediaTime()
        layer.emitterCells = [logoCell]
        return layer
    }()
    
    func getLogoLayer() -> CAEmitterLayer {
        return logoLayer
    }
}
