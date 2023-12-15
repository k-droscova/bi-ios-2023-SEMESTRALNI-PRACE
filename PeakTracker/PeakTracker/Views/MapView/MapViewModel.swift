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
        var isPresented: Bool = false
        var modelContext: ModelContext
        var trips = [Trip]()
        var mountains = [Mountain]()
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
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
            else {
                self.initialPosition = initialEmptyPosition
            }
        }
        
        func dismiss() {
            isPresented = false
            selection = nil
            try? modelContext.save()
        }
        
        func reload() {
            try? modelContext.save()
            self.fetchData()

        }
        
        func present() {
            self.fetchData()
            guard let selection else {
                isPresented = false
                return }
            guard mountains.first(where: { $0.id == selection }) != nil else {
                isPresented = false
                return }
            isPresented = true
        }
        
        func fetchData() {
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
