//
//  route.swift
//  meme
//
//  Created by 潘傑恩 on 2023/7/13.
//

import Foundation
import SwiftUI

protocol PhotoItem {
    var id: String { get }
}

enum Route {
    case photoDetail(id: String)
}

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case (.photoDetail(let lhsId), .photoDetail(let rhsId)):
            return lhsId == rhsId
        }
    }
}

extension Route: View {
    
    var body: some View {
        
        switch self {
        case .photoDetail(let item):
            return photoDetailView()
        }
    }
}
