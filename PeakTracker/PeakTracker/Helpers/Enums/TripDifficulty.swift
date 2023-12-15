//
//  TripDifficulty.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation

enum TripDifficulty: Codable, CaseIterable {
    case Easy, RelativelyEasy, Medium, RelativelyDifficult, Difficult, Hardcore
    
    func getNumerical() -> Int {
        switch self {
        case .Easy:
            return 1
        case .RelativelyEasy:
            return 2
        case .Medium:
            return 3
        case .RelativelyDifficult:
            return 4
        case .Difficult:
            return 5
        case .Hardcore:
            return 6
        }
    }
    
    
}
