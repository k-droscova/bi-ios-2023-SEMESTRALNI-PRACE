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
        let config1 = ModelConfiguration(for: Trip.self)
        let config2 = ModelConfiguration(for: Mountain.self)
        let container = try ModelContainer(for: Trip.self, Mountain.self, configurations: config1, config2)
        return  ImageSliderView(images: Trip.tripMock1.images)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container.")
    }
}
