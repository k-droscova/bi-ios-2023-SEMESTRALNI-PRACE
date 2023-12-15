//
//  AllTripsView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI
import SwiftData

struct AllTripsView: View {
    @State private var viewModel: ViewModel
    
    init(modelContext: ModelContext) {
        viewModel = ViewModel(modelContext: modelContext)
    }
    
    var body: some View {
        NavigationStack {
            // tripListView which responds to changes in sort order and search bar input
            TripListView(sort: viewModel.sortOrder, searchString: viewModel.searchText)
                .navigationTitle("My Trips")
                .searchable(text: $viewModel.searchText, prompt: "Search by Mountain") // for search bar
                .toolbar {
                    // MOCK BUTTON
                    Button("Add Mocks", action: viewModel.addMocks)
                    
                    // ADD BUTTON
                    NavigationLink {
                        AddTripView(modelContext: viewModel.modelContext)
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    // DELETE BUTTON
                    Button(action: viewModel.wantToDelete) {
                        Image(systemName: "trash")
                    }
                    
                    // SORTING PICKER
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $viewModel.sortOrder) {
                            
                            Text("Mountain")
                                .tag(SortDescriptor(\Trip.mountain?.name))
                            
                            Text("Date")
                                .tag(SortDescriptor(\Trip.date))
                        }
                        .pickerStyle(.inline)
                    }
                }
                .alert(isPresented: $viewModel.showAlert, content: {
                    viewModel.getAlert()
                })
        }
    }
}


#Preview {
    do {
        let config = ModelConfiguration(for: Trip.self, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Trip.self, configurations: config)
        return AllTripsView(modelContext: container.mainContext)
    } catch {
        fatalError("Failed to create model container.")
    }
}

