import SwiftUI
import SwiftData

// MARK: - Main View Definition
struct DailyProgressView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // Fetch all habits, sorted alphabetically by name
    @Query(sort: \BooleanHabit.name) private var booleanHabits: [BooleanHabit]
    @Query(sort: \QuantityHabit.name) private var quantityHabits: [QuantityHabit]
    @Query(sort: \TimeHabit.name) private var timeHabits: [TimeHabit]

    // State variable to trigger saving in child cards when its value changes
    @State private var triggerSave: UUID = UUID()

    var body: some View {
        // Use a main VStack to hold the ScrollView and the Button
        VStack(spacing: 0) {
            ScrollView {
                // Check if there are any habits to display
                 if booleanHabits.isEmpty && quantityHabits.isEmpty && timeHabits.isEmpty {
                     // Show a message if no habits are found
                     ContentUnavailableView(
                        "No Habits Yet",
                        systemImage: "checklist.unchecked",
                        description: Text("Add your first habit from the Home screen to start tracking progress.")
                     )
                     .padding(.top, 50) // Add space from the top
                 } else {
                    // VStack to hold the habit cards
                    VStack(spacing: 20) {
                        // --- Time Habits Section ---
                        ForEach(timeHabits) { habit in
                            // Pass the habit and the save trigger UUID to the card
                            TimeProgressCard(habit: habit, saveTrigger: triggerSave)
                        }

                        // --- Quantity Habits Section ---
                        ForEach(quantityHabits) { habit in
                            QuantityProgressCard(habit: habit, saveTrigger: triggerSave)
                        }

                        // --- Boolean Habits Section ---
                        ForEach(booleanHabits) { habit in
                            BooleanProgressCard(habit: habit, saveTrigger: triggerSave)
                        }

                        // Add a spacer at the end of the scroll content if needed
                        Spacer()
                    }
                    .padding() // Padding around the stack of cards
                }
            } // End ScrollView

            // --- Add Your Progress Button ---
            // Display the button only if there are habits
            if !booleanHabits.isEmpty || !quantityHabits.isEmpty || !timeHabits.isEmpty {
                Button {
                    // Change the UUID to trigger the .onChange modifier in the cards
                    triggerSave = UUID()

                    // Dismiss the view after triggering the save
                    // A small delay might be added if saving takes noticeable time,
                    // but usually dismissing immediately is fine.
                    // DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { dismiss() }
                    dismiss()

                } label: {
                    Text("Add Your Progress")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 50) // Button height
                        .frame(maxWidth: .infinity) // Full width
                        .background(Color("ButtonColor")) // Button background color (adjust as needed)
                        .cornerRadius(10) // Button corner radius
                }
                .padding() // Padding around the button
                .background(Color(.systemGroupedBackground)) // Ensure button background matches view background
            }

        } // End Outer VStack
        .navigationTitle("Daily Progress")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Helper Functions to Find or Create Progress Entries

    // Finds today's BooleanProgress or creates a new one if none exists.
    @MainActor
    func findOrCreateTodayBooleanProgress(for habit: BooleanHabit) -> BooleanProgress {
        if let existingProgress = habit.todaysProgress {
            return existingProgress // Return existing entry
        } else {
            // Create, insert, and link a new entry
            let newProgress = BooleanProgress(progress: false) // Default to not done
            newProgress.day = Calendar.current.startOfDay(for: Date()) // Set to today
            modelContext.insert(newProgress)
            habit.totalProgress.append(newProgress)
            // Try saving immediately to ensure relationship link persists
            try? modelContext.save()
            return newProgress
        }
    }

    // Finds today's QuantityProgress or creates a new one.
    @MainActor
    func findOrCreateTodayQuantityProgress(for habit: QuantityHabit) -> QuantityProgress {
        if let existingProgress = habit.todaysProgress {
            return existingProgress
        } else {
            let newProgress = QuantityProgress(progress: 0) // Default to 0 progress
            newProgress.day = Calendar.current.startOfDay(for: Date())
            modelContext.insert(newProgress)
            habit.totalProgress.append(newProgress)
            try? modelContext.save()
            return newProgress
        }
    }

    // Finds today's TimeProgress or creates a new one.
    @MainActor
    func findOrCreateTodayTimeProgress(for habit: TimeHabit) -> TimeProgress {
         if let existingProgress = habit.todaysProgress {
             return existingProgress
         } else {
             let newProgress = TimeProgress(progress: 0.0) // Default to 0 seconds
             newProgress.day = Calendar.current.startOfDay(for: Date())
             modelContext.insert(newProgress)
             habit.totalProgress.append(newProgress)
             try? modelContext.save()
             return newProgress
         }
     }
}

