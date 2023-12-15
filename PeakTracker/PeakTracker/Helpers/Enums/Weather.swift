//
//  Weather.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation
import SwiftUI

enum Weather: Codable, CaseIterable {
    
    case Sunny, PartiallySunny, Cloudy, Rainy, Windy, Foggy, Snowy, Stormy
    
    func getImage() -> Image {
        switch self {
        case .Sunny:
            return Image(systemName: "sun.max")
        case .PartiallySunny:
            return Image(systemName: "cloud.sun")
        case .Cloudy:
            return Image(systemName: "cloud")
        case .Rainy:
            return Image(systemName: "cloud.rain")
        case .Windy:
            return Image(systemName: "wind")
        case .Foggy:
            return Image(systemName: "cloud.fog")
        case .Snowy:
            return Image(systemName: "cloud.snow")
        case .Stormy:
            return Image(systemName: "cloud.bolt")
        }
    }
}
