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
    var totalProgress: [TimeProgress]
    
    var dailyProgressPercent: [Double]

    var todaysProgress: TimeProgress? {
        totalProgress.first { progress in
            Calendar.current.isDateInToday(progress.day)
        }
    }

    var currentProgressToday: TimeInterval {
        todaysProgress?.progress ?? 0.0 // Default to 0.0 if no entry exists
    }
   
    init(name: String, category: Category, frequency: Frequency, goal: TimeInterval, notifyMe: Bool, notificationTime: Date) {
        self.name = name
        self.category = category
        self.frequency = frequency
        
        self.notifyMe = notifyMe
        self.notificationTime = notificationTime
        
        self.trackingMethod = TrackingMethod.time
        self.isCompleted = false
        
        
        self.goal = goal
        
        self.totalProgress = []
        
        self.dailyProgressPercent = []
    }
    
    
    func setTotalProgress(progr: TimeProgress){
        totalProgress.append(progr)
        let update: Double = calculateProgressPercent( )
        
        dailyProgressPercent.append(update)
    }
    
    func calculateProgressPercent() -> Double {
        var percent:Double = 0.0
        var countingReachedGoal: Int = 0
        
        self.totalProgress.forEach { (progress) in
            if progress.progress == self.goal {
                countingReachedGoal += 1
            }
        }
        
        
        percent = Double(countingReachedGoal) / Double(self.totalProgress.count) * 100
        
        return percent
    }
    
    func updateProgressPercent() {
        self.dailyProgressPercent.append(calculateProgressPercent())
    }
}
