//
//  TimeProgress.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 10/04/25.
//

import SwiftUI
import SwiftData

@Model
class TimeProgress: Progress{
    var day: Date
    var progress: TimeInterval //Time interval  è essenzialmente un Double che rappresenta un intervallo temporale in secondi (es. progress = 3600  equivale a dire un'ora)
    
    init(progress: TimeInterval) {
        self.day = Date()
        self.progress = progress
    }
    
}

