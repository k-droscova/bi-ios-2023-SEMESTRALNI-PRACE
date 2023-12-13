//
//  AllTripsView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI
import SwiftData

struct AllTripsView: View {
    @State private var modelContext: ModelContext
    //@Environment(\.modelContext) var modelContext
    @State private var viewModel: ViewModel
    
    init(modelContext: ModelContext) {
        _modelContext = State(initialValue: modelContext)
        viewModel = ViewModel(modelContext: modelContext)
    }
    
    var body: some View {
        NavigationStack {
            TripListView(sort: viewModel.sortOrder, searchString: viewModel.searchText)
                .navigationTitle("My Trips")
                .searchable(text: $viewModel.searchText)
                .toolbar {
                    Button("Add Mocks", action: viewModel.addMocks)
                    
                    NavigationLink {
                        AddTripView(modelContext: modelContext)
                    }
                    label: {
                        Image(systemName: "plus")
                    }
                    
                    Button(action: viewModel.wantToDelete) {
                        Image(systemName: "trash")
                    }

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
                /*.onAppear(perform: {
                    viewModel.reload()
                })*/
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
 
