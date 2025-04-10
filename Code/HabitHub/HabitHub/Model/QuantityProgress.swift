//
//  QuantityProgress.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 10/04/25.
//

import SwiftUI

class QuantityProgress {
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

