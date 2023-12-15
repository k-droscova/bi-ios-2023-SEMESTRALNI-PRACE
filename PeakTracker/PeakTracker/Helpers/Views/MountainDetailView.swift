//
//  MountainDetailView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI
import SwiftData

struct MountainDetailView: View {
    var mountain: Mountain
    
    var body: some View {
        HStack {
            Text(mountain.name)
            Text(flag(country: mountain.country))
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(for: Mountain.self, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Mountain.self, configurations: config)
        return MountainDetailView(mountain: Mountain.mountainMock1)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
