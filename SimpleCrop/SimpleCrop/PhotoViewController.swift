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
    let photoContainer = SimpleScrollView(height: 0.84)
    let takePhotoButton = SimpleButton(text: "Take Photo", font: UIFont.systemFont(ofSize: 30))
    
    init() {
        self.photoView = SimpleImageView(image: UIImage(named: "test"))

        super.init(nibName: nil, bundle: nil)
    }
    
    init(photo: UIImage) {
        let inverted_photo = photo.invertColors()
        
        self.photoView = SimpleImageView(image: inverted_photo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoContainer.delegate = self
        
        self.takePhotoButton.addTarget(self, action: #selector(PhotoViewController.takeAnotherPhoto), for: .touchUpInside)
        
        self.photoContainer.addSubview(self.photoView)
        self.view.addSubview(self.photoContainer)
        self.view.addSubview(self.takePhotoButton)
        
        self.photoContainer.accessibilityLabel = "DO YOU WANT TO ZOOM IN THE IMAGE?"
        self.photoContainer.accessibilityHint = "Drag two fingers apart to zoom in on various parts of the image."
        
        self.takePhotoButton.accessibilityLabel = "TAKE ANOTHER PHOTO"
        self.takePhotoButton.accessibilityHint = "TAP HERE"
        addConstraints()
    }
    
    func addConstraints() {
        self.photoContainer.addConstraints(SConstraint.paddingPositionConstraints(view: self.photoView, sides: [.left, .top, .right, .bottom], padding: 0))
        
        self.photoContainer.addConstraint(SConstraint.fillXConstraints(view: self.photoView, widthRatio: 1.0))
        self.photoContainer.addConstraint(SConstraint.fillYConstraints(view: self.photoView, heightRatio: 1.0))
        
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.takePhotoButton, sides: [.left, .bottom, .right], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.takePhotoButton, heightRatio: 0.16))
    }
    
    @objc func takeAnotherPhoto() {
        // rejectPhoto behaves differently depending on whether there's an active crop selection
        self.dismiss(animated: true, completion: nil)
        // remove the active crop here
    }
    
}

extension PhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoView
    }
    
}
