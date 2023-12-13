//
//  PeakTrackerApp.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI
import SwiftData

@main
struct PeakTrackerApp: App {
    var container: ModelContainer
        init() {
            do {
                let config = ModelConfiguration(for: Trip.self)
                container = try ModelContainer(for: Trip.self, configurations: config)
            } catch {
                fatalError("Failed to configure SwiftData container.")
            }
        }

        var body: some Scene {
            WindowGroup {
                ContentView()
            }
            .modelContainer(container)
            
        }
}
