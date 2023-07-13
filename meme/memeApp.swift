//
//  memeApp.swift
//  meme
//
//  Created by 潘傑恩 on 2023/7/10.
//

import SwiftUI

@main
struct memeApp: App {
    @StateObject private var routerManager = NavigationRouter()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(routerManager)
                .onOpenURL { url in
                    Task {
                        await handleDeeplink(from: url)
                    }
                }
        }
    }
}

extension memeApp {
    func handleDeeplink(from url: URL) async {
        let routeFinder = RouteFinder()
        if let route = await routeFinder.find(from: url) {
            routerManager.push(to: route)
        }
    }
}
