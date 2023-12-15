//
//  MapViewModel.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 12.12.2023.
//

import Foundation
import SwiftUI
import SwiftData
import _MapKit_SwiftUI

extension MapView {
    @Observable
    class ViewModel {
        // initial position if user hasn't logged any trips yet -> userLoacation, fallbacks to Central Europe
        let initialEmptyPosition: MapCameraPosition = .userLocation(
            fallback: .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: 50.073658,
                        longitude: 14.418540
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 10,
                        longitudeDelta: 10
                    )
                )
            )
        )
        var initialPosition: MapCameraPosition = .automatic
        var selection: String?
        var isMountainSheetPresented: Bool = false
        var modelContext: ModelContext
        var trips = [Trip]()
        var mountains = [Mountain]()
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            self.reload() // fetch data
            // if there are trips then set the position to the first mountain it fetches from database
            if let coordinates = trips.first?.mountain?.coordinates {
                let region = MKCoordinateRegion(
                    center: coordinates,
                    span: MKCoordinateSpan(
                        latitudeDelta: 10,
                        longitudeDelta: 10
                    )
                )
                self.initialPosition = .region(region)
            }
            // else we initialize map position to initialEmptyPosition
            else {
                self.initialPosition = initialEmptyPosition
            }
        }
        
        func dismissMountainSheet() {
            isMountainSheetPresented = false
            selection = nil
        }
        
        func presentMountainTrips() {
            // ensure selection is not nil
            guard let selection else {
                isMountainSheetPresented = false
                return }
            // ensure that selection matches mountain in database
            guard mountains.first(where: { $0.id == selection }) != nil else {
                isMountainSheetPresented = false
                return }
            // present sheet
            isMountainSheetPresented = true
        }
        
        func reload() {
            self.fetchData()
        }
        
        private func fetchData() {
            do {
                trips = try modelContext.fetch(FetchDescriptor<Trip>()).filter(#Predicate<Trip> { trip in
                    trip.mountain != nil
                })
                mountains = try modelContext.fetch(FetchDescriptor<Mountain>())
                mountains = Array(Set(mountains))
            } catch {
                print("Fetch failed")
            }
        }
    }
    
    
}

extension Sequence where Iterator.Element: Hashable {
    
    func uniqueValues() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
