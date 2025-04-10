import SwiftUI

enum Frequency: String, Codable {
    case daily
    case weekly
    case monthly
}

enum TrackingMethod: String, Codable {
    case time
    case count
    case bool
}

struct Category: Codable{
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

protocol Habit{
    var name: String {get set}
    var category: Category {get set}
    var trackingMethod: TrackingMethod {get set}
    var frequency: Frequency {get set}
    var isCompleted: Bool {get set}
    
    var notifyMe: Bool {get set}
    var notificationTime: Date {get set}
    
}
