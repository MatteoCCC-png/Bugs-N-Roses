import SwiftUI
import Charts
import SwiftData

import SwiftUI
import SwiftData
import Charts // Import SwiftUI Charts

// MARK: - Helper Structs for Charting and Filtering

// Represents a single data point for the chart
struct ChartDataPoint: Identifiable {
    let id = UUID()
    let dayIndex: Int // Represents the day number (0, 1, 2...) based on sorted progress entries
    let percentage: Double // Progress percentage (0-100)
}

// Represents the options available in the habit filter Picker
enum HabitFilterOption: Identifiable, Hashable {
    case all
    case specific(id: UUID, name: String) // Use UUID for unique identification

    var id: String {
        switch self {
        case .all:
            return "all_habits_filter"
        case .specific(let id, _):
            return id.uuidString
        }
    }

    var displayName: String {
        switch self {
        case .all:
            return "All Habits"
        case .specific(_, let name):
            return name
        }
    }
}

// MARK: - Main Progress View Definition
struct ProgressiView: View {

    // Fetch all types of habits using SwiftData Queries
    @Query(sort: \BooleanHabit.name) private var booleanHabits: [BooleanHabit]
    @Query(sort: \QuantityHabit.name) private var quantityHabits: [QuantityHabit]
    @Query(sort: \TimeHabit.name) private var timeHabits: [TimeHabit]

    // State for the selected filter option in the Picker
    @State private var selectedHabitFilter: HabitFilterOption = .all

    // MARK: - Body

