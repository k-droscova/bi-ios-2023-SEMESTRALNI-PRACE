//
//  Mountain.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation
import SwiftData
import UIKit
import MapKit

@Model
final class Mountain: Identifiable, Decodable, Hashable, Equatable, ObservableObject {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    public static func == (lhs: Mountain, rhs: Mountain) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case country = "country_code"
        case label = "feature_code"
        case latitude
        case longitude
        case elevation
    }
    var id: String
    var name: String
    var country: String
    var label: String
    var latitude: Float
    var longitude: Float
    var elevation: Float
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
    }
    
    init(name: String, country: String, label: String, latitude: Float, longitude: Float, elevation: Float) {
        self.id = UUID().uuidString
        self.name = name
        self.country = country
        self.label = label
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        self.id = String(id)
        self.name = try container.decode(String.self, forKey: .name)
        self.country = try container.decode(String.self, forKey: .country)
        self.label = try container.decode(String.self, forKey: .label)
        self.latitude = try container.decode(Float.self, forKey: .latitude)
        self.longitude = try container.decode(Float.self, forKey: .longitude)
        self.elevation = try container.decode(Float.self, forKey: .elevation)
    }
}

extension KeyedDecodingContainer {
    func decode<T: Decodable>(forKey key: Key) throws -> T  {
        try decode(T.self, forKey: key)
    }
}

extension Mountain {
    static let mountainMock1 = Mountain.init(name: "Rysy", country: "PL", label: "MT", latitude: 49.17907, longitude: 20.08842, elevation: 2499)
    static let mountainMock2 = Mountain.init(name: "Východná Vysoká", country: "SK", label: "MT", latitude: 49.17514, longitude: 20.14549, elevation: 2428)
    static let mountainMock3 = Mountain.init(name: "Ostrý Roháč", country: "SK", label: "MT", latitude: 49.20028, longitude: 19.75848, elevation: 2088)
    static let mountainMock4 = Mountain.init(name: "Sněžka", country: "CZ", label: "MT", latitude: 50.73609, longitude: 15.73979, elevation: 1603)
    static let mountainMock5 = Mountain.init(name: "Jahňací štít", country: "SK", label: "MT", latitude: 49.21984, longitude: 20.20828, elevation: 2230)
    static let mountainMock6 = Mountain.init(name: "Baníkov", country: "SK", label: "MT", latitude: 49.19756, longitude: 19.70994, elevation: 2178)
    static let mountainMock7 = Mountain.init(name: "Tri kopy", country: "SK", label: "MT", latitude: 49.19979, longitude: 19.72939, elevation: 2136)
    
    static let mountainMock8 = Mountain.init(name: "Chopok", country: "SK", label: "MT", latitude: 48.94466, longitude: 19.59021, elevation: 2023)
    static let mountainMock9 = Mountain.init(name: "Veľký Rozsutec", country: "SK", label: "MT", latitude: 49.23184, longitude: 19.09973, elevation: 1600)
    static let mountainMock10 = Mountain.init(name: "Kráľová Hoľa", country: "SK", label: "MT", latitude: 48.88333, longitude: 20.1395, elevation: 1946)
    static let mountainMock11 = Mountain.init(name: "Kriváň", country: "SK", label: "MT", latitude: 49.16248, longitude: 19.99988, elevation: 2495)
    
    static let mountainMock12 = Mountain.init(name: "Končistá", country: "SK", label: "MT", latitude: 49.15766, longitude: 20.11399, elevation: 2538)
    static let mountainMock13 = Mountain.init(name: "Baranec", country: "SK", label: "MT", latitude: 49.17348, longitude: 19.74097, elevation: 2184)
    static let mountainMock14 = Mountain.init(name: "Volovec", country: "PL", label: "MT", latitude: 49.20753, longitude: 19.76299, elevation: 2063)
    static let mountainMock15 = Mountain.init(name: "Choč", country: "SK", label: "MT", latitude: 49.15213, longitude: 19.34177, elevation: 1607)
    static let mountainMock16 = Mountain.init(name: "Chleb", country: "SK", label: "MT", latitude: 49.18891, longitude: 19.05068, elevation: 1646)
    
}

