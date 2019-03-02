//
//  CropViewController.swift
//  SimpleCrop
//
//  Created by Jing Lin on 3/1/19.
//  Copyright © 2019 Jing Lin. All rights reserved.
//

import UIKit
import AVFoundation

class CropViewController: UIViewController {

    let previewView = PreviewView()
    let photoButton = SimpleButton(text: "Take Photo")
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.photoButton.addTarget(self, action: #selector(CropViewController.takePhoto), for: .touchUpInside)
        self.view.accessibilityLabel = "SIMPLE CROP"
        
        self.view.addSubview(self.previewView)
        self.previewView.accessibilityLabel = "CAMERA FEED"
        
        self.view.addSubview(self.photoButton)
        self.photoButton.accessibilityLabel = "TAKE A PHOTO"
        addConstraints()
        
        checkAuthorizationStatus()
    }
    
    func addConstraints() {
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.previewView, sides: [.top, .left, .right], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.previewView, heightRatio: 0.84))
        
        self.view.addConstraints(SConstraint.paddingPositionConstraints(view: self.photoButton, sides: [.bottom, .left, .right], padding: 0))
        self.view.addConstraint(SConstraint.fillYConstraints(view: self.photoButton, heightRatio: 0.16))
    }
    
    func checkAuthorizationStatus() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized: // The user previously granted access to the camera
            self.setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if (granted) {
                    self.setupCaptureSession()
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
    
    @objc func takePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .on
        
        self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
}

extension CropViewController: AVCapturePhotoCaptureDelegate {
    
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
