//
//  HabitSelectView.swift
//  HabitHub
//
//  Created by Andrea Luciano on 11/04/25.
//

import SwiftUI

//TODO verifica gli offset, vedi se ci sta una soluzione migliore

struct HabitSelectView: View {
    // Aggiungi questa proprietà per ricevere il callback
    var onSetupComplete: () -> Void = {}

    var body: some View {
        NavigationStack {
            VStack() {
                HStack {
                    Text("Let's get started!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("HomeTitleColor"))
                    Spacer()
                }
                
                Spacer() // Aggiungi uno Spacer per separare il testo dalle cards
                
                VStack(spacing: 20) { // Contenitore per le cards
                    NavigationLink(destination: standardHabitView(onPageOpened: onSetupComplete)) {
                        StandardHabit()
                    }
                        .padding()
                    // Modifica il NavigationLink per passare la closure onSetupComplete ad AddView
                    NavigationLink(destination: AddView(onDone: onSetupComplete)) {
                        CustomizeHabit()
                    }
                    .buttonStyle(PlainButtonStyle()) // Rimuove il feedback visivo predefinito
                }
                
                Spacer() // Aggiungi uno Spacer per bilanciare il layout
            }
            .padding()
            //.navigationBarBackButtonHidden(true) // Nasconde il pulsante "< Back"
        }
    }
}

//MARK: - COMPONENTI RIUTILIZZABILI

struct StandardHabit : View {
    var body: some View {
        HStack{
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("Choose from standard habits")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.semibold)

                        HStack(spacing: 27) {
                            Image(systemName: Category.arts.systemImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 51, height: 43)
                            Image(systemName: Category.learning.systemImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 51, height: 43)
                            Image(systemName: Category.nutrition.systemImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 51, height: 43)
                            Image(systemName: Category.health.systemImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 51, height: 43)
                        }
                        .padding(.bottom)
                        .foregroundColor(.white)
                        .font(.title2)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
                .padding()
                .background(Color(red: 38/255, green: 185/255, blue: 171/255))
                .cornerRadius(19)
            }
        }
        .frame(width: 372, height: 150)
    }
}

struct CustomizeHabit : View {
    
    var body: some View {
        HStack{
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Customize your own habits")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 27) {
                            VStack {
                                Image(systemName: "chart.line.text.clipboard")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 51, height: 43)
                                    .offset(y: -4)
                                Text("Habits")
                                    .font(.caption2)
                            }
                            .frame(maxWidth: .infinity, idealHeight: 100)
                            VStack {
                                Image(systemName: "chart.bar.xaxis.ascending.badge.clock")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 51, height: 43)
                                    .offset(x:5)
                                Text("Progress track")
                                    .font(.caption2)
                            }
                            .frame(maxWidth: .infinity, idealHeight: 100)
                            VStack {
                                Image(systemName: "pencil.tip.crop.circle.badge.arrow.forward")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 51, height: 43)
                                    .offset(x:4)
                                Text("Customize")
                                    .font(.caption2)
                            }
                            .frame(maxWidth: .infinity, idealHeight: 100)
                        }
                        
                        .padding(.bottom)
                        .foregroundColor(.white)
                        .font(.title2)
                        
                        
                        
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
                .padding()
                .background(Color.accentColor)

                .cornerRadius(19)
            }
        }
        .frame(width: 372, height: 150)
    }
}

// Modifica l'anteprima se necessario per fornire un valore predefinito
#Preview {
    HabitSelectView(onSetupComplete: { print("Setup Complete from Preview") })
}
