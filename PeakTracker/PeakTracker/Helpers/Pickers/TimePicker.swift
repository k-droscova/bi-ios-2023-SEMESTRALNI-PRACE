//
//  TimePicker.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation
import SwiftUI

struct TimePicker: View {
    @Binding var duration: TripDuration
    
    static private let maxHours = 24
    static private let maxMinutes = 60
    private let hours = [Int](0...Self.maxHours)
    private let minutes = [Int](0...Self.maxMinutes)
    
    private let spacing: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: spacing) {
                Picker(selection: $duration.hourSelection, label: Text("Hours")) {
                    ForEach(hours, id: \.self) { value in
                        Text("\(value) hr")
                            .tag(value)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: (geometry.size.width-spacing) / 2, alignment: .leading)
                Picker(selection: $duration.minuteSelection, label: Text("Minutes")) {
                    ForEach(minutes, id: \.self) { value in
                        Text("\(value) min")
                            .tag(value)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .pickerStyle(.menu)
                .frame(width: (geometry.size.width-spacing) / 2, alignment: .leading)
            }
        }
    }
}
