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
        let yes = "ACCEPT"
        let no = "REJECT"
        
        if action == .Accept {
            //self.setImage(UIImage(named: "check"), for: .normal)
            
            self.setTitle(yes, for: .normal)
            self.titleLabel!.font = UIFont.systemFont(ofSize: 30, weight: .regular)
            self.setTitleColor(Cons.primaryColor, for: .normal)
            
            self.backgroundColor = UIColor.green
        } else {
            //self.setImage(UIImage(named: "cross"), for: .normal)
            
            self.setTitle(no, for: .normal)
            self.titleLabel!.font = UIFont.systemFont(ofSize: 30, weight: .regular)
            self.setTitleColor(Cons.primaryBackground, for: .normal)
            
            self.backgroundColor = UIColor.red
        }
        self.imageView?.contentMode = .scaleAspectFit
        self.imageEdgeInsets = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
