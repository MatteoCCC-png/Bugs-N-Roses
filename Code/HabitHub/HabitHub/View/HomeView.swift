//
//  HomeView.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 08/04/25.
//

// TODO some fonts size to adjust

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @State private var showAddView = false // Variabile per gestire la modale dell'add button

    let sampleSuggestions: [SuggestedHabit] = [
        .quantity("Reading", category: .learning, goal: 10), // e.g., 10 pages
        .time("Meditation", category: .meditation, goal: 300), // 5 minutes (300 seconds)
        .boolean("Healthy Meal", category: .nutrition),
        .time("Sleep", category: .health, goal: 25200) // 7 hours (25200 seconds)
    ]

    @State private var showAddViewSheetFromSuggestion = false // Flag (alternative to item)
    @State private var selectedSuggestion: SuggestedHabit? = nil // Holds the selected suggestion
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack{ // Header HStack
                        VStack(alignment: .leading) {
                            Text(formattedDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Hello!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(Color("HomeTitleColor"))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            selectedSuggestion = nil
                            showAddView.toggle()
                        }) {
                            Image(systemName: "plus.circle")
                                .padding()
                                .font(.title2)
                                .offset(x: 5, y: 5)
                                .foregroundStyle(Color(red: 38/255, green: 185/255, blue: 171/255))
                        }
                        .sheet(isPresented: $showAddView) {
                            // Pass the context if AddView needs it for saving
                            AddView()
                        }
                    }
                    
                    Text("Your progresses for today")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 20){
                    
                    
                    ProgressCardView()
                    
                    ScrollView(.horizontal){
                        HStack(spacing:20){
                            MedalCardView(title: "Your first medal!", description: "This is a placeholder for a future gamification \nfeature!", systemImageName: "star.circle", locked: false)
                            MedalCardView(title: "Freezed medal...", description: "Non so cosa scrivere quindi riempio con parole\na caso.", systemImageName: "star.circle", locked: true)
                        }
                    }
                    
                    HStack{
                        Text("Suggestions you might like")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button(action: {
                            print("Explore tapped")
                        }) {
                            Text("See all")
                                .foregroundStyle(Color("ButtonColor"))
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color("ButtonColor"))
                        }
                    }
                }
                VStack(spacing: 20){
                    ForEach(sampleSuggestions) { suggestion in
                        SuggestionCardView(suggestion: suggestion) { selected in
                            // This closure is called when a card is tapped
                            print("Suggestion selected: \(selected.name)")
                            selectedSuggestion = selected // Store the selected suggestion
                            showAddViewSheetFromSuggestion = true // Trigger sheet using the item state below
                        }
                        .sheet(item: $selectedSuggestion) { suggestion in
                            // This closure is called when selectedSuggestion is NOT nil
                            // It receives the non-optional suggestion
                            AddView(suggestion: suggestion)
                        }
                    }
                }
                
            }
            .padding()
            .scrollIndicators(.hidden)
        }
    }
}

extension HomeView {
    @MainActor // Ensures context access is on the main thread, good practice for previews
    static func createPreviewContainer() -> ModelContainer {
        // Define the configuration
        let config = ModelConfiguration(isStoredInMemoryOnly: true)

        // Create the container with VARARGS (comma-separated types, NO brackets)
        let container = try! ModelContainer(for:
            BooleanHabit.self,
            QuantityHabit.self,
            TimeHabit.self,
            BooleanProgress.self,
            QuantityProgress.self,
            TimeProgress.self
        , configurations: config)

        // Get the context
        let context = container.mainContext

        // --- Create Habits and Insert ---
        /*let sampleBool = BooleanHabit(name: "Meditate", category: .meditation, frequency: .daily, notifyMe: false, notificationTime: Date())
        context.insert(sampleBool)

        let sampleQty = QuantityHabit(name: "Pushups", category: .sport, frequency: .daily, goal: 20, notifyMe: false, notificationTime: Date())
        context.insert(sampleQty)

        let sampleTime = TimeHabit(name: "Read", category: .learning, frequency: .daily, goal: 1800, notifyMe: false, notificationTime: Date())
        context.insert(sampleTime)

        // --- Create Progress objects and Insert ---
        // Make sure progress dates are actually *today* for the helpers to work
        let today = Calendar.current.startOfDay(for: Date())

        let boolProgress = BooleanProgress(progress: true)
        boolProgress.day = today // Set day explicitly for preview
        context.insert(boolProgress)

        let qtyProgress = QuantityProgress(progress: 15)
        qtyProgress.day = today // Set day explicitly for preview
        context.insert(qtyProgress)

        let timeProgress = TimeProgress(progress: 900) // 15 min
        timeProgress.day = today // Set day explicitly for preview
        context.insert(timeProgress)

        // --- Establish Relationships ---
        sampleBool.totalProgress.append(boolProgress)
        sampleQty.totalProgress.append(qtyProgress)
        sampleTime.totalProgress.append(timeProgress)

        // Add a habit without progress today to test that case
        let sampleNoProgress = BooleanHabit(name: "Drink Water", category: .health, frequency: .daily, notifyMe: false, notificationTime: Date())
        context.insert(sampleNoProgress)


        // Optional: Explicit save
        // try? context.save()*/

        try? context.save()
        return container
    }
}

