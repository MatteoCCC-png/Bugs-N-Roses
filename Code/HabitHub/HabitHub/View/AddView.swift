//
//  AddView.swift
//  HabitHub
//
//  Created by Andrea Luciano on 11/04/25.
//

import SwiftUI
import SwiftData

struct CategoryModalView: View {
    @Binding var selectedCategory: Category?
    @Environment(\.dismiss) var dismiss


    var body: some View {
        VStack {
            ZStack{
                Rectangle().fill(Color.green).opacity(1).cornerRadius(20).frame(width: 380, height: 60)
                HStack{
                    Text("Categories").font(.title).padding().foregroundStyle(.white).padding()
                    Spacer()
                }
                
            }
            

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(Category.all, id: \.name) { category in
                        Button(action: {
                            selectedCategory = category
                            dismiss()
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: category.systemImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.orange)

                                Text(category.name)
                                    .font(.title3)
                                    .foregroundColor(.primary)//.frame(width: 5, height: 5)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
        }
        .padding(.bottom)
    }
}

struct AddView: View {
    
    //MARK: PROPERTIES
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State var name: String = ""
    @State var category: Category? = nil
    @State var trackingMethod: TrackingMethod = .count
    @State var frequency: Frequency = .daily
    @State var remember: Bool = true
    @State var setNotify: Date = Date()
    @State var booleanGoal: Bool = true
    @State var quantityGoal: Int = 0
    @State var timeGoal: TimeInterval = 0.00
    @State var showCategoryModal: Bool = false
    @State var showFrequencyModal: Bool = false
    @State var showTrackingModal: Bool = false
    
    var onDone: () -> Void = {}
    //@State var chosefrequency: String = ""
    
    //MARK: BODY
    var body: some View {
        NavigationStack {
            Form {
                Section() {
                    TextField("New Habit", text: $name)
                }
                Section() {
                    Button("Select a category") {
                        showCategoryModal = true
                    }
                }
                .sheet(isPresented: $showCategoryModal){
                    CategoryModalView(selectedCategory: $category)
                }//MARK: make the Category Modal appare
                Section() {
                    Button("Select a Tracking Mode") {
                        showFrequencyModal = true
                    }
                }
                .sheet(isPresented: $showTrackingModal){
                    
                } //MARK: make the Trackig Modal appare
                
                Picker("Select a frequency", selection: $frequency) {
                    ForEach(Frequency.allCases) { freq in
                        Text(freq.rawValue)
                    }
                
                }//MARK: make the Frequency Modal appare
                Section() {
                    Toggle ("Remember me to do it ", isOn: $remember)
                }
                Section() {
                    DatePicker("Set notification time", selection: $setNotify, displayedComponents: .hourAndMinute)
                }
                
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        addHabit(name: name, category: category ?? Category.arts, trackingMethod: trackingMethod, frequency: frequency)
                    }){
                        Text("Add")
                    }
                }
            }// End: Toolbar
        }
    }
    //Function that adds a Learner to our Context Data
    func addHabit(name: String, category: Category, trackingMethod: TrackingMethod, frequency: Frequency) {
        //add Habit to our Context
        if trackingMethod == .count {
            let newHabit = QuantityHabit(name: name, category: category,  frequency: frequency, goal: quantityGoal, notifyMe: remember, notificationTime: setNotify)
            context.insert(newHabit)
        }
        if trackingMethod == .bool {
            let newHabit = BooleanHabit(name: name , category: category, frequency: frequency, notifyMe: remember, notificationTime: setNotify)
            context.insert(newHabit)
        }
        if trackingMethod == .time {
            let newHabit = TimeHabit(name: name, category: category, frequency: frequency, goal: timeGoal, notifyMe: remember, notificationTime: setNotify)
            context.insert(newHabit)
        }
        //dismiss the modal
        onDone()
        dismiss()
    }
}



#Preview {
    AddView()
}
