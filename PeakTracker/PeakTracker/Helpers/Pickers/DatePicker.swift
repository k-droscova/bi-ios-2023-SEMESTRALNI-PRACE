//
//  DatePicker.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation
import SwiftUI

struct DateAndSeasonPicker: View {
    @Binding var date: Date
    @Binding var season: Season?
    
    var body: some View {
        Section("Time") {
            DatePicker("When did you go?", selection: $date, displayedComponents: [.date])
            Picker("Season", selection: $season) {
                ForEach(Season.allCases, id: \.self) {
                    season in
                    season.getImage()
                        .tag(season as Season?)
                }
            }
        }
    }
}
