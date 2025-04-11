//
//  AddView.swift
//  HabitHub
//
//  Created by Andrea Luciano on 11/04/25.
//

import SwiftUI

struct AddView: View {
    var onDone: (() -> Void)? = nil // opzionale, utile per chiusura da modale

    var body: some View {
        VStack(spacing: 20) {
            Text("Forza Napoli")
                .font(.largeTitle)

            Button("Sempre") {
                onDone?()
            }
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
