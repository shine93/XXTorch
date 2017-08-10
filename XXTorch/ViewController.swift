//
//  ViewController.swift
//  XXTorch
//
//  Created by xhkj on 2017/8/9.
//  Copyright © 2017年 wmx. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var lightLevel:Float = 0.5
    static var i = 0
    
    @IBOutlet weak var torchBtn: UIButton!
    
    var flashTimer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func actionTorch(_ sender: UIButton) {
        print("torch click")
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            openTorch(lightLevel: lightLevel)
        }else {
            closeTorch()
        }
        
    }
    
    @IBAction func actionChageLight(_ sender: UISlider) {
        lightLevel = sender.value
        
        torchBtn.isSelected = true
        openTorch(lightLevel: lightLevel)
    }

    @IBAction func actionFlash(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            //flash
            torchBtn.isSelected = true
            flashTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.flashTorch), userInfo:nil, repeats: true)
        }else {
            //end flash
            flashTimer.invalidate()
            torchBtn.isSelected = false
            closeTorch()
            
            ViewController.i = 0
            
            
        }
        
    }
    
    @IBAction func actionSOS(_ sender: UIButton) {
    }
}

//MARK: - methods
extension ViewController {
    func openTorch(lightLevel: Float) -> Void {
        
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            print("no AVCaptureDevice")
            return
        }
        
        guard ((try? device.lockForConfiguration()) != nil) else {
            print("deviece.lockForConfiguration error")
            return
        }
        if device.hasTorch {
            guard ((try? device.setTorchModeOnWithLevel(lightLevel)) != nil) else {
                print("device.setTorchModeOnWithLevel(lightLevel)")
                return
            }
        }
        device.unlockForConfiguration()
    }
    
    
    func closeTorch() -> Void {
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            print("no device")
            return
        }
        
        guard ((try? device.lockForConfiguration()) != nil) else {
            print("deviece.lockForConfiguration error")
            return
        }
        
        if device.hasTorch {
            device.torchMode = .off
        }
        device.unlockForConfiguration()
        
    }
    
    func flashTorch() -> Void {
    
        ViewController.i += 1;
        print(ViewController.i)
        
        if ViewController.i%2 == 1 {
            openTorch(lightLevel: lightLevel)
        }else {
            closeTorch()
        }
    }
    
}
