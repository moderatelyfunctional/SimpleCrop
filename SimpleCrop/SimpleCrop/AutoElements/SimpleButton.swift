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
    
    init(text: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setTitle(text, for: .normal)
        self.titleLabel!.font = UIFont.systemFont(ofSize: 48, weight: .regular)
        
        self.setTitleColor(Cons.primaryColor, for: .normal)
        self.backgroundColor = Cons.primaryBackground
    }
    
    init(action: Action) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        if action == .Accept {
            self.setImage(UIImage(named: "check"), for: .normal)
        } else {
            self.setImage(UIImage(named: "cross"), for: .normal)
        }
        self.imageView?.contentMode = .scaleAspectFit
        
        self.backgroundColor = Cons.primaryBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
