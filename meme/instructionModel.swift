//
//  instructionModel.swift
//  meme
//
//  Created by 潘傑恩 on 2023/7/17.
//

import Foundation

struct InstructionSlide: Identifiable, Equatable {
    let id = UUID()
    let description: String
    let imageUrl: String
    let tag: Int
    
    static let firstSlide = InstructionSlide(description: "add widget to your app", imageUrl: "demo", tag: 0)
    
    static let slides: [InstructionSlide] = [
        InstructionSlide(description: "touch and hold a widget or an empty area until the apps jiggle and tap the ➕ in the upper-left corner", imageUrl: "slide1", tag: 0),
        InstructionSlide(description: "Search Giggle", imageUrl: "addWidgetScreen", tag: 1),
        InstructionSlide(description: "Choose a widget size, then tap to add widget", imageUrl: "chooseWidgetSize", tag: 2),
        InstructionSlide(description: "Done!! 🥳🥳 Each day, a random 🐱 meme will be selected and changed", imageUrl: "doneScreen", tag: 3),
        InstructionSlide(description: "If you like the meme, tap the widget, and you can download it to your photos", imageUrl: "placeDetailScreen", tag: 4),
        InstructionSlide(description: "Stay tuned. More functionality will be added to this app 💪", imageUrl: "placeholder", tag: 5)
    ]
}
