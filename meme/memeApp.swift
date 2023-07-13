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
                    if url.host() == "photodetail" {
                        print("photo detail trigger")
                        routerManager.push(to: .photoDetail(id: "123"))
                    }
                }
        }
    }
}
