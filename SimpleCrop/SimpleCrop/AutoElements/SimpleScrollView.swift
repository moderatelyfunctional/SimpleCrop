//
//  SimpleScrollView.swift
//  SimpleCrop
//
//  Created by Jing Lin on 3/2/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//

import UIKit

class SimpleScrollView: UIScrollView {

    init(height: CGFloat) {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: Cons.screen_bounds.width,
                           height: Cons.screen_bounds.height * 0.84)
        super.init(frame: frame)
        
        self.alwaysBounceVertical = false
        self.alwaysBounceHorizontal = false
        
        self.contentInset = .zero
        
        self.zoomScale = 1.0
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 10.0
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
