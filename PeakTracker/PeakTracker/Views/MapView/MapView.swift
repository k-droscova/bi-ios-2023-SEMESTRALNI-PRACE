//
//  MapView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI
import SwiftData
import _MapKit_SwiftUI

struct MapView: View {
    @State private var viewModel: ViewModel
    
    var body: some View {
        Map(initialPosition: viewModel.initialPosition, selection: $viewModel.selection) {
            // fills mountains with mountain markers
            ForEach(viewModel.mountains) { mountain in
                Marker(mountain.name, systemImage: "mountain.2.fill", coordinate: mountain.coordinates)
            }
        }
        .onChange(of: viewModel.selection) {
            viewModel.presentMountainTrips() // sets flag to show mountain sheet that corresponds to selection to true
        }
        .sheet(isPresented: $viewModel.isMountainSheetPresented, onDismiss: {
            viewModel.dismissMountainSheet()
        }, content: {
            presentMountainDetails()
        })
        .onAppear{
            viewModel.reload() // reloads data
        }
        .mapStyle(.hybrid) // hybrid style looks best for terrain :)
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    
    func presentMountainDetails() -> some View {
        Group {
            // show MapMountainSheetView of mountain that corresponds to selection
            if let mountain = viewModel.mountains.first(where: { $0.id == viewModel.selection })
            {
                MapMountainSheetView(modelContext: viewModel.modelContext, mountain: mountain)
                    .padding(.top, 16)
                    .onAppear(perform: {
                        viewModel.reload()
                    })
            }
            else {
                // this actually shouldn't occurr, but if it does then selection should be nullified by viewModel
                VStack{}
                    .onAppear(perform: {
                        viewModel.reload()
                        viewModel.dismissMountainSheet()
                    })
            }
        }
    }
}


#Preview {
    do {
        let config = ModelConfiguration(for: Trip.self, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Trip.self, configurations: config)
        return MapView(modelContext: container.mainContext)
    } catch {
        fatalError("Failed to create model container.")
    }
}

