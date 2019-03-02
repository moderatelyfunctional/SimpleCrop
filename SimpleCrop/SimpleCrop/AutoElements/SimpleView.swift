//
//  SimpleView.swift
//  SimpleCrop
//
//  Created by Jing Lin on 3/2/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//

import UIKit

class SimpleView: UIView {
    
    init() {
        super.init(frame: .zero)

        self.backgroundColor = Cons.cropColor
        
        self.hide()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }
    
}
