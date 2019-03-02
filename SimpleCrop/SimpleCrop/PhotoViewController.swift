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
        addConstraints()
    }
    
    func addConstraints() {
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.photoView, sides: [.left, .top, .right], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.photoView, heightRatio: 0.8))
    }
    
}
