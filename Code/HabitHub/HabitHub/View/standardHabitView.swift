//
//  standardHabitView.swift
//  HabitHub
//
//  Created by shehpar hassan on 15/04/2025.
//

import SwiftUI

struct standardHabitView: View {
    
    var onPageOpened: () -> Void = {}
    
    let sampleSuggestions: [SuggestedHabit] = [
        .quantity("Reading", category: .learning, goal: 10), // e.g., 10 pages
        .time("Meditation", category: .meditation, goal: 300), // 5 minutes (300 seconds)
        .boolean("Healthy Meal", category: .nutrition),
        .time("Sleep", category: .health, goal: 25200) // 7 hours (25200 seconds)
    ]
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing:20){
                ForEach(sampleSuggestions) { suggestion in
                    SuggestionCardView(suggestion: suggestion) { selected in
                        // This closure is called when a card is tapped
                        print("Suggestion selected: \(selected.name)")
                        //selectedSuggestion = selected // Store the selected suggestion
                        //showAddViewSheetFromSuggestion = true // Trigger sheet using the item state below
                    }
                }
            }
            .navigationTitle("Suggested Habits")
                .navigationBarTitleDisplayMode(.inline) // <-- This keeps it in line with the back button
        }
    }
    
    struct SuggestionCardForView: View {
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
}

#Preview {
    standardHabitView()
}
