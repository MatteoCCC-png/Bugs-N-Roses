import SwiftUI

enum Frequency: String, Codable, Identifiable, CaseIterable{
    case daily
    case weekly
    case monthly
    
    var id: String{self.rawValue}
}

enum TrackingMethod: String, Codable, Identifiable{
    case time
    case count
    case bool
    
    var id: String{self.rawValue}
}

struct Category: Codable{
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
    
    static let all: [Category] = [
            meditation, sport, nutrition, learning, finance,
            arts, social, health, fun, other
        ]
}

protocol Habit{
    var name: String {get set}
    var category: Category {get set}
    var trackingMethod: TrackingMethod {get set}
    var frequency: Frequency {get set}
    var isCompleted: Bool {get set}
    
    var notifyMe: Bool {get set}
    var notificationTime: Date {get set}
    
    func calculateProgressPercent() -> Double
    
}


struct SuggestedHabit: Identifiable {
    let id = UUID() // Make it identifiable for .sheet(item:...)
    let name: String
    let category: Category
    let suggestedMethod: TrackingMethod
    // Use optional specific goals for clarity
    let suggestedQuantityGoal: Int?
    let suggestedTimeGoal: TimeInterval?
    // Boolean goal is implied by suggestedMethod == .bool

    // Helper to create a display string for the goal
    var goalString: String {
        switch suggestedMethod {
        case .time:
            return (suggestedTimeGoal ?? 0).formattedShort() + " / day"
        case .count:
            return "\(suggestedQuantityGoal ?? 0) times / day" // Or use unit like pages/steps etc.
        case .bool:
            return "Complete daily"
        }
    }

    // Convenience initializers (optional but helpful)
    static func time(_ name: String, category: Category, goal: TimeInterval) -> SuggestedHabit {
        SuggestedHabit(name: name, category: category, suggestedMethod: .time, suggestedQuantityGoal: nil, suggestedTimeGoal: goal)
    }
    static func quantity(_ name: String, category: Category, goal: Int) -> SuggestedHabit {
        SuggestedHabit(name: name, category: category, suggestedMethod: .count, suggestedQuantityGoal: goal, suggestedTimeGoal: nil)
    }
    static func boolean(_ name: String, category: Category) -> SuggestedHabit {
        SuggestedHabit(name: name, category: category, suggestedMethod: .bool, suggestedQuantityGoal: nil, suggestedTimeGoal: nil)
    }
}