// MARK: - Time Habit Progress Card View
struct TimeProgressCard: View {
    @Bindable var habit: TimeHabit // Use @Bindable if modifying habit directly (not needed here)
    var saveTrigger: UUID // Receive the trigger UUID from the parent

    @Environment(\.modelContext) private var modelContext
    // Local state for the time pickers, initialized from today's progress
    @State private var selectedHour: Int
    @State private var selectedMinute: Int
    @State private var selectedSecond: Int

    // Instance of the parent view to access its helper methods
    private var progressViewInstance = DailyProgressView()

    init(habit: TimeHabit, saveTrigger: UUID) {
        self.habit = habit
        self.saveTrigger = saveTrigger
        // Initialize state from the habit's current progress for today
        let currentProgress = habit.currentProgressToday
        _selectedHour = State(initialValue: Int(currentProgress) / 3600)
        _selectedMinute = State(initialValue: (Int(currentProgress) % 3600) / 60)
        _selectedSecond = State(initialValue: Int(currentProgress) % 60)
    }

    var body: some View {
         HStack(alignment: .center) { // Align items vertically centered
            // Left side: Title and Pickers
             VStack(alignment: .leading, spacing: 10) {
                 Text(habit.name).font(.body).fontWeight(.semibold).foregroundStyle(Color.accentColor)
                 Text("(min x day)").font(.caption).foregroundStyle(.gray) // Or derive dynamically

                 // Time Pickers
                 HStack(spacing: 0) {
                     Picker("", selection: $selectedHour) { ForEach(0...23, id: \.self) { Text(String(format: "%02d", $0)).tag($0) } }
                         .pickerStyle(.wheel).frame(maxWidth: .infinity, maxHeight: 100).clipped()
                       // NO .onChange save call

                     Text(":").font(.title3).padding(.horizontal, -4).offset(y: -2) // Adjust alignment

                     Picker("", selection: $selectedMinute) { ForEach(0...59, id: \.self) { Text(String(format: "%02d", $0)).tag($0) } }
                       .pickerStyle(.wheel).frame(maxWidth: .infinity, maxHeight: 100).clipped()
                       // NO .onChange save call

                     Text(":").font(.title3).padding(.horizontal, -4).offset(y: -2) // Adjust alignment

                     Picker("", selection: $selectedSecond) { ForEach(0...59, id: \.self) { Text(String(format: "%02d", $0)).tag($0) } }
                       .pickerStyle(.wheel).frame(maxWidth: .infinity, maxHeight: 100).clipped()
                       // NO .onChange save call
                 }
                 .padding(.bottom, 5) // Space below underline
             }

             Spacer() // Pushes icon to the right

             // Right side: Habit Category Icon
             Image(systemName: habit.category.systemImage)
                 .resizable().scaledToFit().frame(width: 74, height: 74)
                 .foregroundColor(.accentColor).padding(.leading) // Teal icon
         }
         .padding() // Padding inside the card
         .background(Color("CardsColor"))
         .cornerRadius(15) // Rounded corners for the card
        
         // Update local state if the underlying data changes (e.g., from another device/sync)
         .onChange(of: habit.currentProgressToday) { _, newValue in
             selectedHour = Int(newValue) / 3600
             selectedMinute = (Int(newValue) % 3600) / 60
             selectedSecond = Int(newValue) % 60
         }
         // Trigger save logic when the parent view changes the saveTrigger UUID
         .onChange(of: saveTrigger) { _, _ in
             saveProgress()
         }
     }

    // Function to save the current state of the pickers to SwiftData
    @MainActor
    private func saveProgress() {
        // Find or create today's progress entry using the helper
        let progressEntry = progressViewInstance.findOrCreateTodayTimeProgress(for: habit)
        // Calculate total seconds from the picker states
        let totalSeconds = TimeInterval(selectedHour * 3600 + selectedMinute * 60 + selectedSecond)
        // Only save if the value has actually changed
         if progressEntry.progress != totalSeconds {
             progressEntry.progress = totalSeconds
             print("Saving Time Progress for \(habit.name): \(totalSeconds) seconds") // For debugging
             // Explicit save might be needed if delays occur
             // try? modelContext.save()
         }
     }
}

