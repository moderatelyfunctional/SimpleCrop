//
//  PhotoViewController.swift
//  SimpleCrop
//
//  Created by Jing Lin on 3/2/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    let slider = SimpleSlider()
    
    let photo:UIImage
    let photoView:SimpleImageView
    let photoContainer = SimpleScrollView(height: 0.84)
    let takePhotoButton = SimpleButton(text: "Take Photo")
    
    var updateThreshold:Bool = false
    var currentThreshold:Float = 0
    
    init() {
        self.photo = UIImage(named: "test")!
        self.photoView = SimpleImageView(image: self.photo)

        super.init(nibName: nil, bundle: nil)
    }
    
    init(photo: UIImage) {
        self.photo = photo
        let inverted_photo = self.photo.invertColors(threshold: Cons.thresholdStart)
        
        self.photoView = SimpleImageView(image: inverted_photo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoContainer.delegate = self
        
        self.slider.addTarget(self, action: #selector(PhotoViewController.adjustPhotoThreshold), for: .valueChanged)
        self.takePhotoButton.addTarget(self, action: #selector(PhotoViewController.takeAnotherPhoto), for: .touchUpInside)
        
        self.photoContainer.addSubview(self.photoView)
        self.view.addSubview(self.photoContainer)
        self.view.addSubview(self.slider)
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
        
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.slider, sides: [.left, .right], padding: 20))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.slider, heightRatio: 0.1))
        self.view.addConstraint(SConstraint.verticalSpacingConstraint(upperView: self.slider, lowerView: self.takePhotoButton, spacing: 20))
        
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.takePhotoButton, sides: [.left, .bottom, .right], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.takePhotoButton, heightRatio: 0.16))
    }
    
    @objc func takeAnotherPhoto() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func adjustPhotoThreshold(sender: UISlider) {
        self.currentThreshold = sender.value
        if self.updateThreshold {
            return
        }
        self.updateThreshold = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let updated_photo = self.photo.invertColors(threshold: self.currentThreshold)
            self.photoView.image = updated_photo
            self.updateThreshold = false
        }
    }
    
}

extension PhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoView
    }
    
}
