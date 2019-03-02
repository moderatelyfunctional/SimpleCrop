//
//  SimpleView.swift
//  SimpleCrop
//
//  Created by Jing Lin on 3/2/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//

import UIKit

class SimpleView: UIButton {
    
    let lighterColor = Cons.primaryBackground.lighter(by: 15)
    let darkerColor = Cons.primaryBackground
    
    init(text: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setTitle(text, for: .normal)
        self.titleLabel!.font = UIFont.systemFont(ofSize: 48, weight: .regular)
        
        self.setTitleColor(Cons.primaryColor, for: .normal)
        self.backgroundColor = self.lighterColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? self.darkerColor : self.lighterColor
        }
    }
    
}
