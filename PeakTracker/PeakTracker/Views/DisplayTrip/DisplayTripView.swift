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
    var displayHeader: Bool = true // to display mountain details at the top
    var trip: Trip
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                // MOUNTAIN DETAILS
                if displayHeader {
                    if let mountain = trip.mountain {
                        MountainDetailView(mountain: mountain)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                
                // TRIP DETAILS
                HStack {
                    leftColumn()
                    Spacer()
                    rightColumn()
                }
                
                // HIKING BUDDIES
                DisplayTextView(title: "Hiking Buddies", content: getHikingBuddies())
                
                // TRIP NOTES
                DisplayTextView(title: "Notes", content: trip.details)
                
            }
            .padding(.horizontal, 24)
            
            // PHOTOS
            SliderTabView(trip: trip)
                .padding(.horizontal)
        }
        .navigationBarItems(trailing: NavigationLink {
            EditTripView(trip: trip, modelContext: self.modelContext)
        } label: {
            Text("Edit")
        })
        
    }
    
    func leftColumn() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            DisplayTextView(title: "Starting Point", content: trip.startingPoint)
            DisplayTextView(title: "Peak Height", content: String(Mountain.mountainMock1.elevation)+" m.n.m")
            HStack(spacing: 0) {
                DisplayImageView(title: "Weather   ", content: trip.weather.getImage(), centerAlignment: true)
                DisplayTextView(title: "Rating", content: String(trip.rating.getNumerical()) +  " / 10", centerAlignment: true)
                DisplayTextView(title: "Difficulty", content: String(trip.difficulty.getNumerical()) +  " / 6", centerAlignment: true)
            }
        }
    }
    
    func rightColumn() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            DisplayTextView(title: "Date", content: formatDate(date: trip.date))
            DisplayTextView(title: "Duration", content: formatTime(time: trip.time))
            DisplayImageView(title: "Season", content: trip.season.getImage())
        }
    }
    
    func getHikingBuddies() -> String {
        return trip.hikingBuddies.joined(separator: ", ")
    }
    
    func formatTime(time: TripDuration) -> String {
        return String(Int(time.hourSelection)) + " h " + String(Int(time.minuteSelection)) + " min "
    }
    
    struct SliderTabView: View {
        var trip: Trip
        init(trip: Trip) {
            self.trip = trip
            UIPageControl.appearance().currentPageIndicatorTintColor = .red
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.2)
        }
        func createImage(_ value: Data) -> Image {
            let img: UIImage = UIImage(data: value) ?? UIImage()
            return Image(uiImage: img)
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