    var body: some View {
        NavigationView {
            // Use a ScrollView to accommodate content if it exceeds screen height
            ScrollView {
                // Check if *any* habits exist before showing content
                if booleanHabits.isEmpty && quantityHabits.isEmpty && timeHabits.isEmpty {
                    // Display a placeholder view if no habits have been created
                    ContentUnavailableView(
                       "No Habits Tracked",
                       systemImage: "chart.bar.xaxis.ascending",
                       description: Text("Add habits on the Home screen and track your progress to see statistics here.")
                    )
                    .padding(.top, 50) // Add some spacing from the navigation bar
                } else {
                    // Main VStack to layout the content vertically
                    VStack(alignment: .leading, spacing: 25) { // Increased spacing
                        Text("Your progress!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(Color("HomeTitleColor"))
                            .padding()

                        // --- Filter Picker ---
                        habitFilterPicker
                            .padding(.horizontal) // Add horizontal padding

                        // --- Chart Section ---
                        let data = chartData // Calculate data once to avoid redundant calculations
                         if !data.isEmpty {
                             // Display the chart if data is available
                             chartView(data: data) // Pass calculated data to the chart view
                                 .frame(height: 250) // Set a fixed height for the chart area
                                 .padding(.horizontal)
                         } else {
                              // Display a message if no progress data exists for the filter
                              Text(noDataMessage)
                                  .font(.caption)
                                  .foregroundColor(.secondary)
                                  .frame(height: 250) // Keep height consistent with chart
                                  .frame(maxWidth: .infinity, alignment: .center) // Center the text
                                  .padding(.horizontal)
                         }

                        // --- General Trend Section ---
                        generalTrendView
                            .padding(.horizontal)

                        Spacer() // Pushes content towards the top
                    }
                    .padding(.vertical) // Add vertical padding to the main VStack
                }
            }
            .foregroundStyle(Color("HomeTitleColor"))
        }
        // Ensure NavigationView style suits the platform (optional)
        // .navigationViewStyle(.stack) // Use stack style on iPad if desired
    }

    // MARK: - Subviews

    // View for the habit filter Picker
    private var habitFilterPicker: some View {
        HStack {
            Text("Show:") // Label for the picker
                .font(.callout)
                .foregroundColor(.secondary)
            // Picker bound to the selectedHabitFilter state variable
            Picker("Filter Habits", selection: $selectedHabitFilter) {
                // Iterate through the generated filter options
                ForEach(habitFilterOptions) { option in
                    // Display the name and tag each option with its value
                    Text(option.displayName).tag(option)
                }
            }
            .pickerStyle(.menu) // Use a menu style for the picker
            .tint(Color.accentColor) // Use the app's accent color
        }
    }

    // View for displaying the chart, accepts chart data as input
    private func chartView(data: [ChartDataPoint]) -> some View {
        GroupBox("Daily Progress (%)") { // GroupBox provides visual container
             Chart(data) { dataPoint in // Create a chart from the data points
                 // LineMark for the main line graph representation
                 LineMark(
                     x: .value("Day", dataPoint.dayIndex + 1), // X-axis: Day index (starting from 1)
                     y: .value("Progress", dataPoint.percentage) // Y-axis: Progress percentage
                 )
                 .interpolationMethod(.catmullRom) // Smooth the line connections
                 .foregroundStyle(Color.teal) // Color of the line

                 // PointMark to show distinct points on the line (optional)
                 PointMark(
                    x: .value("Day", dataPoint.dayIndex + 1),
                    y: .value("Progress", dataPoint.percentage)
                 )
                 .foregroundStyle(Color.teal) // Color of the points
                 .symbolSize(CGSize(width: 5, height: 5)) // Size of the points
             }
             // Configure the Y-axis scale (percentage 0-100)
             .chartYScale(domain: 0...100)
             // Configure the Y-axis labels and grid lines
             .chartYAxis {
                 AxisMarks(preset: .automatic, position: .leading) { value in
                    AxisGridLine() // Show grid lines
                    AxisTick() // Show tick marks
                    // Format the axis value labels to include "%"
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue)%")
                        }
                    }
                 }
             }
             // Configure the X-axis labels (optional, shows day index by default)
             // .chartXAxis { ... }
             .frame(height: 200) // Set the height of the chart within the GroupBox
         }
    }

    // View for displaying the general trend text
    private var generalTrendView: some View {
         GroupBox("General Trend") {
             Text(overallTrendText) // Display the calculated trend text
                 .font(.body)
                 .padding(.vertical, 5) // Add slight vertical padding
                 .frame(maxWidth: .infinity, alignment: .leading) // Ensure text aligns left
         }
     }


    // MARK: - Computed Properties for Data Processing

    // Message to display when chart data is empty but habits exist
     private var noDataMessage: String {
         switch selectedHabitFilter {
         case .all:
             return "No progress has been logged for any habits yet."
         case .specific(_, let name):
             return "No progress has been logged for '\(name)' yet."
         }
     }

    // Generates the array of options for the filter Picker
    private var habitFilterOptions: [HabitFilterOption] {
        var options: [HabitFilterOption] = [.all] // Start with "All Habits"
        // Create specific options from each habit type
        let specificOptions: [HabitFilterOption] =
            booleanHabits.map { .specific(id: $0.id, name: $0.name) } +
            quantityHabits.map { .specific(id: $0.id, name: $0.name) } +
            timeHabits.map { .specific(id: $0.id, name: $0.name) }

        // Append sorted specific habits to the options list
        options.append(contentsOf: specificOptions.sorted { $0.displayName < $1.displayName })
        return options
    }

    // Primary computed property to get the chart data based on the filter
    private var chartData: [ChartDataPoint] {
        switch selectedHabitFilter {
        case .all:
            // Calculate average progress across all habits if "All" is selected
            return calculateAverageProgressData()
        case .specific(let id, _):
            // Find the selected habit and calculate its specific progress data
            if let habit = booleanHabits.first(where: { $0.id == id }) {
                return calculateData(for: habit)
            } else if let habit = quantityHabits.first(where: { $0.id == id }) {
                return calculateData(for: habit)
            } else if let habit = timeHabits.first(where: { $0.id == id }) {
                return calculateData(for: habit)
            } else {
                return [] // Return empty if habit not found (shouldn't normally happen)
            }
        }
    }

    // MARK: - Data Calculation Functions

    // Calculates chart data points for a specific Boolean Habit
    private func calculateData(for habit: BooleanHabit) -> [ChartDataPoint] {
        // Sort progress entries by date to ensure correct order on chart
        let sortedProgress = habit.totalProgress.sorted { $0.day < $1.day }
        // Map each entry to a ChartDataPoint
        return sortedProgress.enumerated().map { index, progressEntry in
            // Boolean progress is either 100% (true) or 0% (false)
            let percentage = progressEntry.progress ? 100.0 : 0.0
            return ChartDataPoint(dayIndex: index, percentage: percentage)
        }
    }

    // Calculates chart data points for a specific Quantity Habit
    private func calculateData(for habit: QuantityHabit) -> [ChartDataPoint] {
        guard habit.goal > 0 else { return [] } // Prevent division by zero if goal is 0
        let sortedProgress = habit.totalProgress.sorted { $0.day < $1.day }
        return sortedProgress.enumerated().map { index, progressEntry in
            // Calculate percentage of goal achieved
            let rawPercentage = (Double(progressEntry.progress) / Double(habit.goal)) * 100.0
            // Clamp percentage between 0 and 100 (in case progress exceeds goal)
            let percentage = max(0.0, min(100.0, rawPercentage))
            return ChartDataPoint(dayIndex: index, percentage: percentage)
        }
    }

    // Calculates chart data points for a specific Time Habit
    private func calculateData(for habit: TimeHabit) -> [ChartDataPoint] {
        guard habit.goal > 0 else { return [] } // Prevent division by zero
        let sortedProgress = habit.totalProgress.sorted { $0.day < $1.day }
        return sortedProgress.enumerated().map { index, progressEntry in
            // Calculate percentage of time goal achieved
            let rawPercentage = (progressEntry.progress / habit.goal) * 100.0
            // Clamp percentage between 0 and 100
            let percentage = max(0.0, min(100.0, rawPercentage))
            return ChartDataPoint(dayIndex: index, percentage: percentage)
        }
    }

    // Calculates the average daily progress percentage across ALL habits
    private func calculateAverageProgressData() -> [ChartDataPoint] {
        // Use a dictionary to group percentages by the start of the day
        var dailyData: [Date: [Double]] = [:]

        // Helper function to process progress entries for any habit type
        func processHabitProgress<H: Habit, P: Progress>(habit: H, progressList: [P], goal: Double?) {
             // Need a valid goal > 0 for percentage calculation (treat boolean goal as 1.0)
             let validGoal = goal ?? (H.self == BooleanHabit.self ? 1.0 : 0.0)
             guard validGoal > 0 else { return }

            for progressEntry in progressList {
                // Normalize the date to the start of the day for consistent grouping
                let day = Calendar.current.startOfDay(for: progressEntry.day)
                var percentage: Double = 0.0

                 // Calculate percentage based on the concrete Progress type
                 switch progressEntry {
                 case let p as BooleanProgress:
                     percentage = p.progress ? 100.0 : 0.0
                 case let p as QuantityProgress:
                     percentage = max(0.0, min(100.0, (Double(p.progress) / validGoal) * 100.0))
                 case let p as TimeProgress:
                     percentage = max(0.0, min(100.0, (p.progress / validGoal) * 100.0))
                 default:
                     // Should not happen with current structure
                     print("Warning: Unknown progress type encountered.")
                     continue
                 }

                 // Add the calculated percentage to the dictionary for that day
                 dailyData[day, default: []].append(percentage)
            }
        }

        // Process progress for all boolean, quantity, and time habits
        booleanHabits.forEach { processHabitProgress(habit: $0, progressList: $0.totalProgress, goal: 1.0) } // Boolean goal = 1.0
        quantityHabits.forEach { processHabitProgress(habit: $0, progressList: $0.totalProgress, goal: Double($0.goal)) }
        timeHabits.forEach { processHabitProgress(habit: $0, progressList: $0.totalProgress, goal: $0.goal) }

        // Get the unique dates for which progress was logged, sorted chronologically
        let sortedDates = dailyData.keys.sorted()
        guard !sortedDates.isEmpty else { return [] } // Return empty if no progress logged at all

        // Calculate the average percentage for each date and map to ChartDataPoint
        return sortedDates.enumerated().map { index, date in
            let percentagesForDay = dailyData[date] ?? [] // Get percentages for the specific date
            // Calculate average, defaulting to 0.0 if no data (shouldn't happen with this logic)
            let average = percentagesForDay.isEmpty ? 0.0 : percentagesForDay.reduce(0, +) / Double(percentagesForDay.count)
            // Create the data point for the chart
            return ChartDataPoint(dayIndex: index, percentage: average)
        }
    }


    // Calculates the overall trend text based on the most recent progress entries
    private var overallTrendText: String {
        var latestPercentages: [Double] = [] // Array to store the latest percentage for each habit

        // Helper to calculate the percentage for the latest progress entry of a habit
        func getLastPercentage<H: Habit, P: Progress>(habit: H, progressList: [P], goal: Double?) -> Double? {
            // Determine a valid goal (treat boolean as 1.0)
            let validGoal = goal ?? (H.self == BooleanHabit.self ? 1.0 : 0.0)
            guard validGoal > 0 else { return nil }

            // Find the most recent progress entry by sorting by date
            guard let lastProgress = progressList.sorted(by: { $0.day < $1.day }).last else {
                return nil // No progress entries for this habit
            }

            // Calculate percentage based on the type of the last entry
             switch lastProgress {
             case let p as BooleanProgress: return p.progress ? 100.0 : 0.0
             case let p as QuantityProgress: return max(0.0, min(100.0, (Double(p.progress) / validGoal) * 100.0))
             case let p as TimeProgress: return max(0.0, min(100.0, (p.progress / validGoal) * 100.0))
             default: return nil // Should not happen
             }
        }

        // Collect the latest percentage from each habit that has progress
        booleanHabits.forEach { if let p = getLastPercentage(habit: $0, progressList: $0.totalProgress, goal: 1.0) { latestPercentages.append(p) } }
        quantityHabits.forEach { if let p = getLastPercentage(habit: $0, progressList: $0.totalProgress, goal: Double($0.goal)) { latestPercentages.append(p) } }
        timeHabits.forEach { if let p = getLastPercentage(habit: $0, progressList: $0.totalProgress, goal: $0.goal) { latestPercentages.append(p) } }


        // Determine the appropriate trend text based on the average of latest percentages
        guard !latestPercentages.isEmpty else {
             // Provide messages based on whether habits exist but have no progress vs no habits at all
              if booleanHabits.isEmpty && quantityHabits.isEmpty && timeHabits.isEmpty {
                  return "Add habits and track your progress to see your trend!"
              } else {
                  return "Log your progress consistently to build momentum!"
              }
         }
         // Calculate the overall average of the latest daily percentages
         let overallAverage = latestPercentages.reduce(0, +) / Double(latestPercentages.count)

         // Return a motivational quote based on the average percentage range
         switch overallAverage {
            case 90...100: return "Amazing consistency! You're mastering your habits. Keep up the fantastic work! ✨"
            case 75..<90: return "Great job! You're showing strong progress and building solid routines. Stay focused! 👍"
            case 50..<75: return "Good effort! You're making progress. Focus on consistency for even better results. 💪"
            case 25..<50: return "You're getting started! Every small step counts. Keep pushing forward, one day at a time. 🌱"
            case 0..<25: return "Building habits takes time. Don't get discouraged! Reflect on what's challenging and try again tomorrow. You can do it! 😊"
            default: return "Every journey begins with a single step. Track your progress daily to see your growth! 🚀" // Handles 0% or unexpected values
         }
    }
}

