//
//  ContentView.swift
//  meme
//
//  Created by 潘傑恩 on 2023/7/10.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var routerManager: NavigationRouter
    
    var body: some View {
        NavigationStack(path: $routerManager.routes) {
            Group {
                Button("hello world", action: {
                    routerManager.push(to: .photoDetail(id: "123"))
                })
            }
            .navigationTitle("Giggle")
            .navigationDestination(for: Route.self) { $0 }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NavigationRouter())
    }
}
