//
//  Progress.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 10/04/25.
//

import SwiftUI

protocol Progress {
    var day: Date { get }
}


//MARK: - Tutti i vari sotto-progressi


class BooleanProgress: Progress {
    var day: Date
    var progress: Bool
    
    init(progress: Bool) {
        self.day = Date()
        self.progress = progress
    }
}

class QuantityProgress:Progress {
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

class TimeProgress: Progress{
    var day: Date
    var progress: TimeInterval //Time interval è essenzialmente un Double che rappresenta un intervallo temporale in secondi (es. progress = 3600  equivale a dire un'ora)
    
    init(progress: TimeInterval) {
        self.day = Date()
        self.progress = progress
    }
    
}

