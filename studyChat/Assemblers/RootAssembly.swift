//
//  RootAssembly.swift
//  studyChat
//
//  Created by Gleb Bocharov on 18.11.2021.
//

import Foundation
import UIKit

class RootAssembly {
    
    lazy var presentationAssembly: PresentationAssembly = PresentationAssemblyImpl(serviceAssembly: self.serviceAssembly)
    lazy var serviceAssembly: ServiceAssembly = ServiceAssemblyImpl(coreAssembly: self.coreAssembly)
    private lazy var coreAssembly: CoreAssembly = CoreAssemblyImpl()
    
}
