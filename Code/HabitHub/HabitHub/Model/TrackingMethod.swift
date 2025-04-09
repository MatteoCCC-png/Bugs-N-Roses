import SwiftUI

protocol TrackingMethod{
    var name: String { get }
    var icon: String { get }
    var description: String { get }
    var color: String { get }
    
//    func trackHabit(habit: Habit, date: Date)
//    func getTrackingData(habit: Habit) -> [Date]
}

class progress: Identifiable {
    var id = UUID()
    var method: String
    var date: Date
    var value: Double
    
    init(method: String) {
        self.method = method

        self.date = Date()
        self.value = 0.0
    }
}