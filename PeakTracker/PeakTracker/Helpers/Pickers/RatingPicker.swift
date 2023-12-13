//
//  RatingPicker.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation
import SwiftUI

struct RatingPicker: View {
    @Binding var rating: TripRating?
    let bad: String = "🤮"
    let great: String = "🤩"
    
    var body: some View {
        Section("How did you like the trip?") {
            HStack {
                Text(bad)
                Picker("", selection: $rating) {
                    ForEach(TripRating.allCases, id: \.self) {
                        rating in
                        Text(String(rating.getNumerical()))
                            .tag(rating as TripRating?)
                    }
                }
                .pickerStyle(.segmented)
                Text(great)
            }
        }
    }
}
