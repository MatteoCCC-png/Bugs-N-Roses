//
//  QuantityProgress.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 10/04/25.
//

import SwiftUI
import SwiftData

@Model
class QuantityProgress: Progress{
    
    var day: Date
    var progress: Int
    
    
    init(progress: Int) {
        self.day = Date()
        self.progress = progress
    }
    
    
    func incrementProgress(num: Int) {
        progress += num
    }
}

