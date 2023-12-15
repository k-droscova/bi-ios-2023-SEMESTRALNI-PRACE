//
//  DifficultyPicker.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation
import SwiftUI

struct DifficultyPicker: View {
    @Binding var difficulty: TripDifficulty?
    let easy: String = "😏"
    let hardcore: String = "🥵"
    
    var body: some View {
        Section("How difficult was the trip?") {
            HStack {
                Text(easy)
                Picker("", selection: $difficulty) {
                    ForEach(TripDifficulty.allCases, id: \.self) {
                        difficulty in
                        Text(String(difficulty.getNumerical()))
                            .tag(difficulty as TripDifficulty?)
                    }
                }
                .pickerStyle(.segmented)
                Text(hardcore)
            }
        }
        
    }
}
