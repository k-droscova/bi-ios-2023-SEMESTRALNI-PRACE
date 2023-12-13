//
//  Seasons.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation
import SwiftUI

enum Season: Codable, CaseIterable {
    case Spring, Summer, Autumn, Winter
    func getImage() -> Image {
        switch self {
        case .Spring:
            return Image(systemName: "bird")
        case .Summer:
            return Image(systemName: "sun.min")
        case .Autumn:
            return Image(systemName: "leaf")
        case .Winter:
            return Image(systemName: "snowflake")
        }
    }
}
