//
//  SimpleButton.swift
//  SimpleCrop
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
    
    init(text: String, font: UIFont) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setTitle(text, for: .normal)
        self.titleLabel!.font = UIFont.systemFont(ofSize: 48, weight: .regular)
        
        self.setTitleColor(Cons.primaryColor, for: .normal)
        self.backgroundColor = Cons.primaryBackground
    }
    
    convenience init(text: String) {
        let font = UIFont.systemFont(ofSize: 48, weight: .regular)
        self.init(text: text, font: font)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
