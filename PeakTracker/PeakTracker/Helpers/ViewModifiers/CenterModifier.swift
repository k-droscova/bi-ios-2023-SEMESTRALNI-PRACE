//
//  CenterModifier.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 12.12.2023.
//

import Foundation
import SwiftUI

struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}
