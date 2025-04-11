import SwiftUI

enum Frequency {
    case daily
    case weekly (days: Set<Int>) // ad esempio {1,3,5} per Monday, Wednesday, Friday
    case monthly
}

enum TrackingMethod: String {
    case time
    case count
    case bool
}

struct Category {
    let name: String
    let systemImage: String

    static let meditation = Category(name: "Meditation", systemImage: "apple.meditate.circle")
    static let sport = Category(name: "Sport", systemImage: "figure.run")
    static let nutrition = Category(name: "Nutrition", systemImage: "fork.knife")
    static let learning = Category(name: "Learning", systemImage: "books.vertical.fill")
    static let finance = Category(name: "Finance", systemImage: "dollarsign.gauge.chart.lefthalf.righthalf")
    static let arts = Category(name: "Creativity", systemImage: "theatermask.and.paintbrush.fill")
    static let social = Category(name: "Social", systemImage: "person.3.fill")
    static let health = Category(name: "Health", systemImage: "bolt.heart")
    static let fun = Category(name: "Fun", systemImage: "bubbles.and.sparkles.fill")
    static let other = Category(name: "Other", systemImage: "square.and.pencil.circle.fill") //TODO discuss
}

protocol Habit{
    var name: String {get set}
    var category: Category {get set}
    var trackingMethod: TrackingMethod {get set}
    var frequency: Frequency {get set}
    var isCompleted: Bool {get set}
    
}

//MARK: Tutti i vari sotto-habit -

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
