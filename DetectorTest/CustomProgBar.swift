//
//  CustomProgBar.swift
//  DetectorTest
//
//  Created by Viacheslav on 26.06.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit

class CustomProgBar: UIViewController {

    
    @IBOutlet weak var progress_backing:UIImageView!    // картинка-бэкграунд прогрессбара
    @IBOutlet weak var percents_TF:UILabel!{            // % загрузки, сеттер для устранения дергания шрифта из-за отсутствия моноширности цифр
        didSet {
            percents_TF.font = UIFont.monospacedDigitSystemFont(ofSize: percents_TF!.font!.pointSize, weight: UIFontWeightRegular)
        }
    }
    @IBOutlet weak var segmentedControl: UISegmentedControl! // элемент сегментконтрол
    @IBOutlet weak var descript_TF: UILabel!            // Скосрость загрузки 10 Мб
    @IBOutlet weak var startBttn: UIButton!             // кн. Старт (для изменения ее надписи)
    

    private var progress_filling:UIImageView!           // картинка заполнения бэкграунда прогрессбара
    private var shapeMask:CAShapeLayer!                 // маска
    private var maskWidth:CGFloat = 10                  // ширина прелоадера
    private var lineWidth:CGFloat = 10                  // толщина (жирность) линии, которая будет рисовать маску прогрессбара
    private var timer:Timer!
    private var path:UIBezierPath!
    
    // геттер/сеттер для шкалы прогресса
    public var progress:Float {
        get{
            return Float(shapeMask.strokeEnd)
        }
        set {
            if newValue == 0 {
                shapeMask.actions = ["strokeEnd" : NSNull()] // для мгновенного сброса шкалы (иначе она сбрасывается инерционно)
            }
            else {
               shapeMask.actions = nil
            }
            shapeMask.strokeEnd = CGFloat(newValue)
            percents_TF.text = "\(Int(newValue * 100)) %"
        }
    }
    private let segmentCases:[Int:Double] = [ // скорости таймера в зависимости от выбранной скороста на сегментконтроле
        0: 0.7,  // GPRS
        1: 0.15, // 3G
        2: 0.02  // LTE
    ]
    private var timerSpeed:Double = 1
    
    private var LANG:Int = MainVC.LANG
    private let dict = Dictionary().dict
    private var running:Bool = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerSpeed = segmentCases[segmentedControl.selectedSegmentIndex]!
        
        startBttn.setTitle(dict[16]![LANG], for: .normal) // Старт
        descript_TF.text = dict[19]![LANG]  // Скорость загрузки 10 Мб
        title = dict[20]![LANG]             // Кастом прогрессбар
        
        // создаем и размещаем картинку заполнения кодом
        progress_filling = UIImageView(image: UIImage(named: "progbar_filling"))
        progress_filling.contentMode = .scaleAspectFit
        progress_filling.bounds = progress_backing.bounds
        progress_filling.frame.origin = CGPoint(x: 0, y: 0)
        
        progress_backing.addSubview(progress_filling)
        
        // настройки кнопки Старт
        startBttn.layer.shadowOffset = CGSize(width: 2, height: 3)
        startBttn.layer.shadowRadius = 4
        startBttn.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        startBttn.layer.shadowOpacity = 0.6
        
        
        lineWidth = progress_backing.frame.height
        maskWidth = progress_backing.frame.width

        createAndApplyMask()
        
        progress = 0
    }
        
    
    
    
    // создание и наложение маски
    private func createAndApplyMask(){
        
        if shapeMask == nil {
            shapeMask = CAShapeLayer()
            
            shapeMask.lineWidth = CGFloat(lineWidth - 3)
            shapeMask.lineCap = "butt" // прямоугольные очертания
            shapeMask.fillColor = nil  // не делать автозаливку открытых path
            shapeMask.strokeStart = 0  // начальная точка отрисовку траэктории
            shapeMask.strokeEnd = 1    // последняя точка отрисовку траэктории (1 - 100% линии нарисовано)
            shapeMask.strokeColor = #colorLiteral(red: 0.2953388691, green: 0.8497148156, blue: 0.3902329504, alpha: 1).cgColor
            shapeMask.opacity = 0.7
            
            progress_backing.layer.addSublayer(shapeMask)
        }
        
        // рисование path маски
        shapeMask.frame = progress_backing.layer.bounds
        
        if path != nil {
            // path.removeAllPoints()
            // view.setNeedsDisplay()
            path = nil
        }
        
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: lineWidth/2))            // начальная точка прямой
        path.addLine(to: CGPoint(x: maskWidth, y: lineWidth/2)) // конечная точка прямой
        shapeMask.path = path.cgPath
        
        progress_filling.layer.mask = shapeMask
    }

    

    
    // при повороте экрана
    override func viewDidLayoutSubviews() {
        
        // пересчитываем заполняющую полосу и маску
        lineWidth = progress_backing.frame.height
        maskWidth = progress_backing.frame.width
        progress_filling.bounds = progress_backing.bounds
        
        createAndApplyMask()
        
        progress_filling.frame.origin = CGPoint(x: 0, y: 0)
    }
    
    
    
    
    // клик по сегментконтрол
    @IBAction func onSegmentedCtrlClick(_ sender: UISegmentedControl) {
        
        timerSpeed = segmentCases[sender.selectedSegmentIndex]!
        
        if running {
            resetTimer(false)
            timer = Timer.scheduledTimer(timeInterval: timerSpeed, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
        }
    }
    

    

    // клик по кн. Старт/Стоп
    @IBAction func onStartClick(_ sender: Any) {
        
        resetTimer(false)
        if running {
            running = false
            startBttn.setTitle(dict[16]![LANG], for: .normal) // Старт
        }
        else{
            if progress >= 1 {
                resetTimer()
            }
            timer = Timer.scheduledTimer(timeInterval: timerSpeed, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
            running = true
            startBttn.setTitle(dict[17]![LANG], for: .normal) // Стоп
        }
            
    }
    
    
    
    // таймер
    public func timerFunc(){
      
        progress += 0.01
        if (progress >= 1) {
            resetTimer(false)
            running = false
            startBttn.setTitle(dict[16]![LANG], for: .normal) // Старт
        }
    }
    
 
    
    // сброс таймера
    private func resetTimer(_ fullReset:Bool = true){
        
        if (timer != nil) {
            timer.invalidate()
            if fullReset {
                timer = nil
                progress = 0
            }
        }
    }
    

    
    
    // диспоз
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        resetTimer()
    }
    
    
    
    
    

}



















