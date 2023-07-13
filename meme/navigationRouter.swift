//
//  navigationRouter.swift
//  meme
//
//  Created by 潘傑恩 on 2023/7/13.
//

import SwiftUI
import Foundation

final class NavigationRouter: ObservableObject {
    @Published var routes = [Route]()
    
    func push(to screen: Route) {
        routes.append(screen)
    }
    
    func goBack() {
        _ = routes.popLast()
    }
    
    func reset() {
        routes = []
    }
}