// MARK: - Preview Provider
#Preview {
    // Wrap the view in a NavigationStack for previewing navigation bar elements
    NavigationStack {
         ProgressiView()
            // Provide the ModelContainer with sample data using the helper
            .modelContainer(ProgressiView.createPreviewContainer())
    }
}

// Extension for Preview Data Setup
extension ProgressiView {
    // Helper function to create and populate an in-memory ModelContainer for previews
    @MainActor
    static func createPreviewContainer() -> ModelContainer {
        // Use in-memory store configuration for previews
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        // Create the container, ensuring all model types are registered
        let container = try! ModelContainer(for: 
                                                BooleanHabit.self, QuantityHabit.self, TimeHabit.self,
                                            BooleanProgress.self, QuantityProgress.self, TimeProgress.self // Include Progress types
                                            , configurations: config)
        let context = container.mainContext
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date()) // Reference date for progress entries

        // Helper function to easily create past dates relative to today
        func date(daysAgo: Int) -> Date {
            calendar.date(byAdding: .day, value: -daysAgo, to: today)!
        }

        // --- Sample Habit 1: Boolean (Meditate) ---
        let habit1 = BooleanHabit(name: "Meditate", category: .meditation, frequency: .daily, notifyMe: false, notificationTime: Date())
        context.insert(habit1)
        // Add sample BooleanProgress entries for different days
        let p1_data: [(Bool, Int)] = [(false, 6), (true, 5), (true, 4), (false, 3), (true, 2), (true, 1), (true, 0)]
        for (done, daysAgo) in p1_data {
            let progress = BooleanProgress(progress: done); progress.day = date(daysAgo: daysAgo); context.insert(progress); habit1.totalProgress.append(progress)
        }

