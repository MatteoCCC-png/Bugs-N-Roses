import SwiftUI
import Charts
import SwiftData

var dateRange: [Date] {
    let calendar = Calendar.current
    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
    let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
    return range.compactMap { day -> Date? in
        calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
    }
}


struct ProgressiView: View {
    
    //fetch Model Data
    @Query var booleanData: [BooleanProgress]
    @Query var quantityData: [QuantityProgress]
    @Query var timeData: [TimeProgress]

    // Added state variables to manage which data to show
    @State private var showBoolean = true
    @State private var showQuantity = true
    @State private var showTime = true

    // Create a full date range for the current month
    var dateRange: [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        return range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {  //ScrollView to allow vertical scrolling
                VStack {
                    // toggles to select which graphs to show
                    HStack(spacing: 16) {
                        Toggle("Boolean", isOn: $showBoolean)
                            .toggleStyle(.button)
                            .tint(.red)

                        Toggle("Quantity", isOn: $showQuantity)
                            .toggleStyle(.button)
                            .tint(.green)

                        Toggle("Time", isOn: $showTime)
                            .toggleStyle(.button)
                            .tint(.yellow)
                    }
                    .padding(.horizontal)
                    
                    let currentMonthYear = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
                    Text(currentMonthYear) // Will show something like "April 15, 2025"
                        .font(.headline)

                    // Chart 1 — Boolean + Quantity
                    if showBoolean || showQuantity {
                        Chart {
                            if showBoolean {
                                ForEach(booleanData.filter { $0.progress }) { item in
                                    PointMark(
                                        x: .value("Day", Calendar.current.component(.day, from: item.day)),
                                        y: .value("Boolean Event", 0)
                                    )
                                    .foregroundStyle(.red)
                                    .symbol(.circle)
                                }
                            }

                            if showQuantity {
                                ForEach(quantityData) { item in
                                    LineMark(
                                        x: .value("Day", Calendar.current.component(.day, from: item.day)),
                                        y: .value("Quantity", item.progress)
                                    )
                                    .foregroundStyle(.green)
                                    .symbol(.square)
                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: Array(1...31)) { day in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel {
                                    if let intVal = day.as(Int.self) {
                                        Text("\(intVal)")
                                    }
                                }
                            }
                        }
                        .chartXScale(domain: 1...31)
                        .frame(height: 300)
                        .padding()
                    }

                    // Chart 2 — Time (separated)
                    if showTime {
                        Chart {
                            ForEach(timeData) { item in
                                LineMark(
                                    x: .value("Day", Calendar.current.component(.day, from: item.day)),
                                    y: .value("Time (hours)", item.progress / 3600) // ⏱ convert to hours
                                )
                                .foregroundStyle(.yellow)
                                .symbol(.square)
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: Array(1...31)) { day in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel {
                                    if let intVal = day.as(Int.self) {
                                        Text("\(intVal)")
                                    }
                                }
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading) { value in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel {
                                    if let hours = value.as(Double.self) {
                                        Text(String(format: "%.1f h", hours))
                                    }
                                }
                            }
                        }
                        .chartXScale(domain: 1...31)
                        .frame(height: 300)
                        .padding(.bottom)
                    }
                }
                .background(Color.gray.opacity(0.1).ignoresSafeArea())
                .navigationTitle("Daily Progress") // Title in the navigation bar
            }
        }
    }
}

#Preview {
    ProgressiView()
}
