//
//  AllTripsViewModel.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 12.12.2023.
//

import Foundation
import SwiftData
import SwiftUI


extension AllTripsView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var searchText: String = ""
        var sortOrder = SortDescriptor(\Trip.mountain?.name) // by default it sort by mountain name
        var showAlert = false
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
        
        func addMocks() {
            modelContext.autosaveEnabled = false
            modelContext.insert(Trip.tripMock1)
            modelContext.insert(Trip.tripMock2)
            modelContext.insert(Trip.tripMock3)
            modelContext.insert(Trip.tripMock4)
            modelContext.insert(Trip.tripMock5)
            modelContext.insert(Trip.tripMock6)
            modelContext.insert(Trip.tripMock7)
            modelContext.insert(Trip.tripMock8)
            modelContext.insert(Trip.tripMock9)
            modelContext.insert(Trip.tripMock10)
            modelContext.insert(Trip.tripMock11)
            modelContext.insert(Trip.tripMock12)
            modelContext.insert(Trip.tripMock13)
            modelContext.insert(Trip.tripMock14)
            modelContext.insert(Trip.tripMock15)
            modelContext.insert(Trip.tripMock16)
            try? modelContext.save()
            modelContext.autosaveEnabled = true
        }
        
        func wantToDelete() {
            self.showAlert = true // sets flag for alert
        }
        
        func deleteAll() {
            showAlert = false
            do {
                modelContext.autosaveEnabled = false
                try modelContext.delete(model: Trip.self)
                try modelContext.save()
                modelContext.autosaveEnabled = true
                
            } catch {
                print("ERROR WITH DELETE")
            }
        }
        
        func getAlert() -> Alert {
            return Alert(
                title: Text("Warning"),
                message: Text("All data will be lost. Are you sure you want to proceed?"),
                primaryButton: Alert.Button.cancel(Text("No"), action: {
                    self.showAlert = false // dismisses alert without further action
                }),
                secondaryButton: Alert.Button.default(Text("Yes"), action: {
                    self.deleteAll() // deletes all data
                })
            )
        }
    }
}
