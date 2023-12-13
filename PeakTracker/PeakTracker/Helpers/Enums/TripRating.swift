//
//  TripRating.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation

enum TripRating: Codable, CaseIterable {
    case One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    
    func getNumerical() -> Int {
        switch self {
        case .One:
            return 1
        case .Two:
            return 2
        case .Three:
            return 3
        case .Four:
            return 4
        case .Five:
            return 5
        case .Six:
            return 6
        case .Seven:
            return 7
        case .Eight:
            return 8
        case .Nine:
            return 9
        case .Ten:
            return 10
        }
    }
}
