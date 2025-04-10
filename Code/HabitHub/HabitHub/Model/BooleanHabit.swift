import SwiftUI

class BooleanHabit: Habit, Identifiable{
    var id: UUID = UUID()
    var name: String 
    var category: Category
    var trackingMethod: TrackingMethod
    var frequency: Frequency 
    var isCompleted: Bool
    
    var goal: Bool
    
    var progress: [BooleanProgress] = []
        
    
    
    init(name: String, category: Category, frequency: Frequency) {
        self.name = name
        self.category = category
        self.frequency = frequency
        
        self.trackingMethod = TrackingMethod.bool
        self.isCompleted = false
        
        self.goal = true
         
        self.progress.append(BooleanProgress(progress: false))
    }
}
