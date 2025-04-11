//
//  BooleanProgress.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 10/04/25.
//

import SwiftUI
import SwiftData

@Model
class BooleanProgress: Progress {
    var day: Date
    var progress: Bool
    
    init(progress: Bool) {
        self.day = Date()
        self.progress = progress
    }
}
