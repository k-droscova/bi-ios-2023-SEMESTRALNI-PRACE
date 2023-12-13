//
//  MapViewModel.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 12.12.2023.
//

import Foundation
import SwiftUI
import SwiftData

extension MapView {
    @Observable
    class ViewModel {
        var selection: String?
        var isPresented: Bool = false
        var modelContext: ModelContext
        var trips = [Trip]()
        var mountains = [Mountain]()
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
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
        
        func presentMountainDetails() -> some View {
            Group {
                if let mountain = mountains.first(where: { $0.id == selection })
                {
                    MapMountainSheetView(modelContext: modelContext,mountain: mountain)
                        .padding(.top, 16)
                        .onAppear(perform: {
                            self.reload()
                        })
                }
                else {
                    VStack{}
                        .onAppear(perform: {
                            self.reload()
                            self.dismiss()
                        })
                }
            }
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
