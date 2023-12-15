//
//  EditTripModel.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 12.12.2023.
//

import Foundation
import SwiftData
import SwiftUI
import PhotosUI

extension EditTripView {
    @Observable
    class ViewModel {
        var trip: Trip
        var modelContext: ModelContext
        
        // INITIALIZE VARIABLES FOR TRIP FOR EDITING + SAVING
        var mountain: Mountain?
        var date: Date = .now
        var time: TripDuration = TripDuration.init()
        var startingPoint: String = ""
        var maxHeight: Float = 0
        var hikingBuddies: [String] = []
        var newBuddy: String = ""
        var details: String = ""
        var weather: Weather?
        var season: Season?
        var difficulty: TripDifficulty?
        var rating: TripRating?
        
        // FOR IMAGE SELECTION
        var selectedItems = [PhotosPickerItem]()
        var selectedImages = [Data]()
        var fetchingImages: Bool = false
        
        // FOR DISPLAYING ALERT
        var errorWithSaving: Bool = false
        
        // FOR RETURNING BACK
        var goBack: Bool = false
        
        init(trip: Trip, modelContext: ModelContext) {
            self.trip = trip
            self.modelContext = modelContext
            self.date = trip.date
            self.mountain = trip.mountain
            self.startingPoint = trip.startingPoint
            self.maxHeight = trip.maxHeight
            self.hikingBuddies = trip.hikingBuddies
            self.details = trip.details
            self.weather = trip.weather
            self.season = trip.season
            self.difficulty = trip.difficulty
            self.rating = trip.rating
            self.selectedImages = trip.images
        }
        
        // this is used to restore after cancelation
        func restore() {
            self.trip = trip
            self.modelContext = modelContext
            self.date = trip.date
            self.mountain = trip.mountain
            self.startingPoint = trip.startingPoint
            self.maxHeight = trip.maxHeight
            self.hikingBuddies = trip.hikingBuddies
            self.details = trip.details
            self.weather = trip.weather
            self.season = trip.season
            self.difficulty = trip.difficulty
            self.rating = trip.rating
            self.selectedImages = trip.images
            self.selectedItems = []
        }
        
        func deleteImages() {
            selectedImages.removeAll()
        }
        
        func reloadImages() async {
            self.deleteImages()
            
            fetchingImages = true // set flag for progress view
            for item in selectedItems {
                if let image = try? await item.loadTransferable(type: Data.self) {
                    let uiImage = UIImage(data: image)
                    let img = uiImage?.resizeImage(maxHeightOrWidth: 1024)
                    let image = img?.jpegData(compressionQuality: 1)
                    selectedImages.append(image!)
                }
            }
            fetchingImages = false // set flag to display images
        }
        
        func addHikingBuddy() {
            // only perform add if new hiking buddy is not empty
            guard newBuddy.isEmpty == false else { return }
            withAnimation {
                hikingBuddies.append(newBuddy)
                newBuddy = ""
            }
        }
        
        func deleteHikingBuddy(_ indexSet: IndexSet) {
            for index in indexSet {
                hikingBuddies.remove(at: index)
            }
        }
        
        // validates that all necessary properties are set
        private func validateInputs() -> Bool {
            return mountain != nil && weather != nil && season != nil && difficulty != nil && rating != nil
        }
        
        func save() {
            if validateInputs() {
                // Force unwrapping is OK here since inputs are already validated
                trip.date = date
                trip.time = time
                trip.startingPoint = startingPoint
                trip.hikingBuddies = hikingBuddies
                trip.details = details
                trip.weather = weather!
                trip.season = season!
                trip.difficulty = difficulty!
                trip.rating = rating!
                trip.images = selectedImages
                goBack = true // set flag to return to previous view
            }
            else {
                errorWithSaving = true
            }
        }
        
        // displays appropriate alert depending on what property was not set
        func getAlert() -> Alert {
            if mountain == nil {
                return Alert(
                    title: Text("Error"),
                    message: Text("Must select mountain"),
                    dismissButton:  Alert.Button.default(Text("OK"), action: {
                        self.errorWithSaving = false
                    })
                )
            }
            else if weather == nil {
                return Alert(
                    title: Text("Error"),
                    message: Text("Must select weather"),
                    dismissButton:  Alert.Button.default(Text("OK"), action: {
                        self.errorWithSaving = false
                    })
                )
            }
            else if season == nil {
                return Alert(
                    title: Text("Error"),
                    message: Text("Must select season"),
                    dismissButton:  Alert.Button.default(Text("OK"), action: {
                        self.errorWithSaving = false
                    })
                )
            }
            else if difficulty == nil {
                return Alert(
                    title: Text("Error"),
                    message: Text("Must select difficulty"),
                    dismissButton:  Alert.Button.default(Text("OK"), action: {
                        self.errorWithSaving = false
                    })
                )
            }
            else {
                return Alert(
                    title: Text("Error"),
                    message: Text("Must select rating"),
                    dismissButton:  Alert.Button.default(Text("OK"), action: {
                        self.errorWithSaving = false
                    })
                )
            }
        }
        
        
    }
}
