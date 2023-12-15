//
//  EditTripView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 12.12.2023.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditTripView: View {
    @Environment (\.presentationMode) var presentationMode
    @State private var viewModel: ViewModel
    var body: some View {
        Form {
            // PHOTOS PICKER AND IMAGES
            Section("Photos") {
                PhotosPicker("Select Images", selection: $viewModel.selectedItems, matching: .any(of: [.images, .not(.videos), .not(.screenshots)]))
                    .modifier(CenterModifier())
                displayImages()
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
                // Already added hiking buddies
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
        .navigationTitle("Edit Trip")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading:
                                // CANCEL BUTTON
                            Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        })
        .navigationBarItems(trailing:
                                // SAVING BUTTON
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
    
    init(trip: Trip, modelContext: ModelContext) {
        let viewModel = ViewModel(trip: trip, modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(for: Trip.self, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Trip.self, configurations: config)
        let modelContext = container.mainContext
        let trip = Trip.tripMock1
        modelContext.insert(trip)
        return EditTripView(trip: trip, modelContext: modelContext)
    } catch {
        fatalError("Failed to create model container.")
    }
}
