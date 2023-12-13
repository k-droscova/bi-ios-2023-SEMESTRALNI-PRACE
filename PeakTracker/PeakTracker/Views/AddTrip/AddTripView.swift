//
//  AddTripView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddTripView: View {
    @Environment (\.presentationMode) var presentationMode
    @State private var viewModel: ViewModel
    var body: some View {
        Form {
            Section("Mountain") {
                NavigationLink {
                    SearchView(mountain: $viewModel.mountain)
                }
            label: {
                if let mountain = viewModel.mountain {
                    MountainDetailView(mountain: mountain)
                }
                else {
                    Text("Add Mountain")
                        .frame(maxWidth: .infinity)
                }
            }
            }
            
            Section("Photos") {
                PhotosPicker("Select Images", selection: $viewModel.selectedItems, matching: .any(of: [.images, .not(.videos)]))
                    .modifier(CenterModifier())
                viewModel.displayImages()
            }
            .listRowSeparator(.hidden)

            
            Section("Starting point") {
                TextField("Where did you start?", text: $viewModel.startingPoint)
            }
            
            DateAndSeasonPicker(date: $viewModel.date, season: $viewModel.season)
            
            Section("Hike Duration") {
                TimePicker(duration: $viewModel.time)
            }
            
            Section("Hiking Buddies") {
                List{
                    ForEach($viewModel.hikingBuddies, id: \.self) { $buddy in
                        Text(buddy)
                    }
                    .onDelete(perform: viewModel.deleteHikingBuddy)
                }
                HStack {
                    TextField("Who did you go with?", text: $viewModel.newBuddy)
                        .disableAutocorrection(true)
                    
                    Button("Add", action: viewModel.addHikingBuddy)
                }
            }
            Section("Details") {
                TextField("Anything to add?", text: $viewModel.details)
            }
            
            WeatherPicker(weather: $viewModel.weather)
            
            DifficultyPicker(difficulty: $viewModel.difficulty)
            
            RatingPicker(rating: $viewModel.rating)
            
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading:
                                Button {
            viewModel.restore()
            self.presentationMode.wrappedValue.dismiss()
            
        } label: {
            Text("Cancel")
        })
        .navigationBarItems(trailing:
                                Button {
            viewModel.save()
            
        } label: {
            Text("Save")
        })
        .alert(isPresented: $viewModel.errorWithSaving) {
            viewModel.getAlert()
        }
        .onChange(of: viewModel.selectedItems) {
            Task {await viewModel.reloadImages()
            }
        }
        .onChange(of: viewModel.goBack) {
            if viewModel.goBack {
                viewModel.restore()
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    

    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(for: Trip.self, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Trip.self, configurations: config)
        return AddTripView(modelContext: container.mainContext)
    } catch {
        fatalError("Failed to create model container.")
    }
}
