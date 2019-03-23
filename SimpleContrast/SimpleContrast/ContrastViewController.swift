//
//  ContrastViewController.swift
//  SimpleContrast
//
//  Created by Jing Lin on 3/1/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//

import UIKit
import AVFoundation

class ContrastViewController: UIViewController {

    let previewView = PreviewView()
    let flashButton = SimpleButton(
        text: "Turn Flash OFF",
        font: UIFont.systemFont(ofSize: 24),
        backgroundColor: Cons.secondaryBackground)
    let photoButton = SimpleButton(text: "Take Photo")
    
    var useFlash:Bool = true
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.flashButton.addTarget(self, action: #selector(ContrastViewController.toggleFlash), for: .touchUpInside)
        self.photoButton.addTarget(self, action: #selector(ContrastViewController.takePhoto), for: .touchUpInside)
        
        self.view.accessibilityLabel = "SIMPLE CONTRAST"
        
        self.view.addSubview(self.previewView)
        self.view.addSubview(self.flashButton)
        self.view.addSubview(self.photoButton)
        
        self.previewView.accessibilityLabel = "CAMERA FEED"
        self.flashButton.accessibilityLabel = "TOGGLE FLASH"
        self.photoButton.accessibilityLabel = "TAKE A PHOTO"
        addConstraints()
        
        checkAuthorizationStatus()
    }
    
    func addConstraints() {
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.previewView, sides: [.top, .left, .right], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.previewView, heightRatio: 0.84))
        
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.flashButton, sides: [.left, .right], padding: 0))
        self.view.addConstraint(SConstraint.verticalSpacingConstraint(upperView: self.previewView, lowerView: self.flashButton, spacing: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.flashButton, heightRatio: 0.07))
        
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.photoButton, sides: [.bottom, .left, .right], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.photoButton, heightRatio: 0.09))
    }
    
    func checkAuthorizationStatus() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized: // The user previously granted access to the camera
            self.setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if (granted) {
                    DispatchQueue.main.async {
                        self.setupCaptureSession()
                    }
                }
            }
        case .denied:
            return
        case .restricted:
            return
        }
    }
    
    func setupCaptureSession() {
        configureSession()
        configurePreview()
        runSession()
    }
    
    func configureSession() {
        self.captureSession.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            self.captureSession.canAddInput(videoDeviceInput)
            else { return }
        
        self.captureSession.addInput(videoDeviceInput)
        
        guard captureSession.canAddOutput(self.photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(self.photoOutput)
        self.photoOutput.isHighResolutionCaptureEnabled = true
        
        self.captureSession.commitConfiguration()
    }
    
    func configurePreview() {
        self.previewView.videoPreviewLayer.session = self.captureSession
        self.previewView.videoPreviewLayer.videoGravity = .resizeAspectFill
    }
    
    func runSession() {
        DispatchQueue.main.async {
            self.captureSession.startRunning()
        }
    }
    
    @objc func toggleFlash() {
        self.useFlash = !self.useFlash
        let flashText = self.useFlash ? "Turn Flash OFF" : "Turn Flash ON"
        self.flashButton.setTitle(flashText, for: .normal)
    }
    
    @objc func takePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = self.useFlash ? .on : .off
        
        self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

}

extension ContrastViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let _ = error {
            return
        }
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        guard let currPhoto = UIImage(data: imageData) else {
            return
        }
        
        let photoViewController = PhotoViewController(photo: currPhoto)
        self.present(photoViewController, animated: true, completion: nil)
    }
    
}
