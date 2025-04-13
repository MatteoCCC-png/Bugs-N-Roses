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
    var totalProgress: [BooleanProgress]
        
    var dailyProgressPercent: [Double]
    
    init(name: String , category: Category, frequency: Frequency, notifyMe: Bool, notificationTime: Date) {
        self.name = name
        self.category = category
        self.frequency = frequency
        
        self.trackingMethod = TrackingMethod.bool
        self.isCompleted = false
        
        self.goal = true
        self.notifyMe = notifyMe
        self.notificationTime = notificationTime
        self.totalProgress = []
        self.dailyProgressPercent = []
    }
    
    func setTotalProgress(progr: BooleanProgress){
        totalProgress.append(progr)
        var update: Double = calculateProgressPercent( )
        
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
