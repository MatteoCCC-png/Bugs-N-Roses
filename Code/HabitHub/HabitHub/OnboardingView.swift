//
//  ContentView.swift
//  Onboarding
//
//  Created by Giovanni Monaco on 12/05/23.
//


import SwiftUI

struct Onboarding: View {
    @AppStorage("firstTime") var firstTime: Bool = true
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Welcome to")
                Text("HIG Mini")
                    .foregroundColor(.accentColor)
            }
            .font(.title)
            .fontWeight(.bold)
            Spacer()
            VStack(spacing: 20.0) {
                HStack(spacing: 16.0) {
                    Image(systemName: "mail.and.text.magnifyingglass")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading) {
                        Text("Explore")
                        Text("From navigation to visuals. Dive into the world of Human Interface Guidelines.")
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack(spacing: 16.0) {
                    Image(systemName: "pencil.and.ruler")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 4)
                    VStack(alignment: .leading) {
                        Text("Design")
                        Text("Learn to design purposeful apps that follow Apple's Human Interface Guidelines effortlessly.")
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                HStack(spacing: 16.0) {
                    Image(systemName: "iphone.gen2")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 6)
                    VStack(alignment: .leading) {
                        Text("Develop")
                        Text("Implement with ease and bring your design to life! Follow the code to seamlessly implement.")
                            .foregroundColor(.secondary)
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 28)
            .symbolRenderingMode(.hierarchical)
            
            Spacer()
            VStack(spacing: 16.0) {
                VStack(spacing: 6.0) {
                    Image(systemName: "info.square.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                    Text("The Apple Foundation Program is an immersive educational initiative designed to introduce aspiring developers to the world of app creation and software development. Embark on an captivating journey where code comes to life, and creativity knows no bounds.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Button {
                        print("Learn more tapped!")
                    } label: {
                        Link("Learn more", destination: URL(string: "https://www.developeracademy.unina.it/en/")!) .font(.caption)
                        
                    }
                }
                Button {
                    print("Continue tapped!")
                    firstTime.toggle()
                } label: {
                    Text("Continue")
                        .padding(8)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(16)
                
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

#Preview {
     
}
