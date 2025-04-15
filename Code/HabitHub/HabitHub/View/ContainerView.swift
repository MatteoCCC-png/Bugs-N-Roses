//
//  ContainerView.swift
//  HabitHub
//
//  Created by Matteo Caccavale on 08/04/25.
//

import SwiftUI

struct ContainerView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    // Use @State for sheet presentation control based on @AppStorage initial value
    @State private var showOnboarding: Bool = false

    @State private var selectedTab: Tab = .home

    enum Tab {
        case home
        case progress
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)
                
            ProgressiView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(Tab.progress)
        }
        .onAppear {
            // Trigger sheet presentation based on AppStorage state
            if !hasSeenOnboarding {
                showOnboarding = true
            }
        }
        .sheet(isPresented: $showOnboarding) {
            // Wrap sheet content in a NavigationStack
            NavigationStack {
                OnboardingView(
                    // Pass the action to take when onboarding is truly finished
                    continueTapped: {
                        hasSeenOnboarding = true // Mark as complete
                        showOnboarding = false // Dismiss the sheet
                    }
                )
            }
            // Prevent swiping down until onboarding is marked complete
            .interactiveDismissDisabled(!hasSeenOnboarding)
        }
    }
}

#Preview {
    ContainerView()
        .onAppear {
            UserDefaults.standard.set(false, forKey: "hasSeenOnboarding")
        }
}
