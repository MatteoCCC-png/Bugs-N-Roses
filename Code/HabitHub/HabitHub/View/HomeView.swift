//
//  HomeView.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 08/04/25.
//

// TODO some fonts size to adjust

import SwiftUI

struct HomeView: View {
    
    @State private var showAddView = false // Variabile per gestire la modale dell'add button
    
    
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
                            showAddView.toggle()
                        }) {
                            Image(systemName: "plus.circle")
                                .padding()
                                .font(.title2)
                                .offset(x: 5, y: 5)
                                .foregroundStyle(Color(red: 38/255, green: 185/255, blue: 171/255))
                        }
                        .sheet(isPresented: $showAddView) {
                            AddView(onDone: {
                                showAddView = false
                            }) // Apre AddView come modale
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
                    SuggestionCardView(title: "Reading a book", category: .learning, goal: "10 pages a day")
                    SuggestionCardView(title: "Meditation", category: .meditation, goal: "5 minutes a day")
                    SuggestionCardView(title: "Cooking a healty meal", category: .nutrition, goal: "10 minutes a day")
                    SuggestionCardView(title: "Have a good sleep", category: .health, goal: "7 hours")
                }
                
            }
            .padding()
            .scrollIndicators(.hidden)
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
        .percentage(icon: "house.circle", value: 0.5),
        .timer(icon: "bolt.heart", time: "05:34"),
        .boolean(icon: "books.vertical.fill", completed: true),
        .boolean(icon: "house.circle", completed: false)
    ]

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

            HStack{
                ScrollView(.horizontal) {
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
        .background(Color("CardsColor"))
        .cornerRadius(20)
    }

    @ViewBuilder
    func itemView(for item: ProgressItem) -> some View {
        VStack(spacing: 8) {
            Image(systemName: item.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
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
            .frame(height: 10) // altezza fissa per tutti i contenuti sotto
        }
        .frame(width: 60, height: 70, alignment: .top)
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
    let title : String
    let category : Category
    let goal : String
    
    var body: some View {
        HStack{
            VStack(alignment:.leading){
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                Spacer()
                Text("Category: " + category.name)
                    .foregroundStyle(Color("HomeTitleColor"))
                Text("Goal: " + goal)
                    .foregroundStyle(Color("HomeTitleColor"))

            }
            Spacer()
            Image(systemName: category.systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.accentColor)
                .padding(5)
                }
        .padding()
        .frame(width: 370, height: 115)
        .background(Color("CardsColor"))
        .cornerRadius(15)

    }
}

#Preview {
    HomeView()
}
