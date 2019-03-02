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
    
    var activeCrop = false
    let cropView = SimpleView()
    var touchStartPoint = CGPoint(x: 0, y: 0)
    var touchEndPoint = CGPoint(x: 0, y: 0)
    var cropRect = CGRect.zero
    
    init(photo: UIImage) {
        let inverted_photo = photo.invertColors()
        
        self.photoView = SimpleImageView(image: inverted_photo)
        super.init(nibName: nil, bundle: nil)

        let touchRecognizer = UIPanGestureRecognizer(target: self, action: #selector(PhotoViewController.cropImage))
        self.photoView.isUserInteractionEnabled = true
        self.photoView.addGestureRecognizer(touchRecognizer)
    }
        
    @objc func cropImage(_ sender:UIPanGestureRecognizer) {
        let position = sender.location(in: self.photoView)
        
        if sender.state == .began {
            self.touchStartPoint = position
            self.cropView.show()
        } else if sender.state == .changed {
            self.touchEndPoint = position
            moveCropView()
        } else if sender.state == .ended {
            self.activeCrop = true
            moveCropView()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rejectButton.addTarget(self, action: #selector(PhotoViewController.rejectPhoto), for: .touchUpInside)
        self.acceptButton.addTarget(self, action: #selector(PhotoViewController.acceptPhoto), for: .touchUpInside)
        
        self.view.addSubview(self.photoView)
        self.view.addSubview(self.acceptButton)
        self.view.addSubview(self.rejectButton)
        self.view.addSubview(self.cropView)
        addConstraints()
    }
    
    func addConstraints() {
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.photoView, sides: [.left, .top, .right], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.photoView, heightRatio: 0.84))
        
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.rejectButton, sides: [.left, .bottom], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.rejectButton, heightRatio: 0.16))
        self.view.addConstraint(SConstraint.fillXConstraints(view: self.rejectButton, widthRatio: 0.5))
        
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.acceptButton, sides: [.right, .bottom], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.acceptButton, heightRatio: 0.16))
        self.view.addConstraint(SConstraint.fillXConstraints(view: self.acceptButton, widthRatio: 0.5))
    }
    
    @objc func rejectPhoto() {
        // rejectPhoto behaves differently depending on whether there's an active crop selection
        if (!self.activeCrop) { // dismiss the PhotoViewController is there is no active crop
            self.dismiss(animated: true, completion: nil)
        }
        // remove the active crop here
        self.activeCrop = false
        self.cropView.hide()
        self.cropView.bounds = .zero
    }
    
    @objc func acceptPhoto() {
        // acceptPhoto only crops the photo and saves it if there is an active crop.
        if (!self.activeCrop) {
            return
        }

        guard let croppedImage = self.photoView.image!.crop(toRect: self.cropView.frame, viewWidth: self.photoView.bounds.width, viewHeight: self.photoView.bounds.height) else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(croppedImage, self, #selector(PhotoViewController.finishedSavingImage), nil)
    }
    
    func otherCrop(_ image: UIImage, cropRect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, image.scale)
        image.draw(at: CGPoint(x: -cropRect.origin.x, y: -cropRect.origin.y))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        return croppedImage!
    }
    
    func rad(_ degree: Double) -> CGFloat {
        return CGFloat(degree / 180.0 * .pi)
    }
    
    @objc func finishedSavingImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Saved your photo.", message: "SimpleCrop saved your photo to the albums", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay.", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }

    func moveCropView() {
        let width = abs(self.touchEndPoint.x - self.touchStartPoint.x)
        let height = abs(self.touchEndPoint.y - self.touchStartPoint.y)
        
        let min_x = min(self.touchStartPoint.x, self.touchEndPoint.x)
        let min_y = min(self.touchStartPoint.y, self.touchStartPoint.y)
        
        self.cropView.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let y_down:CGFloat = self.touchStartPoint.y > self.touchEndPoint.y ? -1.0 : 1.0
        
        self.cropView.center = CGPoint(x: min_x + width / 2, y: min_y + y_down * height / 2)
    }
    
}
