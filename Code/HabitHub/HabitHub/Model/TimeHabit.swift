//
//  TimeHabit.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 10/04/25.
//

import SwiftUI

class TimeHabit: Habit, Identifiable{
    var id: UUID = UUID()
    var name: String
    var category: Category
    var trackingMethod: TrackingMethod
    var frequency: Frequency
    var isCompleted: Bool
    
    var goal: TimeInterval
    
    var totalProgress: [TimeProgress] = []
    
    init(name: String, category: Category, frequency: Frequency, goal: TimeInterval) {
        self.name = name
        self.category = category
        self.frequency = frequency
        
        self.trackingMethod = TrackingMethod.time
        self.isCompleted = false
        
        self.goal = goal
        
        self.totalProgress.append(TimeProgress(progress: 0))
    }
}