//MARK: - strutture riusabili della home page

var formattedDate : String {
    let Formatter = DateFormatter()
    Formatter.dateStyle = .long
    return Formatter.string(from: Date()).uppercased()
}


struct ProgressCardView: View {
    // Fetch habits directly here
    @Query(sort: \BooleanHabit.name) var booleanItems: [BooleanHabit]
    @Query(sort: \QuantityHabit.name) var quantityItems: [QuantityHabit]
    @Query(sort: \TimeHabit.name) var timeItems: [TimeHabit]

    // Combine all habits into a single array for easier iteration (optional but can simplify)
    // You might need a common protocol or wrapper if you want to sort them together easily.
    // For simplicity, we'll iterate through each type separately.

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Add your daily progress")
                    .font(.headline)
                    .bold()
                    .foregroundStyle(Color("HomeTitleColor"))
                
                Image(systemName: "pencil.tip.crop.circle.badge.plus")
                    .font(.title2)
                    .foregroundStyle(Color("HomeTitleColor"))
            }

            NavigationLink(destination: DailyProgressView()) {
                HStack{
                    ScrollView(.horizontal, showsIndicators: false) { // Hide scroll indicator if desired
                        // Check if there are no habits at all
                        if booleanItems.isEmpty && quantityItems.isEmpty && timeItems.isEmpty {
                            Text("No habits added yet. Tap '+' to create one!")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.vertical) // Add some padding
                        } else {
                            HStack(spacing: 15) { // Adjust spacing as needed
                                // Iterate through each type of habit
                                ForEach(quantityItems) { item in
                                    quantityItemView(for: item)
                                }
                                ForEach(timeItems) { item in
                                    timeItemView(for: item)
                                }
                                ForEach(booleanItems) { item in
                                    booleanItemView(for: item)
                                }
                            }
                            .padding(.vertical, 5) // Add padding if items feel cramped
                        }
                    }
                    
                    // Keep the chevron if you want navigation, otherwise remove
                    Button(action: {
                        print("Next tapped")
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(Color("CardsColor"))
        .cornerRadius(20)
    }

    // MARK: - Item Views for each Habit Type

    @ViewBuilder
    func booleanItemView(for habit: BooleanHabit) -> some View {
        VStack(spacing: 8) {
            Image(systemName: habit.category.systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30) // Slightly smaller icon
                .foregroundColor(Color.accentColor)
                .padding(.top, 4)
            
            Text(habit.name) // Show habit name
                .font(.caption)
                .lineLimit(1) // Prevent long names from breaking layout
                .truncationMode(.tail)

            // Use the computed property
            Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle") // Use circle for incomplete instead of xmark
                .foregroundColor(habit.isCompletedToday ? .green : .gray)
                .font(.headline)
                .frame(height: 10) // Consistent height
        }
        .frame(width: 80) // Adjust width as needed
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1)) // Subtle background for card
        .cornerRadius(10)
        // Add onTapGesture if you want to navigate or log progress later
         .onTapGesture {
             print("Tapped on \(habit.name)")
             // TODO: Implement navigation or progress logging action
         }
    }

    @ViewBuilder
    func quantityItemView(for habit: QuantityHabit) -> some View {
        VStack(spacing: 8) {
            Image(systemName: habit.category.systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.accentColor)
                .padding(.top, 4)

            Text(habit.name)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.tail)

            // Use the computed property and show progress text
            let progress = habit.currentProgressToday
            let goal = habit.goal
            let progressFraction = goal > 0 ? Double(progress) / Double(goal) : 0.0

            VStack(spacing: 4) {
                Text("\(progress)/\(goal)")
                    .font(.caption)
                    .foregroundColor(progress >= goal ? .green : .accentColor)
                
                ProgressView(value: progressFraction)
                    .progressViewStyle(LinearProgressViewStyle(tint: progress >= goal ? .green : .accentColor))
                    .frame(width: 50, height: 4)
            }
            .frame(height: 25) // Adjust height for text + progress bar

        }
        .frame(width: 80)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .onTapGesture {
             print("Tapped on \(habit.name)")
             // TODO: Implement navigation or progress logging action
         }
    }
    
    @ViewBuilder
    func timeItemView(for habit: TimeHabit) -> some View {
        VStack(spacing: 8) {
            Image(systemName: habit.category.systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.accentColor)
                .padding(.top, 4)

            Text(habit.name)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.tail)

            // Use computed property and format time
            let progress = habit.currentProgressToday
            let goal = habit.goal
            let progressFraction = goal > 0 ? progress / goal : 0.0
            
             VStack(spacing: 4) {
                 // Display formatted time / goal
                 Text("\(progress.formattedShort()) / \(goal.formattedShort())")
                     .font(.caption)
                     .lineLimit(1) // Ensure it fits
                     .minimumScaleFactor(0.8) // Allow text to shrink slightly
                     .foregroundColor(progress >= goal ? .green : .accentColor)

                ProgressView(value: progressFraction)
                    .progressViewStyle(LinearProgressViewStyle(tint: progress >= goal ? .green : .accentColor))
                    .frame(width: 50, height: 4)
             }
             .frame(height: 25) // Adjust height

        }
        .frame(width: 80)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .onTapGesture {
             print("Tapped on \(habit.name)")
             // TODO: Implement navigation or progress logging action
         }
    }
}

