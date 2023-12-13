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
    var body: some View {
        List {
            ForEach(trips) { trip in
                NavigationLink {
                    DisplayTripView(trip: trip)
                }
                label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(formatDate(date:trip.date))
                                .font(.headline)
                            Spacer()
                            if let mountain = trip.mountain {
                                MountainDetailView(mountain: mountain)
                                    .font(.footnote)
                            }
                        }
                    }
                }
            }
            .onDelete(perform: deleteTrips)
        }
        
    }
    
    init(sort: SortDescriptor<Trip>, searchString: String) {
        _trips = Query(filter: #Predicate {
            if searchString.isEmpty {
                return true
            }
            else if let mountain = $0.mountain {
                return (mountain.name.localizedStandardContains(searchString))
            }
            else {
                return false
            }
        }, sort: [sort])
    }
    
    func deleteTrips(_ indexSet: IndexSet) {
        for index in indexSet {
            let trip = trips[index]
            modelContext.delete(trip)
            try? modelContext.save()
        }
    }
    
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
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
