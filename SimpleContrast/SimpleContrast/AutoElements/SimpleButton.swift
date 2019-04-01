//
//  SimpleButton.swift
//  SimpleContrast
//
//  Created by Jing Lin on 3/2/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//

import UIKit

class SimpleButton: UIButton {
    
    enum Action {
        case Accept
        case Reject
    }
    
    init(text: String, font: UIFont, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setTitle(text, for: .normal)
        self.titleLabel!.font = font
        
        self.setTitleColor(Cons.primaryColor, for: .normal)
        self.backgroundColor = backgroundColor
    }
    
    convenience init(text: String) {
        let font = UIFont.systemFont(ofSize: 40, weight: .regular)
        self.init(text: text, font: font, backgroundColor: Cons.primaryBackground)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
