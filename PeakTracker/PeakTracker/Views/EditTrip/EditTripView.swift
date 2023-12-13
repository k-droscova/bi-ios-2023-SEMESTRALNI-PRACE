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
    
    init(trip: Trip, modelContext: ModelContext) {
        let viewModel = ViewModel(trip: trip, modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    var body: some View {
        Form {
            
            Section("Photos") {
                PhotosPicker("Select Images", selection: $viewModel.selectedItems, matching: .any(of: [.images, .not(.videos), .not(.screenshots)]))
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
        .navigationTitle("Edit Trip")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading:
                                Button {
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
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

/*#Preview {
 EditTripView()
 }
 */
