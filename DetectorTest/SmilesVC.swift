//
//  SmilesVC.swift
//  DetectorTest
//
//  Created by Admin on 03.02.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit
import AVFoundation

class SmilesVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var lightStatus: UILabel!
    @IBOutlet weak var backBttn: UIButton!
    @IBOutlet weak var torchButton: UIButton!
    @IBOutlet weak var timerTF: UILabel!
    @IBOutlet weak var switcherTF: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    @IBOutlet weak var picker: UIPickerView!
    let pickerNumbers = [Int](1...60)
    
    var nowLighting:Bool = false
    var needShutDown:Bool = false
    var _delay:Int = 5
    var delay:Int = 0
    var countDownTimer:Timer!
    
    

    
    

    var LANG:Int = 0
    let dict = Dictionary().dict
    
    let userDefaults = UserDefaults.standard

    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        delay = _delay
        title = dict[1]![LANG]
        switcherTF.text = "Выключать свет через \(delay) c."
        timerTF.text = ""
        
        //        print("nowLighting = \(nowLighting)") // в первый раз будет false
        nowLighting = userDefaults.bool(forKey: "light")
        needShutDown = userDefaults.bool(forKey: "needShutDown")
        
        switcher.isOn = needShutDown
        picker.isUserInteractionEnabled = needShutDown
        
        picker.selectRow(delay - 1, inComponent: 0, animated: true)
        if !needShutDown{
            picker.isUserInteractionEnabled = false
            picker.alpha = 0.5
        }

        setState(nowLighting)
        
    }
    

    
    
    //************** П И К Е Р *************************************
    // кол-во разрядов пикервью
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // показыает содержание массива в компоненте (если не указать, то вместо цифр будут знаки ?)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerNumbers[row])
    }
    // количество элементов из массива, которые необходимо отображать в пикере
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerNumbers.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switcherTF.text = "Выключить свет через \(pickerNumbers[row]) с."
        delay = pickerNumbers[row]
        _delay = delay
    }
    
    


    @IBAction func onTorchClick(_ sender: Any) {
        
        nowLighting = !nowLighting
        
        if countDownTimer != nil {
            countDownTimer.invalidate()
            countDownTimer = nil
            timerTF.text = ""
            delay = _delay
        }
        
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
        
    
    
    
    
    
    
    func timerFunc(){

        delay -= 1
        
        switch delay {
        case 0...9:
            timerTF.text = "0" + String(delay)
            if delay == 0 {
                onTorchClick(self)
            }
        case -1:
            countDownTimer.invalidate()
            countDownTimer = nil
            timerTF.text = ""
            delay = _delay
        default:
            timerTF.text = String(delay)
        }
        print("Тик-так \(delay)")

    }
        
    
    
    
    
    
    
    
    
    
    /// Установка состояний кнопки и фонарика
    ///
    /// - Parameter state: <#state description#>
    func setState (_ state:Bool) -> Void{
        
        if (state){
            torchButton.setImage(UIImage(named: "torchBttn_on"), for: .normal)
            lightStatus.text = dict[13]![LANG]
            switcher.isEnabled = false
            if needShutDown {
                countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
                timerTF.text = (delay < 10) ? "0" + String(delay) : String(delay)
                UIApplication.shared.isIdleTimerDisabled = true
                
                picker.isUserInteractionEnabled = false
                picker.alpha = 0.5
            }
        }
        else {
            torchButton.setImage(UIImage(named: "torchBttn_off"), for: .normal)
            lightStatus.text = dict[14]![LANG]
            switcher.isEnabled = true
            UIApplication.shared.isIdleTimerDisabled = false
            
            picker.isUserInteractionEnabled = true
            picker.alpha = 1
        }
        userDefaults.set(state, forKey: "light")
        userDefaults.synchronize()
    }
        
    
    
    
    // выполнение ф-ции через определенное время
//    func setTimeOut(_ delay:Int, closure: @escaping() -> ()){ // @escaping - кложур не замкнут
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
//            closure()
//            print("Выполняется кложур")
//        }
//    }

    
    
    
    @IBAction func onSwitchMode(_ sender: UISwitch) {
        needShutDown = !needShutDown
        userDefaults.set(needShutDown, forKey: "needShutDown")
        userDefaults.synchronize()
        
        if needShutDown{
            picker.isUserInteractionEnabled = true
            picker.alpha = 1
        }
        else {
            picker.isUserInteractionEnabled = false
            picker.alpha = 0.5
        }
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if nowLighting{
            onTorchClick(self)
        }
        timerTF.text = ""
        delay = _delay
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    


    

}


















































