//
//  UIImageExtensions.swift
//  PeakTracker
//
//  Created by Karolína Droscová on 12.12.2023.
//

import Foundation
import SwiftUI

extension UIImage {
    func resizeImage(maxHeightOrWidth: CGFloat) -> UIImage {
        let width = self.size.width * self.scale
        //print("original width: " + String(Float(width)))
        let height = self.size.height * self.scale
        //print("original height: " + String(Float(height)))
        let max = max(width, height)
        //print("maximum: " + String(Float(max)))
        if (max <= maxHeightOrWidth) {
            return self
        }
        let scale = maxHeightOrWidth / max
        let newWidth = width * scale
        //print("new width: " + String(Float(newWidth)))
        let newHeight = height * scale
        //print("new height: " + String(Float(newHeight)))
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
