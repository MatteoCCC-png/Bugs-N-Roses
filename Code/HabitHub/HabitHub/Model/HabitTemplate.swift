import SwiftUI

/*enum Frequency: String {
    case daily
    case weekly
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
    static let reading = Category(name: "Learning", systemImage: "books.vertical.fill")
    // static let home = Category(name: "Home", systemImage: "house") // TODO maybe indoor?
    static let finance = Category(name: "Finance", systemImage: "dollarsign.gauge.chart.lefthalf.righthalf")
    static let arts = Category(name: "Creativity", systemImage: "theatermask.and.paintbrush.fill")
    static let social = Category(name: "Social", systemImage: "person.3.fill")
    static let health = Category(name: "Health", systemImage: "bolt.heart.fill")
    static let fun = Category(name: "Fun", systemImage: "bubbles.and.sparkles.fill")
    static let other = Category(name: "Other", systemImage: "square.and.pencil.circle.fill") //TODO discuss
}
 */

class HabitTemplate <T>{
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
