//
//  QuantityHabit.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 10/04/25.
//

import SwiftUI
import SwiftData

@Model
class QuantityHabit: Habit, Identifiable{
    var id: UUID = UUID()
    var name: String
    var category: Category
    var trackingMethod: TrackingMethod
    var frequency: Frequency
    var isCompleted: Bool
    var notifyMe: Bool
    var notificationTime: Date 
    
    var goal: Int
    
    @Relationship(deleteRule: .cascade)
    var totalProgress: [QuantityProgress]
    
    init(name: String, category: Category, frequency: Frequency, goal: Int, notifyMe: Bool, notificationTime: Date) {
        self.name = name
        self.category = category
        self.frequency = frequency
        
        self.notifyMe = notifyMe
        self.notificationTime = notificationTime
        
        self.trackingMethod = TrackingMethod.count
        self.isCompleted = false
        
        self.goal = goal
        self.totalProgress = []
    }
}
