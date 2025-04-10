//
//  HabitHubApp.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 08/04/25.
//

import SwiftUI
import SwiftData

@main
struct HabitHubApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }.modelContainer(for: [BooleanHabit.self, TimeHabit.self, QuantityHabit.self])
    }
}
