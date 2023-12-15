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
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        Form {
            // MOUNTAIN SECTION
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
            }}
            
            // PHOTO PICKER AND SELECTED IMAGES
            Section("Photos") {
                PhotosPicker("Select Images", selection: $viewModel.selectedItems, matching: .any(of: [.images, .not(.videos)]))
                    .modifier(CenterModifier())
                displayImages() // displays images if they are selected, provides delete button
            }
            .listRowSeparator(.hidden)
            
            // STARTING POINT
            Section("Starting point") {
                TextField("Where did you start?", text: $viewModel.startingPoint)
            }
            
            // DATE AND SEASON
            DateAndSeasonPicker(date: $viewModel.date, season: $viewModel.season)
            
            // HIKE DURATION
            Section("Hike Duration") {
                TimePicker(duration: $viewModel.time)
            }
            
            // HIKING BUDDIES
            Section("Hiking Buddies") {
                // ALready added hiking buddies
                List{
                    ForEach($viewModel.hikingBuddies, id: \.self) { $buddy in
                        Text(buddy)
                    }
                    .onDelete(perform: viewModel.deleteHikingBuddy)
                }
                // Textfield to add another one
                HStack {
                    TextField("Who did you go with?", text: $viewModel.newBuddy)
                        .disableAutocorrection(true)
                    
                    Button("Add", action: viewModel.addHikingBuddy)
                }
            }
            
            // HIKE DETAILS
            Section("Details") {
                TextField("Anything to add?", text: $viewModel.details)
            }
            
            // TRAILING PICKERS
            WeatherPicker(weather: $viewModel.weather)
            
            DifficultyPicker(difficulty: $viewModel.difficulty)
            
            RatingPicker(rating: $viewModel.rating)
            
        }
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading:
                                // CANCEL BUTTON
                            Button {
            viewModel.restore() // ensures restore to default new trip values
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        })
        .navigationBarItems(trailing:
                                // SAVE BUTTON
                            Button {
            viewModel.save()
        } label: {
            Text("Save")
        })
        .alert(isPresented: $viewModel.errorWithSaving) {
            viewModel.getAlert()
        }
        .onChange(of: viewModel.selectedItems) {
            Task {
                await viewModel.reloadImages()
            }
        }
        .onChange(of: viewModel.goBack) {
            // ENSURES AUTOMATIC RETURN TO PREVIOUS VIEW UPON SAVING
            if viewModel.goBack {
                viewModel.restore()
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func displayImages() -> some View {
        Group {
            if !viewModel.selectedImages.isEmpty {
                VStack {
                    // TABVIEW
                    Group {
                        if viewModel.fetchingImages {
                            // ensures that the images are only revealed after they are ALL loaded from PhotosPicker
                            ProgressView()
                                .progressViewStyle(.circular)
                                .frame(width: 300, height: 370)
                                .modifier(CenterModifier())
                        }
                        else {
                            ImageSliderView(images: viewModel.selectedImages)
                        }
                    }
                    // DELETE BUTTON
                    Button {
                        viewModel.deleteImages()
                    } label: {
                        Text("Delete All Images")
                    }
                }
            }
        }
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
