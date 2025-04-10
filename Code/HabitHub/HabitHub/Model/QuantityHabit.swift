//
//  QuantityHabit.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 10/04/25.
//

import SwiftUI

class QuantityHabit: Habit, Identifiable{
    var id: UUID = UUID()
    var name: String
    var category: Category
    var trackingMethod: TrackingMethod
    var frequency: Frequency
    var isCompleted: Bool
    
    var goal: Int
    var totalProgress: [QuantityProgress] = []
    
    init(name: String, category: Category, frequency: Frequency, goal: Int) {
        self.name = name
        self.category = category
        self.frequency = frequency
        
        self.trackingMethod = TrackingMethod.count
        self.isCompleted = false
        
        self.goal = goal
        self.totalProgress.append(QuantityProgress(progress: 0))
    }
}