// MARK: - Quantity Habit Progress Card View
struct QuantityProgressCard: View {
    @Bindable var habit: QuantityHabit
    var saveTrigger: UUID

    @Environment(\.modelContext) private var modelContext
    // Local state for the quantity stepper
    @State private var currentValue: Int

    private var progressViewInstance = DailyProgressView()

    init(habit: QuantityHabit, saveTrigger: UUID) {
        self.habit = habit
        self.saveTrigger = saveTrigger
        // Initialize state from today's progress
        _currentValue = State(initialValue: habit.currentProgressToday)
    }

    var body: some View {
         HStack(alignment: .center) {
            // Left side: Title, Stepper, Status
             VStack(alignment: .leading, spacing: 10) {
                 Text(habit.name).font(.body).fontWeight(.semibold).foregroundStyle(Color.accentColor)
                 Text("(quantity)").font(.caption).foregroundStyle(.gray)

                 // Stepper Control
                 HStack(spacing: 0) {
                     Button { if currentValue > 0 { currentValue -= 1 } } // Decrease state only
                       label: { Image(systemName: "minus").frame(width: 50, height: 40).contentShape(Rectangle()) }
                       .buttonStyle(.plain).foregroundStyle(Color.primary)
                     
                     Divider().frame(height: 40) // Separator line

                     // Display current value, centered
                     Text("\(currentValue)")
                        .font(.title2.weight(.semibold))
                        .frame(minWidth: 60, maxWidth: .infinity, alignment: .center)
                     
                     Divider().frame(height: 40) // Separator line

                     Button { currentValue += 1 } // Increase state only
                       label: { Image(systemName: "plus").frame(width: 50, height: 40).contentShape(Rectangle()) }
                       .buttonStyle(.plain).foregroundStyle(Color.primary)
                 }
                 .background(Color.gray.opacity(0.1)) // Background for stepper controls
                 .cornerRadius(8)

                 // Status Text
                 Text("Your goal is \(currentValue)/\(habit.goal) \(habit.category.name.lowercased())")
                    .font(.caption)
                    .padding(.vertical, 5).padding(.horizontal, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5))) // Border
             }

             Spacer()

            // Right side: Icon
             Image(systemName: habit.category.systemImage)
                 .resizable().scaledToFit().frame(width: 74, height: 74)
                 .foregroundColor(.accentColor).padding(.leading)
         }
         .padding()
         .background(Color("CardsColor"))
         .cornerRadius(15)
         // Update local state if underlying data changes
         .onChange(of: habit.currentProgressToday) { _, newValue in
              currentValue = newValue
          }
         // Trigger save when parent signals
         .onChange(of: saveTrigger) { _, _ in
             saveProgress()
         }
     }

    // Save the current stepper value to SwiftData
    @MainActor
    private func saveProgress() {
        let progressEntry = progressViewInstance.findOrCreateTodayQuantityProgress(for: habit)
          if progressEntry.progress != currentValue {
             progressEntry.progress = currentValue
             print("Saving Quantity Progress for \(habit.name): \(currentValue)") // Debugging
             // try? modelContext.save()
         }
     }
}

// MARK: - Boolean Habit Progress Card View
struct BooleanProgressCard: View {
    @Bindable var habit: BooleanHabit
    var saveTrigger: UUID

    @Environment(\.modelContext) private var modelContext
    // Local state for DONE/UNDONE status
    @State private var isDone: Bool

    private var progressViewInstance = DailyProgressView()

    init(habit: BooleanHabit, saveTrigger: UUID) {
        self.habit = habit
        self.saveTrigger = saveTrigger
        // Initialize state from today's completion status
        _isDone = State(initialValue: habit.isCompletedToday)
    }