struct MedalCardView: View {
    let title: String
    let description: String
    let systemImageName: String
    let locked: Bool // To show the grayed-out effect

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: systemImageName)
                .font(.largeTitle)
                .foregroundColor(locked ? .gray.opacity(0.8) : Color(red: 38/255, green: 185/255, blue: 171/255)) // Yellow if unlocked
                .padding(10)
                .background(
                    Circle().fill(locked ? Color(.systemGray4) : Color(red: 38/255, green: 185/255, blue: 171/255).opacity(0.5))
                    
                )

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color("HomeTitleColor"))
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()

        }
        .padding()
        .frame(width: 370, height: 95)
        .background(Color("CardsColor"))
        .cornerRadius(15)
    }
}

struct SuggestionCardView: View {
    let suggestion: SuggestedHabit // Accept the structured data
    var onSelect: (SuggestedHabit) -> Void // Callback when tapped

    var body: some View {
        Button {
            onSelect(suggestion) // Trigger the callback with this suggestion
        } label: {
            HStack{
                VStack(alignment:.leading){
                    Text(suggestion.name) // Use data from suggestion
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor) // Or your custom title color
                    Spacer()
                    Text("Category: " + suggestion.category.name)
                        .font(.callout) // Slightly smaller font
                        .foregroundStyle(Color("HomeTitleColor"))
                    Text("Goal: " + suggestion.goalString) // Use the formatted goal string
                         .font(.callout)
                        .foregroundStyle(Color("HomeTitleColor"))

                }
                Spacer()
                Image(systemName: suggestion.category.systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.accentColor) // Or your custom icon color
                    .padding(5)
            }
            .padding()
            .frame(width: 370, height: 115)
            .background(Color("CardsColor")) // Your card background
            .cornerRadius(15)
        }
        .buttonStyle(.plain) // Use plain style to allow custom background/appearance
    }
}


// Helper extension to format TimeInterval (Keep this or move it)
extension TimeInterval {
    func formattedShort() -> String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return "\(hours)h" + (minutes > 0 ? " \(minutes)m" : "")
        } else if minutes > 0 {
            return "\(minutes)m" + (seconds > 0 ? " \(seconds)s" : "")
        } else if seconds > 0 { // Show seconds only if less than a minute
             return "\(seconds)s"
        } else { // If interval is 0
            return "0s"
        }
    }
}


#Preview { // Preview block itself remains simple
    HomeView()
        .modelContainer(HomeView.createPreviewContainer()) // Call the static function
}
