//
//  ContentView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment (\.modelContext) var modelContext
    var body: some View {
        TabView {
            MapView(modelContext: self.modelContext)
                .tabItem {
                    Label(
                        "Map",
                        systemImage: "map"
                    )
                }
            
            AllTripsView(modelContext: self.modelContext)
                .tabItem {
                    Label(
                        "Trips",
                        systemImage: "mountain.2.fill"
                    )
                }
        }
        /*.onAppear(perform: {
            try? modelContext.delete(model: Trip.self)
            try? modelContext.delete(model: Mountain.self)
        })*/
    }

}

 #Preview {
     do {
         let config = ModelConfiguration(for: Trip.self, isStoredInMemoryOnly: true)
         let container = try ModelContainer(for: Trip.self, configurations: config)
         return ContentView()
                    .modelContainer(container)
     } catch {
         fatalError("Failed to create model container.")
     }
 }