    var body: some View {
         HStack(alignment: .center) {
            // Left side: Title, Buttons
             VStack(alignment: .leading, spacing: 10) {
                 Text(habit.name).font(.body).fontWeight(.semibold).foregroundStyle(Color.accentColor)
                 Text("(boolean)").font(.caption).foregroundStyle(.gray)

                 // DONE / UNDONE Buttons
                 HStack(spacing: 0) {
                     Button("DONE") { isDone = true } // Update state only
                       .frame(maxWidth: .infinity, maxHeight: 40)
                       // Conditional background/foreground for visual feedback
                       .background(isDone ? Color.teal.opacity(0.4) : Color.teal.opacity(0.15))
                       .foregroundStyle(isDone ? Color.primary : Color.secondary)

                     Divider().frame(height: 40) // Separator line

                     Button("UNDONE") { isDone = false } // Update state only
                       .frame(maxWidth: .infinity, maxHeight: 40)
                       .background(!isDone ? Color.orange.opacity(0.3) : Color.teal.opacity(0.15))
                       .foregroundStyle(!isDone ? Color.primary : Color.secondary)
                 }
                 .buttonStyle(.plain) // Use plain style for custom background/foreground
                 .font(.subheadline.weight(.medium)) // Button text style
                 .cornerRadius(8)
                 .clipped() // Ensure background respects corner radius
             }

             Spacer()

            // Right side: Icon
             Image(systemName: habit.category.systemImage)
                 .resizable().scaledToFit().frame(width: 74, height: 74)
                 .foregroundColor(.accentColor).padding(.leading)
         }
         .padding()
         .background(Color("CardsColor"))
         .cornerRadius(15)
         // Update local state if underlying data changes
          .onChange(of: habit.isCompletedToday) { _, newValue in
              isDone = newValue
          }
         // Trigger save when parent signals
         .onChange(of: saveTrigger) { _, _ in
             saveProgress()
         }
     }

    // Save the current DONE/UNDONE state to SwiftData
    @MainActor
    private func saveProgress() {
        let progressEntry = progressViewInstance.findOrCreateTodayBooleanProgress(for: habit)
         if progressEntry.progress != isDone {
             progressEntry.progress = isDone
             print("Saving Boolean Progress for \(habit.name): \(isDone)") // Debugging
              // try? modelContext.save()
         }
     }
}


// MARK: - Preview Setup (in Extension)
extension DailyProgressView {
    // Helper function to create and populate an in-memory ModelContainer for previews
    @MainActor
    static func createPreviewContainer() -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: 
                                                BooleanHabit.self, QuantityHabit.self, TimeHabit.self,
                                            BooleanProgress.self, QuantityProgress.self, TimeProgress.self
                                            , configurations: config)
        let context = container.mainContext
        let today = Calendar.current.startOfDay(for: Date()) // Use start of today for consistency

        // --- Create Sample Habits ---
        let boolHabit = BooleanHabit(name: "Healthy Food", category: .nutrition, frequency: .daily, notifyMe: false, notificationTime: Date())
        context.insert(boolHabit)

        let qtyHabit = QuantityHabit(name: "Reading", category: .learning, frequency: .daily, goal: 15, notifyMe: false, notificationTime: Date())
        context.insert(qtyHabit)

        let timeHabit = TimeHabit(name: "Drawing", category: .arts, frequency: .daily, goal: 3600, notifyMe: false, notificationTime: Date()) // 1 hr goal
        context.insert(timeHabit)

        // --- Create Sample Progress for Today ---
        // Boolean (start as false for preview)
        let boolProg = BooleanProgress(progress: false); boolProg.day = today; context.insert(boolProg); boolHabit.totalProgress.append(boolProg)

        // Quantity (start with some progress)
        let qtyProg = QuantityProgress(progress: 8); qtyProg.day = today; context.insert(qtyProg); qtyHabit.totalProgress.append(qtyProg)

        // Time (start with some progress)
        let timeProg = TimeProgress(progress: 900); timeProg.day = today; context.insert(timeProg); timeHabit.totalProgress.append(timeProg) // 15 min

        // --- Add a Habit with No Progress Yet ---
        let timeHabit2 = TimeHabit(name: "Workout", category: .sport, frequency: .daily, goal: 1800, notifyMe: false, notificationTime: Date())
        context.insert(timeHabit2)

        // Optional: Save context if needed, usually not required for in-memory previews
        // try? context.save()

        return container // Return the populated container
    }
}

// MARK: - Preview Definition
#Preview {
    // Wrap the preview in a NavigationStack to simulate navigation context
    NavigationStack {
         DailyProgressView()
            // Provide the configured ModelContainer to the preview
            .modelContainer(DailyProgressView.createPreviewContainer())
    }
}
