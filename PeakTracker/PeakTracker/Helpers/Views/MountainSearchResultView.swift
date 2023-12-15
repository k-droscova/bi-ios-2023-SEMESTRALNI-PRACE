//
//  MountainSearchResultView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI
import SwiftData

struct MountainSearchResultView: View {
    var mountain: Mountain
    
    var body: some View {
        HStack {
            Text(mountain.name)
            Text(flag(country: mountain.country))
            Spacer()
            Text(String(mountain.elevation) + " m.n.m")
        }
    }
    
}


#Preview {
    do {
        let config = ModelConfiguration(for: Mountain.self, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Mountain.self, configurations: config)
        return MountainSearchResultView(mountain: Mountain.mountainMock1)
            .modelContext(container.mainContext)
    } catch {
        fatalError("Failed to create model container.")
    }
}

