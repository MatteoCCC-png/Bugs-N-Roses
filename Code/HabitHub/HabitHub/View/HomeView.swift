//
//  HomeView.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 08/04/25.
//

// TODO some fonts size to adjust

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 13) {
                    HStack{ // Header HStack
                        VStack(alignment: .leading) {
                            Text(formattedDate)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Hello!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        Button{
                            print("Buttone premut")
                        } label: {
                            Image(systemName: "plus.circle")
                                .padding()
                                .font(.title2)
                                .offset(x: 5, y: 5)
                        }
                        
                    }
                    
                    Text("Your progresses for today")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        
                    
                    ProgressCardView()
                    
                    ScrollView(.horizontal){
                        HStack{
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
                                .foregroundColor(.blue)
                            Image(systemName: "chevron.right")
                        }
                    }
                    
                    SuggestionCardView(title: "Reading a book", category: .learning, goal: "10 pages a day")
                    SuggestionCardView(title: "Meditation", category: .meditation, goal: "5 minutes a day")
                    SuggestionCardView(title: "Cooking a healty meal", category: .nutrition, goal: "10 minutes a day")
                    SuggestionCardView(title: "Have a good sleep", category: .health, goal: "7 hours")
                        
                }
                .padding()
            }
        }
    }
}

//MARK: - strutture riusabili della home page

var formattedDate : String {
    let Formatter = DateFormatter()
    Formatter.dateStyle = .long
    return Formatter.string(from: Date()).uppercased()
}

struct ProgressCardView: View {
    let items: [ProgressItem] = [
        .percentage(icon: "theatermask.and.paintbrush.fill", value: 0.1),
        .percentage(icon: "house.fill", value: 0.5),
        .timer(icon: "bolt.heart.fill", time: "05:34"),
        .boolean(icon: "books.vertical.fill", completed: true),
        .boolean(icon: "house.fill", completed: false)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Add your daily progress")
                    .font(.title3)
                    .bold()
                Spacer()
                Image(systemName: "pencil.tip.crop.circle.badge.plus") // TODO oppure plus.app
                    .font(.title2)
            }

            HStack{
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(items) { item in
                            itemView(for: item)
                        }
                    }
                }
                Button(action: {
                    print("Next tapped")
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
    }

    @ViewBuilder
    func itemView(for item: ProgressItem) -> some View {
        VStack(spacing: 8) {
            Image(systemName: item.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                .foregroundColor(.accentColor)
                .padding(.top, 4)

            Group {
                switch item {
                case .percentage(_, let value):
                    ProgressView(value: value)
                        .progressViewStyle(LinearProgressViewStyle(tint: .accentColor))
                        .frame(width: 50, height: 4)
                case .timer(_, let time):
                    Text(time)
                        .font(.headline)
                        .foregroundColor(.accentColor)
                case .boolean(_, let completed):
                    Image(systemName: completed ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(completed ? .green : .red)
                        .font(.headline)
                }
            }
            .frame(height: 20) // altezza fissa per tutti i contenuti sotto
        }
        .frame(width: 50, height: 80, alignment: .top)
    }
}

enum ProgressItem: Identifiable { //TODO replace this with the real swiftdata shit
    case percentage(icon: String, value: Float)
    case timer(icon: String, time: String)
    case boolean(icon: String, completed: Bool)

    var id: UUID { UUID() }

    var iconName: String {
        switch self {
        case .percentage(let icon, _), .timer(let icon, _), .boolean(let icon, _):
            return icon
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
                .foregroundColor(locked ? .gray : .teal) // Yellow if unlocked
                .padding(10)
                .background(
                    Circle().fill(locked ? Color(.systemGray4) : Color.teal.opacity(0.2))
                )


            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

struct SuggestionCardView: View {
    let title : String
    let category : Category
    let goal : String
    
    var body: some View {
        HStack{
            VStack(alignment:.leading){
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.accentColor)
                Spacer()
                Text("Category: " + category.name)
                Text("Goal: " + goal)

            }
            Spacer()
            Image(systemName: category.systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(.accentColor)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
    }
}

#Preview {
    HomeView()
}
