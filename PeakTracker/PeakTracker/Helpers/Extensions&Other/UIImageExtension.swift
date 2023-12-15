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
        // GET THE SIZES
        let width = self.size.width * self.scale
        let height = self.size.height * self.scale
        
        // GET THE MAX
        let max = max(width, height)
        if (max <= maxHeightOrWidth) {
            return self
        }
        // RESCALE
        let scale = maxHeightOrWidth / max
        let newWidth = width * scale
        let newHeight = height * scale
        
        // REDRAW
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
