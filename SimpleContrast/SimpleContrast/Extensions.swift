//
//  Colors.swift
//  SimpleContrast
//
//  Created by Jing Lin on 3/2/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//
import UIKit

extension UIImage {

    func thresholdColors(threshold: Float) -> UIImage {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: self, options: [CIImageOption.colorSpace: NSNull()])
        
        let thresholdFilter = ThresholdFilter()
        thresholdFilter.inputImage = coreImage
        thresholdFilter.threshold = threshold
        let thresholdImage = thresholdFilter.outputImage!
        let thresholdImageRef = ciContext.createCGImage(thresholdImage, from: thresholdImage.extent)

        return UIImage(cgImage: thresholdImageRef!, scale: self.scale, orientation: self.imageOrientation)
    }
    
    func invertColors(threshold: Float) -> UIImage {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: self, options: [CIImageOption.colorSpace: NSNull()])
        
        let thresholdFilter = ThresholdFilter()
        thresholdFilter.inputImage = coreImage
        thresholdFilter.threshold = threshold
        let thresholdImage = thresholdFilter.outputImage!
        
        // invert colors after thresholdImageRef is created
        let invertFilter = CIFilter(name: "CIColorInvert")!
        invertFilter.setValue(thresholdImage, forKey: "inputImage")
        let invertedImage = invertFilter.value(forKeyPath: "outputImage") as! CIImage
        let invertedImageRef = ciContext.createCGImage(invertedImage, from: invertedImage.extent)
        
        return UIImage(cgImage: invertedImageRef!, scale: self.scale, orientation: self.imageOrientation)
    }
    
}

