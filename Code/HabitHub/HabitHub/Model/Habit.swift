import SwiftUI

class Habit: Identifiable {
    var id = UUID()
    var name: String
    var category: Category
    var trackingMethod: TrackingMethod 
    var frequency: Frequency
    var progress: Double
    var isCompleted: Bool
    
    enum Frequency: String {
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

    
    
    init(name: String, description: String, startDate: Date, endDate: Date, frequency: Frequency) {
        self.name = name
        self.description = description
        self.frequency = frequency
        self.progress = 0.0
        self.isCompleted = false
    }
}
