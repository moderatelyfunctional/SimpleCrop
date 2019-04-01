//
//  PhotoViewController.swift
//  SimpleContrast
//
//  Created by Jing Lin on 3/2/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    let slider = SimpleSlider()
    let zoomSlider = SimpleZoomSlider()
    
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
        let thresholdPhoto = self.photo.thresholdColors(threshold: Cons.thresholdStart)
        
        self.photoView = SimpleImageView(image: thresholdPhoto)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoContainer.delegate = self
        
        self.slider.addTarget(self, action: #selector(PhotoViewController.adjustPhotoThreshold), for: .valueChanged)
        self.zoomSlider.addTarget(self, action: #selector(PhotoViewController.adjustZoomLevel), for: .valueChanged)
        self.takePhotoButton.addTarget(self, action: #selector(PhotoViewController.takeAnotherPhoto), for: .touchUpInside)
        
        self.photoContainer.addSubview(self.photoView)
        self.view.addSubview(self.photoContainer)
        self.view.addSubview(self.slider)
        self.view.addSubview(self.zoomSlider)
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
        self.view.addConstraint(SConstraint.verticalSpacingConstraint(upperView: self.slider, lowerView: self.takePhotoButton, spacing: 10))
        
        self.view.addConstraint(SConstraint.equalConstraint(firstView: self.photoContainer, secondView: self.zoomSlider, attribute: .centerY))
        self.view.addConstraint(NSLayoutConstraint(item: self.zoomSlider, attribute: .centerX, relatedBy: .equal, toItem: self.photoContainer, attribute: .centerX, multiplier: 2.0, constant: -25))
        self.view.addConstraint(NSLayoutConstraint(item: self.zoomSlider, attribute: .width, relatedBy: .equal, toItem: self.photoContainer, attribute: .height, multiplier: 1.0, constant: -140))
        
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
            let updatedPhoto = self.photo.thresholdColors(threshold: self.currentThreshold)
            self.photoView.image = updatedPhoto
            self.updateThreshold = false
        }
    }
    
    @objc func adjustZoomLevel(sender: UISlider) {
        let zoomLevel = CGFloat(sender.value)
        self.photoContainer.setZoomScale(zoomLevel, animated: true)
    }
    
}

extension PhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoView
    }
    
}
