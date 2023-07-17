//
//  ContentView.swift
//  meme
//
//  Created by 潘傑恩 on 2023/7/10.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var routerManager: NavigationRouter
    @State private var slideIndex = 0
    
    private let slides: [InstructionSlide] = InstructionSlide.slides
    private let dotAppearance = UIPageControl.appearance()
    
    var body: some View {
        NavigationStack(path: $routerManager.routes) {
            TabView(selection: $slideIndex) {
                ForEach(slides) { slide in
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(slide.imageUrl)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(32)
                            .padding()
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        
                        Text(slide.description)
                            .font(.subheadline)
                            .padding(.bottom)

                        Spacer(minLength: 64)
                    }
                    .tag(slide.tag)
                }
            }
            .animation(.easeOut, value: slideIndex)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .onAppear {
                dotAppearance.currentPageIndicatorTintColor = .yellow
                dotAppearance.pageIndicatorTintColor = .lightGray
            }

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
