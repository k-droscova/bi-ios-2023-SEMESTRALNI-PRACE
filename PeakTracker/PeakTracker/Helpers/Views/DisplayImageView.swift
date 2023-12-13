//
//  DisplayImageView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI

struct DisplayImageView: View {
    let title: String
    let content: Image
    var centerAlignment: Bool = false
    var body: some View {
        if centerAlignment {
            VStack(alignment: .center, spacing: 2) {
                Text(title)
                    .font(.caption)
                
                content
                    //.padding(.horizontal)
            }
        }
        else {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                
                content
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    DisplayImageView(title: "Weather", content: Weather.Sunny.getImage())
}
