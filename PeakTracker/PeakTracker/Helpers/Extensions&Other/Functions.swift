//
//  formatDateFunction.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 15.12.2023.
//

import Foundation

func flag(country:String) -> String {
    let base : UInt32 = 127397
    var s = ""
    for v in country.unicodeScalars {
        s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }
    return String(s)
}


func formatDate(date: Date) -> String{
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .short
    formatter.timeZone = TimeZone.current
    return formatter.string(from: date)
}

