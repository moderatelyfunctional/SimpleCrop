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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.green
        
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
        
    }


}

