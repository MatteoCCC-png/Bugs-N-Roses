//
//  TimeHabit.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 10/04/25.
//

import SwiftUI
import SwiftData

@Model
class TimeHabit: Habit, Identifiable{
    var id: UUID = UUID()
    var name: String
    
    
    var category: Category
    var trackingMethod: TrackingMethod
    var frequency: Frequency
    var isCompleted: Bool
    var notifyMe: Bool
    var notificationTime: Date
    
    var goal: TimeInterval
    
    @Relationship(deleteRule: .cascade)
    var totalProgress: [TimeProgress] = []
    
    init(name: String, category: Category, frequency: Frequency, goal: TimeInterval, notifyMe: Bool, notificationTime: Date) {
        self.name = name
        self.category = category
        self.frequency = frequency
        
        self.notifyMe = notifyMe
        self.notificationTime = notificationTime
        
        self.trackingMethod = TrackingMethod.time
        self.isCompleted = false
        
        
        self.goal = goal
        
        self.totalProgress.append(TimeProgress(progress: 0))
    }
}
