//
//  MapMountainSheetModel.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 12.12.2023.
//

import Foundation
import SwiftUI
import SwiftData

extension MapMountainSheetView {
    @Observable
    class ViewModel {
        var trips = [Trip]()
        var selection: Trip? = nil
        let mountain: Mountain
        var modelContext: ModelContext
        var dismiss: Bool = false
        
        init(modelContext: ModelContext, mountain: Mountain) {
            self.mountain = mountain
            self.modelContext = modelContext
            fetchData()
        }
        
        
        func fetchData() {
            do {
                trips = try modelContext.fetch(FetchDescriptor<Trip>()).filter(#Predicate<Trip> { trip in
                    trip.mountain != nil
                }) // get all trips
                trips = trips.filter({$0.mountain!.name == self.mountain.name}) // filter trips for current mountain
            } catch {
                print("Fetch failed")
            }
            if trips.isEmpty {
                self.dismiss = true
            }
        }
        
        // ensures 
        func reset() {
            self.selection = nil
            self.dismiss = false
        }
        
        func deleteTrips(_ indexSet: IndexSet) {
            for index in indexSet {
                let trip = trips[index]
                modelContext.delete(trip) // remove from database
                try? modelContext.save() // save changes
                trips.remove(at: index) // remove from trips
            }
            // ensures that when we delete last trip for the mountain then the sheet automatically scrolls down
            if trips.isEmpty {
                self.dismiss = true
            }
        }
    }
}
