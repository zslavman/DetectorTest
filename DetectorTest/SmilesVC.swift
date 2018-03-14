//
//  SmilesVC.swift
//  DetectorTest
//
//  Created by Admin on 03.02.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit
import AVFoundation

class SmilesVC: UIViewController {
    
    
    @IBOutlet weak var lightStatus: UILabel!
    @IBOutlet weak var backBttn: UIButton!
    @IBOutlet weak var torchButton: UIButton!
    var nowLighting:Bool = false
    

    var LANG:Int = 0
    let dict = Dictionary().dict
    
    let userDefaults = UserDefaults.standard

    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = dict[1]![LANG]
        
        nowLighting = userDefaults.bool(forKey: "light")
//        print("nowLighting = \(nowLighting)") // в первый раз будет false
        setState(nowLighting)

    }


    @IBAction func onTorchClick(_ sender: UIButton) {
        
        nowLighting = !nowLighting
        
        setState(nowLighting)
        
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo){
            
            if (device.hasTorch){
                do {
                    try device.lockForConfiguration() // для получения эксклюзивного доступа к устройству
                    device.torchMode = (device.torchMode == AVCaptureTorchMode.on) ? .off : .on
                    device.unlockForConfiguration()
                }
                catch {
                    print(error)
                }
            }
        }
        
        
    }
    
    
    
    
    /// Установка состояний кнопки и фонарика
    ///
    /// - Parameter state: <#state description#>
    func setState (_ state:Bool) -> Void{
        
        if (state){
            torchButton.setImage(UIImage(named: "torchBttn_on"), for: .normal)
            lightStatus.text = dict[13]![LANG]
        }
        else {
            torchButton.setImage(UIImage(named: "torchBttn_off"), for: .normal)
            lightStatus.text = dict[14]![LANG]
        }
        userDefaults.set(state, forKey: "light")
        userDefaults.synchronize()
        
    }
    


    

}














