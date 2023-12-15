//
//  TripListView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI
import SwiftData

struct TripListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Trip.mountain?.name),
                  SortDescriptor(\Trip.date)]) var trips: [Trip]
    
    // initializes the list with trips made to the mountain in searchString, sorted by sort
    init(sort: SortDescriptor<Trip>, searchString: String) {
        _trips = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true // returns all trips
            }
            else if let mountain = $0.mountain {
                // return true if trip was to the searched mountain
                return (mountain.name.localizedStandardContains(searchString))
            }
            else {
                // returns false if trip's mountain does not match the searched mountain
                return false
            }
        }, sort: [sort])
    }
    
    var body: some View {
        List {
            ForEach(trips) { trip in
                NavigationLink {
                    DisplayTripView(trip: trip)
                } label: {
                    tripLabel(trip: trip)
                }
            }
            .onDelete(perform: deleteTrips)
        }
        
    }
    
    func tripLabel(trip: Trip) -> some View {
        HStack {
            // trip Date
            Text(formatDate(date:trip.date))
                .font(.headline)
            
            Spacer()
            
            // trip mountain details
            if let mountain = trip.mountain {
                MountainDetailView(mountain: mountain)
                    .font(.footnote)
            }
        }
    }
    
    func deleteTrips(_ indexSet: IndexSet) {
        for index in indexSet {
            let trip = trips[index]
            modelContext.delete(trip)
            try? modelContext.save()
        }
    }
    
}


#Preview {
    do {
        let config = ModelConfiguration(for: Trip.self, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Trip.self, configurations: config)
        let modelContext = container.mainContext
        modelContext.insert(Trip.tripMock1)
        modelContext.insert(Trip.tripMock2)
        modelContext.insert(Trip.tripMock3)
        modelContext.insert(Trip.tripMock4)
        modelContext.insert(Trip.tripMock5)
        modelContext.insert(Trip.tripMock6)
        modelContext.insert(Trip.tripMock7)
        modelContext.insert(Trip.tripMock8)
        modelContext.insert(Trip.tripMock9)
        modelContext.insert(Trip.tripMock10)
        modelContext.insert(Trip.tripMock11)
        modelContext.insert(Trip.tripMock12)
        return TripListView(sort: SortDescriptor(\Trip.date), searchString: "")
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
