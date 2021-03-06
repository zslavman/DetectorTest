//
//  Flashlight.swift
//  DetectorTest
//
//  Created by Admin on 03.02.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit
import AVFoundation

class Flashlight: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var backBttn: UIButton!
    @IBOutlet weak var torchButton: UIButton!
    @IBOutlet weak var lightStatus: UILabel!
    @IBOutlet weak var timerTF: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var shine: UIImageView!
    public var progress:ProgressBar!                // кастомный прогрессбар
    
    let pickerNumbers = [Int](1...60)
    
    var nowLighting:Bool = false
    var needShutDown:Bool = false
    var _delay:Int = 10
    var delay:Int = 0
    var countDownTimer:Timer!
    
    public let START:String = "start"
    public let STOP:String = "stop"
    

    var LANG:Int = 0
    let dict = Dictionary().dict
    
    let userDefaults = UserDefaults.standard
    
    
    
    /* =================================*/
    /* ========== П И К Е Р ============*/
    /* =================================*/
    public var pickerState:Bool {
        get { return false }
        set {
            if newValue{
                picker.isUserInteractionEnabled = true
                picker.alpha = 1
            }
            else{
                picker.isUserInteractionEnabled = false
                picker.alpha = 0.3
            }
        }
    }
    
    /* =================================*/
    /* ========== ВКЛ/ВЫКЛ таймер ======*/
    /* =================================*/
    private var _timerState:String = "stop"
    public var timerState:String {
        get {
            return _timerState
        }
        set {
            _timerState = newValue
            if newValue == START{
                countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
                progress.startAnimate(_delay)
                UIApplication.shared.isIdleTimerDisabled = true
                progress.isHidden = false
            }
            else if newValue == STOP{
                countDownTimer.invalidate()
                progress.stopAnimation()
                countDownTimer = nil
                delay = _delay
                timerTF.text = String(delay)
                UIApplication.shared.isIdleTimerDisabled = false
                progress.isHidden = true
            }
        }
    }

    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        delay = _delay
        title = dict[1]![LANG]
        timerTF.text = String(delay)
        
        // кастомный прогрессбар
        progress = ProgressBar()
        //        progress.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progress)
        progress.frame.origin = CGPoint(x: shine.frame.origin.x + (shine.frame.size.width - CGFloat(progress.thisWidth))/2, y: shine.frame.origin.y + shine.frame.size.height + 10)
        //        print("размеры прогрессбара = \(progress.sizeToFit())")
        //        print("размеры прогрессбара = \(progress.frame.size)")
        
        
        
        //        print("nowLighting = \(nowLighting)") // в первый раз будет false
        nowLighting = userDefaults.bool(forKey: "light")
        needShutDown = userDefaults.bool(forKey: "needShutDown")
        
        switcher.isOn = needShutDown
        pickerState = needShutDown
        
        picker.selectRow(delay - 1, inComponent: 0, animated: true)

        torchState = nowLighting // для установки вида кнопки, т.к. изначально это включенная кнопка
        progress.isHidden = true
        
       
    }
    
  
    
    
    
    
    
    let loopingMargin: Int = 40
    
    /* =======================================================*/
    /* ========== Н А С Т Р О Й К И   П И К Е Р А ============*/
    /* =======================================================*/
    // кол-во разрядов пикервью
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // показыает элементы массива в компоненте (если не указать, то вместо цифр будут знаки ?)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerNumbers[row % pickerNumbers.count])
    }
    // количество элементов из массива, которые необходимо отображать в пикере
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return loopingMargin * pickerNumbers.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentIndex = row % pickerNumbers.count
        picker.selectRow((loopingMargin / 2) * pickerNumbers.count + currentIndex, inComponent: 0, animated: false)

        timerTF.text = String(pickerNumbers[currentIndex])
        delay = pickerNumbers[currentIndex]
        _delay = delay
        
    }
    
    

    
    
    /* =======================================================*/
    /* ========== В К Л Ю Ч Е Н И Е   Ф О Н А Р И К А ========*/
    /* =======================================================*/
    @IBAction func onTorchClick(_ sender: Any) {
        
        nowLighting = !nowLighting
        
        if countDownTimer != nil {
            timerState = STOP
        }
        
        torchState = nowLighting
        
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
        
    
   
    /* =======================================================*/
    /* ======== Установка состояний кнопки и фонарика ========*/
    /* =======================================================*/
    public var torchState:Bool{
        
        get { return false }
        set {
            // ВКЛ
            if (newValue){
                torchButton.setImage(UIImage(named: "torchBttn_on"), for: .normal)
                lightStatus.text = dict[13]![LANG]
                
                switcher.isEnabled = false
                
                if needShutDown {
                    timerState = START
                }
                pickerState = false
                shine.alpha = 1
            }
            // ВЫКЛ
            else {
                torchButton.setImage(UIImage(named: "torchBttn_off"), for: .normal)
                lightStatus.text = dict[14]![LANG]
                
                switcher.isEnabled = true
                
                UIApplication.shared.isIdleTimerDisabled = false
                pickerState = true
                
                if countDownTimer != nil{
                    timerState = STOP
                }
                shine.alpha = 0.1
//                progress.setProgress = 1
            }
            userDefaults.set(newValue, forKey: "light")
            userDefaults.synchronize()
        }
    }
        
    
    

    
    /* =============================*/
    /* ======== С В И Т Ч Е Р ======*/
    /* =============================*/
    @IBAction func onSwitchMode(_ sender: UISwitch) {
        needShutDown = !needShutDown
        
        userDefaults.set(needShutDown, forKey: "needShutDown")
        userDefaults.synchronize()
        
        pickerState = needShutDown
    }
    
    
    
    
    
    
    
    
    
    /* =============================*/
    /* ======== Т А Й М Е Р ========*/
    /* =============================*/
    func timerFunc(){
        
        delay -= 1
        
        print(delay)
        
        //прогресс бар
        // let progressCount = Float(delay)/Float(_delay)
        // progressBar.setProgress(Float(progressCount), animated: true)
        
        switch delay {
        // case 0...9:
        // timerTF.text = String(delay)
        case 0:
            onTorchClick(self)
        default:
            timerTF.text = String(delay)
        }
    }
    
    
    
    
    
    /* =============================*/
    /* ======== Д И С П О З ========*/
    /* =============================*/
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if nowLighting{
            onTorchClick(self)
        }
    }

    
    
    
    
    
    
    // выполнение ф-ции через определенное время
    //    func setTimeOut(_ delay:Int, closure: @escaping() -> ()){ // @escaping - кложур не замкнут
    //        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
    //            closure()
    //            print("Выполняется кложур")
    //        }
    //    }


    

}


















































