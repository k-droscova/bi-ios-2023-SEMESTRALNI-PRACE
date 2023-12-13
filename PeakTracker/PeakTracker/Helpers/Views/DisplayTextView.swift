//
//  DisplayTextView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI

struct DisplayTextView: View {
    let title: String
    let content: String
    var centerAlignment: Bool = false
    var body: some View {
        if (centerAlignment) {
            VStack(alignment: .center, spacing: 2) {
                Text(title)
                    .font(.caption)
                
                Text(content)
                    .padding(.horizontal)
                
            }
        }
        else {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                
                Text(content)
                    .padding(.horizontal)
                
            }
        }
    }
}

#Preview {
    DisplayTextView(title: "Starting Point", content: "Štrbské pleso")
}
