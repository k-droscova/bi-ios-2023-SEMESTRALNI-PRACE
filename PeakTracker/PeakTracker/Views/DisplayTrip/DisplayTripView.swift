//
//  DisplayTripView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI
import SwiftData

struct DisplayTripView: View {
    @Environment(\.modelContext) var modelContext
    var displayHeader: Bool = true
    var trip: Trip
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                if displayHeader {
                    if let mountain = trip.mountain {
                        MountainDetailView(mountain: mountain)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        DisplayTextView(title: "Starting Point", content: trip.startingPoint)
                        DisplayTextView(title: "Peak Height", content: String(Mountain.mountainMock1.elevation)+" m.n.m")
                        HStack(spacing: 0) {
                            DisplayImageView(title: "Weather   ", content: trip.weather.getImage(), centerAlignment: true)
                            DisplayTextView(title: "Rating", content: String(trip.rating.getNumerical()) +  " / 10", centerAlignment: true)
                            DisplayTextView(title: "Difficulty", content: String(trip.difficulty.getNumerical()) +  " / 6", centerAlignment: true)
                        }
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 8) {
                        DisplayTextView(title: "Date", content: formatDate(date: trip.date))
                        DisplayTextView(title: "Duration", content: formatTime(time: trip.time))
                        DisplayImageView(title: "Season", content: trip.season.getImage())
                    }
                }
                DisplayTextView(title: "Hiking Buddies", content: getHikingBuddies())
                
                DisplayTextView(title: "Notes", content: trip.details)
                
            }
            .padding(.horizontal, 24)
            
            SliderTabView(trip: trip)
                .padding(.horizontal)
        }
        .navigationBarItems(trailing:
                                
                                NavigationLink {
            EditTripView(trip: trip, modelContext: self.modelContext)
        } label: {
            Text("Edit")
        })
        
    }
    
    func getHikingBuddies() -> String {
        return trip.hikingBuddies.joined(separator: ", ")
    }
    
    func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    func formatTime(time: TripDuration) -> String {
        return String(Int(time.hourSelection)) + " h " + String(Int(time.minuteSelection)) + " min "
    }
    
    mutating func reload(){
        trip = modelContext.model(for: self.trip.persistentModelID) as! Trip
    }
    
    
    struct SliderTabView: View {
        var trip: Trip
        init(trip: Trip) {
            self.trip = trip
            UIPageControl.appearance().currentPageIndicatorTintColor = .red
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.2)
        }
        func createImage(_ value: Data) -> Image {
#if canImport(UIKit)
            let songArtwork: UIImage = UIImage(data: value) ?? UIImage()
            return Image(uiImage: songArtwork)
#elseif canImport(AppKit)
            let songArtwork: NSImage = NSImage(data: value) ?? NSImage()
            return Image(nsImage: songArtwork)
#else
            return Image(systemImage: "some_default")
#endif
        }
        var body: some View {
            TabView {
                ForEach(trip.images, id: \.self) { image in
                    createImage(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: UIScreen.main.bounds.size.width, // NOTE, this is not a good idea if we want to use landscape orientation or if the screen proportions will not be exactly to our preview model
                            height: 300
                        )
                        .clipped()
                }
            }
            .frame(height: 370)
            .tabViewStyle(
                PageTabViewStyle(indexDisplayMode: .automatic) // shows scrollbar only if there are at least 2 photos
            )
        }
        
    }
    
    
}

#Preview {
    do {
        let config = ModelConfiguration(for: Trip.self, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Trip.self, configurations: config)
        let modelContext = container.mainContext
        modelContext.insert(Trip.tripMock1)
        return DisplayTripView(trip: Trip.tripMock1)
            .modelContext(modelContext)
    } catch {
        fatalError("Failed to create model container.")
    }
}
