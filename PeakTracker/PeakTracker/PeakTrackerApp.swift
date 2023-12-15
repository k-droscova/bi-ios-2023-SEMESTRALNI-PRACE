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
            /*
             NOTE: We configure schema for trips only, since I define only one way relationship with mountains in the model. The app could be made more efficient if we defined a one-to-many relationship that goes both ways. Such property could look like this:
                        @Relationship(deleteRule: .cascade, inverse: \Trip.muntain) var trips: [Trips] = []
             The way it is set up now means we store the same mountain multiple times (every time we enter a trip with the same mountain). However, it is not that bad since we can assume that the user would not go to the same mountain thousand times. If it was going to be causing some issues in the future it would be beneficial to migrate to a new schema and implement appropriate delete/add logic into viewModels.
             */
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
