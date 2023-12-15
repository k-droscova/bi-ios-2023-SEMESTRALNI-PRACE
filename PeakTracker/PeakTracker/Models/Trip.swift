//
//  Trip.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 11.12.2023.
//

import Foundation
import SwiftData
import SwiftUI
import UIKit
import MapKit

@Model
final class Trip: Identifiable, Hashable {
    @Attribute(.unique) let id: UUID
    @Relationship(deleteRule: .cascade) var mountain: Mountain? //= Mountain.dummyMountain
    var date: Date
    var time: TripDuration
    var startingPoint: String
    var maxHeight: Float
    var hikingBuddies: [String]
    var details: String
    var weather: Weather
    var season: Season
    var difficulty: TripDifficulty
    var rating: TripRating
    @Attribute(.externalStorage) var images: [Data] = [] // this ONLY suggests to SwiftData that it might be better to store it outside of SQLite database
    
    init(mountain: Mountain? = nil, date: Date, time: TripDuration, startingPoint: String, maxHeight: Float, hikingBuddies: [String], details: String, weather: Weather, season: Season, difficulty: TripDifficulty, rating: TripRating, images: [Data] = []) {
        self.id = UUID()
        self.mountain = mountain
        self.date = date
        self.time = time
        self.startingPoint = startingPoint
        self.maxHeight = maxHeight
        self.hikingBuddies = hikingBuddies
        self.details = details
        self.weather = weather
        self.season = season
        self.difficulty = difficulty
        self.rating = rating
        self.images = images
    }
    
}

extension Trip {
    static let tripMock1: Trip = Trip(mountain: Mountain.mountainMock1, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock2: Trip = Trip(mountain: Mountain.mountainMock2, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock3: Trip = Trip(mountain: Mountain.mountainMock3, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock4: Trip = Trip(mountain: Mountain.mountainMock4, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock5: Trip = Trip(mountain: Mountain.mountainMock5, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock6: Trip = Trip(mountain: Mountain.mountainMock6, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock7: Trip = Trip(mountain: Mountain.mountainMock7, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock8: Trip = Trip(mountain: Mountain.mountainMock8, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock9: Trip = Trip(mountain: Mountain.mountainMock9, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock10: Trip = Trip(mountain: Mountain.mountainMock10, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock11: Trip = Trip(mountain: Mountain.mountainMock11, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock12: Trip = Trip(mountain: Mountain.mountainMock12, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock13: Trip = Trip(mountain: Mountain.mountainMock13, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock14: Trip = Trip(mountain: Mountain.mountainMock14, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock15: Trip = Trip(mountain: Mountain.mountainMock15, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    static let tripMock16: Trip = Trip(mountain: Mountain.mountainMock16, date: .now, time: TripDuration.init(), startingPoint: "Štrbské pleso", maxHeight: Mountain.mountainMock1.elevation, hikingBuddies: ["Barča"], details: "Nádherná túra!!", weather: Weather.Sunny, season: Season.Summer, difficulty: TripDifficulty.Difficult, rating: TripRating.Ten)
    
}

/*
 extension Trip {
 static let tripMock1: Trip = Trip(mountain: Mountain.mountainMock1, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock2: Trip = Trip(name: Mountain.mountainMock2.name, mountain: Mountain.mountainMock2, date: .now)
 static let tripMock3: Trip = Trip(name: Mountain.mountainMock3.name, mountain: Mountain.mountainMock3, date: .now, company: ["CVUT"])
 static let tripMock4: Trip = Trip(name: Mountain.mountainMock4.name, mountain: Mountain.mountainMock4, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock5: Trip = Trip(name: Mountain.mountainMock5.name, mountain: Mountain.mountainMock5, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock6: Trip = Trip(name: Mountain.mountainMock6.name, mountain: Mountain.mountainMock6, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock7: Trip = Trip(name: Mountain.mountainMock7.name, mountain: Mountain.mountainMock7, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock8: Trip = Trip(name: Mountain.mountainMock8.name, mountain: Mountain.mountainMock8, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock9: Trip = Trip(name: Mountain.mountainMock9.name, mountain: Mountain.mountainMock9, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock10: Trip = Trip(name: Mountain.mountainMock10.name, mountain: Mountain.mountainMock10, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock11: Trip = Trip(name: Mountain.mountainMock11.name, mountain: Mountain.mountainMock11, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock12: Trip = Trip(name: Mountain.mountainMock12.name, mountain: Mountain.mountainMock12, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock13: Trip = Trip(name: Mountain.mountainMock13.name, mountain: Mountain.mountainMock13, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock14: Trip = Trip(name: Mountain.mountainMock14.name, mountain: Mountain.mountainMock14, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock15: Trip = Trip(name: Mountain.mountainMock15.name, mountain: Mountain.mountainMock15, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 static let tripMock16: Trip = Trip(name: Mountain.mountainMock16.name, mountain: Mountain.mountainMock16, date: .now, company: ["Barča"], details: "Zo štrbského plesá a spať")
 
 }
 */
