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
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        Map(initialPosition: viewModel.initialPosition, selection: $viewModel.selection) {
            ForEach(viewModel.mountains) { mountain in
                Marker(mountain.name, systemImage: "mountain.2.fill", coordinate: mountain.coordinates)
            }
        }
        .sheet(isPresented: $viewModel.isPresented, onDismiss:
                {
            viewModel.dismiss()
        }, content: {
            presentMountainDetails()
        })
        .onChange(of: viewModel.selection) {
            viewModel.present()
        }
        .onAppear{viewModel.fetchData()}
        .mapStyle(.hybrid)
    }
    
    
    func presentMountainDetails() -> some View {
        Group {
            if let mountain = viewModel.mountains.first(where: { $0.id == viewModel.selection })
            {
                MapMountainSheetView(modelContext: viewModel.modelContext, mountain: mountain)
                    .padding(.top, 16)
                    .onAppear(perform: {
                        viewModel.reload()
                    })
            }
            else {
                VStack{}
                    .onAppear(perform: {
                        viewModel.reload()
                        viewModel.dismiss()
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
 
