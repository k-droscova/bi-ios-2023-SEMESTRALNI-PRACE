//
//  MapMountainSheetView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 12.12.2023.
//

import SwiftUI
import SwiftData

struct MapMountainSheetView: View {
    @Environment (\.dismiss) var dismiss
    let mountain: Mountain
    @State private var viewModel: ViewModel
    
    init(modelContext: ModelContext, mountain: Mountain) {
        self.mountain = mountain
        let viewModel = ViewModel(modelContext: modelContext, mountain: mountain)
        _viewModel = State(initialValue: viewModel)
    }
    
    
    var body: some View {
        MountainDetailView(mountain: mountain)
            .font(.headline)
        NavigationStack {
            List(selection: $viewModel.selection) {
                ForEach(viewModel.trips) { trip in
                    NavigationLink(destination: DisplayTripView(displayHeader: false, trip: trip)) {
                        Text(formatDate(date:trip.date))
                            .font(.headline)
                    }
                }
                .onDelete(perform: viewModel.deleteTrips)
            }
        }
        .onAppear(perform: {
            viewModel.reset()
        })
        .onChange(of: viewModel.dismiss) {
            if viewModel.dismiss {
                self.dismiss()
            }
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
         return MapMountainSheetView(modelContext: modelContext, mountain: Mountain.mountainMock1)
     } catch {
         fatalError("Failed to create model container.")
     }
 }
 
