//
//  ThresholdFilter.swift
//  SimpleContrast
//
//  Created by Jing Lin on 3/2/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//

import UIKit

class ThresholdFilter: CIFilter {
    var inputImage:CIImage?
    var threshold:Float = 0.554688 // This is set to a good value via Otsu's method
    
    var thresholdKernel =  CIColorKernel(source:
        "kernel vec4 thresholdKernel(sampler image, float threshold) {" +
            "  vec4 pixel = sample(image, samplerCoord(image));" +
            "  const vec3 rgbToIntensity = vec3(0.114, 0.587, 0.299);" +
            "  float intensity = dot(pixel.rgb, rgbToIntensity);" +
            "  return intensity < threshold ? vec4(0, 0, 0, 1) : vec4(1, 1, 1, 1);" +
        "}")
    
    override var outputImage: CIImage! {
        guard let inputImage = inputImage,
            let thresholdKernel = thresholdKernel else {
                return nil
        }
        
        let extent = inputImage.extent
        let arguments:[Any] = [inputImage, threshold]
        return thresholdKernel.apply(extent: extent, arguments: arguments)
    }
}
