import SwiftUI

class HabitTemplate <T>{ // TODO ma serve davvero?
    var name: String 
    var category: Category
    var trackingMethod: TrackingMethod

    var goal: T
    let date: DateFormatter

    
    
    var progress: [String : T] = [:]

    var frequency: Frequency?
    var isCompleted: Bool 
    
    

    init(name: String, category: Category, goal: T, trackingMethod: TrackingMethod, prog: T) {
        self.name = name
        self.category = category
        
        self.trackingMethod = trackingMethod
        self.isCompleted = false
        
        self.goal = goal

        self.date = DateFormatter()
        self.date.dateStyle = .short
        self.date.timeStyle = .none

        self.progress[self.date.string(from: Date())] = prog
    }

    init(name: String, category: Category, frequency: Frequency, goal: T, trackingMethod: TrackingMethod, prog: T) {
        self.name = name
        self.category = category
        self.frequency = frequency
        
        self.trackingMethod = trackingMethod
        self.isCompleted = false
        
        self.goal = goal

        self.date = DateFormatter()
        self.date.dateStyle = .short
        self.date.timeStyle = .none

        self.progress[self.date.string(from: Date())] = prog
    }
}
