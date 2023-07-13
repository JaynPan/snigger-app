//
//  routeFinder.swift
//  meme
//
//  Created by 潘傑恩 on 2023/7/13.
//

import Foundation

enum DeepLinkURLs: String {
    case photodetail
}

struct RouteFinder {
    func find(from url: URL) async -> Route? {
        guard let host = url.host() else { return nil }
        
        switch DeepLinkURLs(rawValue: host) {
        case .photodetail:
            let queryParams = url.queryParameters
            guard let id = queryParams?["id"] as? String else {
                return nil
            }
                        
            return .photoDetail(id: id)
        default:
            return nil
        }
        
    }
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value?.replacingOccurrences(of: "+", with: " ")
        }
    }
}
