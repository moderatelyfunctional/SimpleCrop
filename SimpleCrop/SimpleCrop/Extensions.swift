//
//  Colors.swift
//  SimpleCrop
//
//  Created by Jing Lin on 3/2/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//
import UIKit

extension UIImage {
    
//    CIFilter* filter = [CIFilter filterWithName:@"CIColorInvert"];
//    [filter setDefaults];
//    [filter setValue:ciImage forKey:@"inputImage"];
//    CIImage* output = [filter valueForKey:@"outputImage"];
//
//    NSRect centeredRect = NSMakeRect(0, 0, 0, 0);
//    centeredRect = NSMakeRect(0, 0, [drawnImage size].width, [drawnImage size].height);
//
//    // align left if we have a title
//    if(self.attributedTitle) {
//    centeredRect.origin.x = 2;
//    }
//    else
//    centeredRect.origin.x = NSMidX([self bounds]) - ([drawnImage size].width / 2);
//
//    centeredRect.origin.y = NSMidY([self bounds]) - ([drawnImage size].height / 2) - 1;
//    centeredRect = NSIntegralRect(centeredRect);
//    [output drawInRect:centeredRect fromRect:NSRectFromCGRect([output extent]) operation:NSCompositeSourceOut fraction:0.75f];

    func invertColors() -> UIImage { //processes colors, doesn't actually invert them
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: self, options: [CIImageOption.colorSpace: NSNull()])

//        let invertFilter = CIFilter(name: "CIColorInvert")!
//        invertFilter.setValue(coreImage, forKey: "inputImage")
//        let invertedImage = invertFilter.value(forKeyPath: "outputImage") as! CIImage
//        let filteredImageRef = ciContext.createCGImage(invertedImage, from: invertedImage.extent)
        
//        let colorFilter = CIFilter(name: "CIColorControls")!
//        colorFilter.setValue(coreImage, forKey: "inputImage")
//        colorFilter.setValue(0.75, forKey: "inputContrast")
//        let colorImage = colorFilter.value(forKeyPath: "outputImage") as! CIImage
//        let filteredImageRef = ciContext.createCGImage(colorImage, from: colorImage.extent)
        
//        let sharpenFilter = CIFilter(name: "CISharpenLuminance")!
//        sharpenFilter.setValue(coreImage, forKey: "inputImage")
//        sharpenFilter.setValue(1.0, forKey: "inputSharpness")
//        let sharpenedImage = sharpenFilter.value(forKeyPath: "outputImage") as! CIImage
//        let sharpenedImageRef = ciContext.createCGImage(sharpenedImage, from: sharpenedImage.extent)

        let blurFilter = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(coreImage, forKey: "inputImage")
        blurFilter.setValue(10, forKey: "inputRadius")
        let blurImage = blurFilter.value(forKeyPath: "outputImage") as! CIImage
//        let blurImageRef = ciContext.createCGImage(blurImage, from: blurImage.extent)
        
        let thresholdFilter = ThresholdFilter()
//        thresholdFilter.setValue(blurImage, forKey: "inputImage")
        thresholdFilter.inputImage = coreImage
        thresholdFilter.threshold = 0.24
//        let thresholdImage = thresholdFilter.value(forKeyPath: "outputImage") as! CIImage
        let thresholdImage = thresholdFilter.outputImage!
        let thresholdImageRef = ciContext.createCGImage(thresholdImage, from: thresholdImage.extent)
        
        // trying to invert after thresholdImageRef is created
        let invertFilter = CIFilter(name: "CIColorInvert")!
        invertFilter.setValue(thresholdImageRef, forKey: "inputImage")
        let invertedImage = invertFilter.value(forKeyPath: "outputImage") as! CIImage
        let invertedImageRef = ciContext.createCGImage(invertedImage, from: invertedImage.extent)
        
        return UIImage(cgImage: invertedImageRef!, scale: self.scale, orientation: self.imageOrientation)
    }
    
    func rad(_ degree: Double) -> CGFloat {
        return CGFloat(degree / 180.0 * .pi)
    }
    
    func crop(toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage? {
        var rectTransform: CGAffineTransform
        switch imageOrientation {
        case .left:
            rectTransform = CGAffineTransform(rotationAngle: rad(90)).translatedBy(x: 0, y: -self.size.height)
        case .right:
            rectTransform = CGAffineTransform(rotationAngle: rad(-90)).translatedBy(x: -self.size.width, y: 0)
        case .down:
            rectTransform = CGAffineTransform(rotationAngle: rad(-180)).translatedBy(x: -self.size.width, y: -self.size.height)
        default:
            rectTransform = .identity
        }
        rectTransform = rectTransform.scaledBy(x: self.scale, y: self.scale)
        
        let imageViewScale = max(self.size.width / viewWidth,
                                 self.size.height / viewHeight)
        
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
                              y:cropRect.origin.y * imageViewScale,
                              width:cropRect.size.width * imageViewScale,
                              height:cropRect.size.height * imageViewScale)
        
        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = self.cgImage?.cropping(to: cropZone.applying(rectTransform))
            else {
                return nil
        }
        
        // Return image to UIImage
        let croppedImage:UIImage = UIImage(cgImage: cutImageRef, scale: self.scale, orientation: self.imageOrientation)
        return croppedImage
    }
}

