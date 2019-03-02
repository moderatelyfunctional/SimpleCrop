//
//  PhotoViewController.swift
//  SimpleCrop
//
//  Created by Jing Lin on 3/2/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    let photoView:SimpleImageView
    let acceptButton = SimpleButton(action: .Accept)
    let rejectButton = SimpleButton(action: .Reject)
    
    init(photo: UIImage) {
        self.photoView = SimpleImageView(image: photo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.photoView)
        self.view.addSubview(self.acceptButton)
        self.view.addSubview(self.rejectButton)
        addConstraints()
    }
    
    func addConstraints() {
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.photoView, sides: [.left, .top, .right], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.photoView, heightRatio: 0.8))
        
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.rejectButton, sides: [.left, .bottom], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.rejectButton, heightRatio: 0.2))
        self.view.addConstraint(SConstraint.fillXConstraints(view: self.rejectButton, widthRatio: 0.5))
        
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.acceptButton, sides: [.right, .bottom], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.rejectButton, heightRatio: 0.2))
        self.view.addConstraint(SConstraint.fillXConstraints(view: self.rejectButton, widthRatio: 0.5))
    }
    
}
