//
//  AddView.swift
//  HabitHub
//
//  Created by Andrea Luciano on 11/04/25.
//

import SwiftUI
import SwiftData


struct TrackingMethodView: View {

    @Environment(\.dismiss) var dismiss
    
    @State private var selectedHour: Int = 1
    @State private var selectedMinute: Int = 15
    @State private var selectedSecond: Int = 0
    @State private var numericValue: Int = 0
    enum CheckCrossChoice {
        case check, cross
    }
    @State private var checkCrossChoice: CheckCrossChoice? = nil
        
    // costante ad capocchiam
    private let controlHeight: CGFloat = 45

    // Closure per restituire i dati
    var onTrackingMethodSelected: (TrackingMethod, Any) -> Void

    var body: some View {
        VStack(spacing: 15) {
            
            ZStack {
                Rectangle().fill(Color("ButtonColor")).cornerRadius(13).frame(height: 49)
                HStack {
                    Text("Tracking method")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.white)
                        .padding()
                    Spacer()
                }
            }

            // --- Selezione cronometro ---
            HStack {
                HStack(spacing: 0) {
                    Picker("", selection: $selectedHour) {
                        ForEach(0...23, id: \.self) { Text(String(format: "%02d", $0)).tag($0) }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity, maxHeight: 129)
                    .clipped()

                    Text(":").font(.title3).padding(.horizontal, -4)

                    Picker("", selection: $selectedMinute) {
                        ForEach(0...59, id: \.self) { Text(String(format: "%02d", $0)).tag($0) }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity, maxHeight: 129)
                    .clipped()

                    Text(":").font(.title3).padding(.horizontal, -4)

                    Picker("", selection: $selectedSecond) {
                        ForEach(0...59, id: \.self) { Text(String(format: "%02d", $0)).tag($0) }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity, maxHeight: 129)
                    .clipped()
                }
                .background(Color("TrackingMethodCards"))
                .cornerRadius(8)
                .frame(maxWidth: .infinity)

                Spacer()

                Button {
                    // Restituisci il metodo di tracciamento e il valore
                    let timeValue = TimeInterval(selectedHour * 3600 + selectedMinute * 60 + selectedSecond)
                    onTrackingMethodSelected(.time, timeValue)
                    dismiss()
                } label: {
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
                .padding()
            }

            // --- Selezione contatore ---
            HStack {
                HStack(spacing: 0) {
                    Button { numericValue -= 1 } label: {
                        Text("-").font(.title2).frame(width: controlHeight, height: controlHeight)
                    }.buttonStyle(.plain)

                    Divider().frame(height: 56)

                    Text("\(numericValue)").font(.title3).frame(maxWidth: .infinity, maxHeight: controlHeight)

                    Divider().frame(height: 56)

                    Button { numericValue += 1 } label: {
                        Text("+").font(.title2).frame(width: controlHeight, height: controlHeight)
                    }.buttonStyle(.plain)
                }
                .background(Color("TrackingMethodCards"))
                .cornerRadius(8)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, idealHeight: 70)

                Spacer()

                Button {
                    // Restituisci il metodo di tracciamento e il valore
                    onTrackingMethodSelected(.count, numericValue)
                    dismiss()
                } label: {
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
                .padding()
            }

            // --- Selezione booleano ---
            HStack {
                HStack(spacing: 0) {
                    Button { checkCrossChoice = .check } label: {
                        Image(systemName: "checkmark.circle")
                            .resizable().scaledToFit().frame(width: 36, height: 36)
                            .foregroundColor(checkCrossChoice == .check ? .white : .green)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(checkCrossChoice == .check ? Color.green.opacity(0.7) : Color.clear)
                    }.buttonStyle(.plain)

                    Divider().frame(height: 25)

                    Button { checkCrossChoice = .cross } label: {
                        Image(systemName: "xmark.circle")
                            .resizable().scaledToFit().frame(width: 36, height: 36)
                            .foregroundColor(checkCrossChoice == .cross ? .white : .red)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(checkCrossChoice == .cross ? Color.red.opacity(0.7) : Color.clear)
                    }.buttonStyle(.plain)
                }
                .frame(height: 71)
                .background(Color("TrackingMethodCards"))
                .cornerRadius(8)
                .clipped()

                Spacer()

                Button {
                    // Restituisci il metodo di tracciamento e il valore
                    if let choice = checkCrossChoice {
                        onTrackingMethodSelected(.bool, choice == .check)
                    }
                    dismiss()
                } label: {
                    Image(systemName: "square")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
                .padding()
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}


struct CategoryModalView: View {
    @Binding var selectedCategory: Category?
    @Environment(\.dismiss) var dismiss


    var body: some View {
        VStack {
            ZStack{
                Rectangle().fill(Color("ButtonColor")).cornerRadius(13).frame(width: 380, height: 50)
                    .padding()
                HStack{
                    Text("Categories").font(.title3).padding().foregroundStyle(.white).padding()
                    Spacer()
                }
            }
            

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 5) {
                    ForEach(Category.all, id: \.name) { category in
                        Button(action: {
                            selectedCategory = category
                            dismiss()
                        }) {
                            HStack(spacing: 0) {
                                Image(systemName: category.systemImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.accentColor)
                                    .frame(width:40, alignment: .leading)

                                Text(category.name)
                                    .font(.body)
                                    .foregroundColor(Color("HomeTitleColor"))//.frame(width: 5, height: 5)
                                    .padding(.leading, 10)
                                    
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
        //.padding(.bottom)
    }
}

struct AddView: View {
    
    //MARK: PROPERTIES
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @State var name: String? = nil
    @State var category: Category? = nil
    @State var trackingMethod: TrackingMethod? = nil
    @State var frequency: Frequency? = nil
    @State var remember: Bool = false
    @State var setNotify: Date? = nil
    @State var booleanGoal: Bool = false
    @State var quantityGoal: Int? = nil
    @State var timeGoal: TimeInterval? = nil
    @State var showTrackingModal: Bool = false
    
    @State var showCategoryModal: Bool = false
    @State var showFrequencyModal: Bool = false

    var onDone: () -> Void = {}

    // --- Initializer for pre-filling from Suggestion ---
    init(suggestion: SuggestedHabit? = nil, onDone: @escaping () -> Void = {}) {
        self.onDone = onDone // Store the completion handler

        // Pre-fill state based on suggestion, if provided
        if let suggestion = suggestion {
            // Use _variable = State(initialValue: ...) to set initial @State value
            _name = State(initialValue: suggestion.name)
            _category = State(initialValue: suggestion.category)
            _trackingMethod = State(initialValue: suggestion.suggestedMethod)
            _quantityGoal = State(initialValue: suggestion.suggestedQuantityGoal ?? 1) // Use suggested or default
            _timeGoal = State(initialValue: suggestion.suggestedTimeGoal ?? 300) // Use suggested or default
            // Boolean goal is handled by trackingMethod being .bool
        } else {
            // If no suggestion, the default @State initializers are used
            // (name="", category=nil, etc.)
        }
    }


    private var isFormValid: Bool {
        guard let name = name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        return category != nil && trackingMethod != nil && frequency != nil
    }
    
    //MARK: BODY
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Habit name", text: Binding(
                        get: { name ?? "" },
                        set: { name = $0.isEmpty ? nil : $0 }
                    ))
                }
                Section {
                    Button("Select a category") {
                        showCategoryModal = true
                    }
                    if let category = category {
                        Text("Selected: \(category.name)")
                            .foregroundColor(.gray)
                    }
                }
                .sheet(isPresented: $showCategoryModal) {
                    CategoryModalView(selectedCategory: $category)
                        .presentationDetents([.medium])
                        .interactiveDismissDisabled(true)
                }
                
                Section {
                    Button("Select a tracking method") {
                        showTrackingModal = true
                    }
                    if let trackingMethod = trackingMethod {
                        Text("Selected: \(trackingMethod.rawValue)," +
                              (trackingMethod == .count ? " \(quantityGoal ?? 0)" :
                              trackingMethod == .bool ? " \(booleanGoal ? "Yes" : "No")" :
                              " \(Int(timeGoal ?? 0) / 3600 > 0 ? "\(Int(timeGoal ?? 0) / 3600)h " : "")\(Int(timeGoal ?? 0) % 3600 / 60)m"))
                            .foregroundColor(.gray)
                    }
                }
                .sheet(isPresented: $showTrackingModal) {
                    TrackingMethodView(onTrackingMethodSelected: { method, value in
                        trackingMethod = method
                        switch method {
                        case .count:
                            quantityGoal = value as? Int
                        case .bool:
                            booleanGoal = value as? Bool ?? false
                        case .time:
                            timeGoal = value as? TimeInterval
                        }
                    })
                    .presentationDetents([.height(400)])
                }

                
                Picker("Select a frequency", selection: Binding(
                    get: { frequency},
                    set: { frequency = $0 }
                )) {
                    ForEach(Frequency.allCases) { freq in
                        Text(freq.rawValue)
                            .tag(freq)
                    }
                }
                

                Section {
                    Toggle("Remember me to do it", isOn: $remember)
                }
                if remember{
                    Section {
                        DatePicker("Set notification time", selection: Binding(
                            get: { setNotify ?? Date() },
                            set: { setNotify = $0 }
                        ), displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if isFormValid {
                            addHabit(name: name!, category: category ?? Category.other, trackingMethod: trackingMethod!, frequency: Frequency.weekly )
                        }
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    // Function to add a habit
    func addHabit(name: String, category: Category, trackingMethod: TrackingMethod, frequency: Frequency) {
        if trackingMethod == .count {
            let newHabit = QuantityHabit(name: name, category: category, frequency: frequency, goal: quantityGoal ?? 0, notifyMe: remember, notificationTime: setNotify ?? Date())
            context.insert(newHabit)
        } else if trackingMethod == .bool {
            let newHabit = BooleanHabit(name: name, category: category, frequency: frequency, notifyMe: remember, notificationTime: setNotify ?? Date())
            context.insert(newHabit)
        } else if trackingMethod == .time {
            let newHabit = TimeHabit(name: name, category: category, frequency: frequency, goal: timeGoal ?? 0.0, notifyMe: remember, notificationTime: setNotify ?? Date())
            context.insert(newHabit)
        }

        // Salva il contesto
        try? context.save()

        // Chiama il callback per segnalare il completamento (questo ora chiuderà l'intera modale di onboarding)
        onDone()

        // Dismiss solo AddView (torna a HabitSelectView brevemente prima che onDone chiuda tutto)
        dismiss()
    }
}



#Preview("Add View - Empty") {
    AddView() // Default init creates empty view
        .modelContainer(for: [BooleanHabit.self, QuantityHabit.self, TimeHabit.self], inMemory: true)
}

#Preview("Add View - Suggested") {
    // Create a sample suggestion
    let suggestion = SuggestedHabit.time("Evening Walk", category: .sport, goal: 1800) // 30 min

    AddView(suggestion: suggestion) // Use the suggestion initializer
        .modelContainer(for: [BooleanHabit.self, QuantityHabit.self, TimeHabit.self], inMemory: true)
}
