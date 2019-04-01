//
//  SimpleZoomSlider.swift
//  SimpleContrast
//
//  Created by Jing Lin on 3/31/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//

import UIKit

class SimpleZoomSlider: UISlider {
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.minimumValue = 1.0
        self.maximumValue = 10.0
        
        self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