        // --- Sample Habit 2: Quantity (Reading) ---
        let habit2 = QuantityHabit(name: "Read Book", category: .learning, frequency: .daily, goal: 10, notifyMe: false, notificationTime: Date())
        context.insert(habit2)
        // Add sample QuantityProgress entries
        let p2_data: [(Int, Int)] = [(10, 5), (8, 4), (5, 3), (10, 2), (12, 1)] // Note: 12 pages exceeds goal (100%)
        for (pages, daysAgo) in p2_data {
            let progress = QuantityProgress(progress: pages); progress.day = date(daysAgo: daysAgo); context.insert(progress); habit2.totalProgress.append(progress)
        }

         // --- Sample Habit 3: Time (Workout) ---
         let habit3 = TimeHabit(name: "Workout", category: .sport, frequency: .daily, goal: 1800, notifyMe: false, notificationTime: Date()) // 30 min goal
         context.insert(habit3)
         // Add sample TimeProgress entries (values in seconds)
         let p3_data: [(TimeInterval, Int)] = [(900, 4), (1800, 3), (2000, 2), (1700, 1)]
         for (seconds, daysAgo) in p3_data {
             let progress = TimeProgress(progress: seconds); progress.day = date(daysAgo: daysAgo); context.insert(progress); habit3.totalProgress.append(progress)
         }

         // --- Sample Habit 4: Boolean (Drink Water) - No progress logged ---
          let habit4 = BooleanHabit(name: "Drink Water", category: .health, frequency: .daily, notifyMe: false, notificationTime: Date())
          context.insert(habit4) // Insert habit, but add no Progress objects

        // No explicit save needed for in-memory usually, but can add if needed:
        // try? context.save()

        return container // Return the fully configured container
    }
}
