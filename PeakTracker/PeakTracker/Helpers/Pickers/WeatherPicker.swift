//
//  WeatherPicker.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation
import SwiftUI

struct WeatherPicker: View {
    @Binding var weather: Weather?
    
    var body: some View {
        Section("What was the weather like?") {
            VStack(spacing: 8) {
                Picker("Weather", selection: $weather) {
                    ForEach(Weather.allCases, id: \.self) {
                        weather in
                        weather.getImage()
                            .tint(.pink)
                            .tag(weather as Weather?)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        
    }
}
