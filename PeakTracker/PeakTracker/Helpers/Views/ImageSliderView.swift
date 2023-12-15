//
//  ImageSliderView.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import SwiftUI
import SwiftData

struct ImageSliderView: View {
    var images: [Data]
    init(images: [Data]) {
        self.images = images
        // Changes the TabView page indicator to pink
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.2)
    }
    func createImage(_ value: Data) -> Image {
        let img: UIImage = UIImage(data: value) ?? UIImage()
        return Image(uiImage: img)
    }
    var body: some View {
        if images.isEmpty {
            Rectangle()
                .frame(width: UIScreen.main.bounds.size.width, height: 370)
        }
        else {
            TabView {
                ForEach(images, id: \.self) { image in
                    createImage(image)
                        .resizable()
                        .scaledToFit()
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
        return  ImageSliderView(images: Trip.tripMock1.images)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
