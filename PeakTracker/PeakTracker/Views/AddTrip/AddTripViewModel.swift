//
//  AddTripViewModel.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation
import SwiftData
import SwiftUI
import PhotosUI

extension AddTripView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        
        // INITIALIZE VARIABLES FOR TRIP FOR ADING NEW TRIP
        var mountain: Mountain? = nil
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
        var images: [Data] = []
        
        // FOR IMAGE SELECTION
        var selectedItems = [PhotosPickerItem]()
        var selectedImages = [Data]()
        var fetchingImages: Bool = false
        
        
        // FOR DISPLAYING ALERT
        var errorWithSaving: Bool = false
        
        // FOR RETURNING BACK
        var goBack: Bool = false
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            self.restore() // restores to default values when initialized, this solved problem that for some reason the viewModel kept information from previous Trip that was added
        }
        
        private func calculateSeason() -> Season {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.month], from: self.date)
            let month = components.month!
            if (month == 12 || month <= 2) {
                return Season.Winter
            }
            else if (month <= 5) {
                return Season.Spring
            }
            else if (month <= 8) {
                return Season.Summer
            }
            return Season.Winter
        }
        
        
        func deleteImages() {
            selectedImages.removeAll()
        }
        
        func reloadImages() async {
            self.deleteImages()
            
            fetchingImages = true
            for item in selectedItems {
                if let image = try? await item.loadTransferable(type: Data.self) {
                    let uiImage = UIImage(data: image)
                    let img = uiImage?.resizeImage(maxHeightOrWidth: 1024)
                    let image = img?.jpegData(compressionQuality: 1)
                    selectedImages.append(image!)
                }
            }
            fetchingImages = false
        }
        
        func addHikingBuddy() {
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
        
        
        func validateInputs() -> Bool {
            return mountain != nil && weather != nil && season != nil && difficulty != nil && rating != nil
        }
        
        func save() {
            if validateInputs() {
                let trip = Trip(
                    mountain: mountain!,
                    date: date,
                    time: time,
                    startingPoint: startingPoint,
                    maxHeight: mountain!.elevation,
                    hikingBuddies: hikingBuddies,
                    details: details,
                    weather: weather!,
                    season: season!,
                    difficulty: difficulty!,
                    rating: rating!,
                    images: selectedImages
                )
                modelContext.insert(trip)
                try? modelContext.save()
                goBack = true
            }
            else {
                errorWithSaving = true
            }
        }
        
        func restore() {
            self.mountain = nil
            self.date = .now
            self.time = TripDuration()
            self.startingPoint = ""
            self.maxHeight = 0
            self.hikingBuddies = []
            self.newBuddy = ""
            self.details = ""
            self.weather = nil
            self.season = calculateSeason()
            self.difficulty = nil
            self.rating = nil
            self.images = []
            self.selectedItems = []
            self.selectedImages = []
            self.fetchingImages = false
            self.errorWithSaving = false
            self.goBack = false
        }
        
        
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
