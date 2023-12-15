//
//  FlagFunction.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 15.12.2023.
//

import Foundation

// GETS COUNTRY FLAG FROM COUNTRY CODE
func flag(country:String) -> String {
    let base : UInt32 = 127397
    var s = ""
    for v in country.unicodeScalars {
        s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }
    return String(s)
}
