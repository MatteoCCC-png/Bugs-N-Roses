import SwiftUI
import SwiftData

@Model
class BooleanHabit: Habit, Identifiable{
    var id: UUID = UUID()
    var name: String
    
    var category: Category
    var trackingMethod: TrackingMethod
    var frequency: Frequency 
    var isCompleted: Bool
    var notifyMe: Bool
    var notificationTime: Date
    
    var goal: Bool
    
    @Relationship(deleteRule: .cascade)
    var progress: [BooleanProgress]
        
    
    
    init(name: String = "", category: Category, frequency: Frequency, notifyMe: Bool, notificationTime: Date) {
        self.name = name
        self.category = category
        self.frequency = frequency
        
        self.trackingMethod = TrackingMethod.bool
        self.isCompleted = false
        
        self.goal = true
        self.notifyMe = notifyMe
        self.notificationTime = notificationTime
        self.progress = []
    }
}
