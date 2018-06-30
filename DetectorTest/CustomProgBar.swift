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
    
    
    private var progress_filling:UIImageView!           // картинка заполнения бэкграунда прогрессбара
    
    private var shapeMask:CAShapeLayer = CAShapeLayer() // маска
    private var maskWidth:CGFloat = 10                  // ширина прелоадера
    private var lineWidth:CGFloat = 10                  // толщина (жирность) линии, которая будет рисовать маску прогрессбара
    private var timer:Timer!
    
    // геттер/сеттер для шкалы прогресса
    public var progress:Float {
        get{
            return Float(shapeMask.strokeEnd)
        }
        set {
            shapeMask.strokeEnd = CGFloat(newValue)
            percents_TF.text = "\(Int(newValue * 100)) %"
        }
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        percents_TF.adjustsFontSizeToFitWidth = false
        
        progress_filling = UIImageView(image: UIImage(named: "progbar_filling"))
        progress_filling.contentMode = .scaleAspectFit
        progress_filling.bounds = progress_backing.bounds
        progress_filling.frame.origin = CGPoint(x: 0, y: 0)
        
        progress_backing.addSubview(progress_filling)

        title = "Кастом прогрессбар"
        lineWidth = progress_backing.frame.height
        maskWidth = progress_backing.frame.width

        createAndApplyMask()
        
        progress = 0
    }
        
    
    
    
    
    private func createAndApplyMask(){
       
        shapeMask.lineWidth = CGFloat(lineWidth - 3)
        shapeMask.lineCap = "butt" // прямоугольные очертания
        shapeMask.fillColor = nil  // не делать автозаливку открытых path
        shapeMask.strokeStart = 0  // начальная точка отрисовку траэктории
        shapeMask.strokeEnd = 1    // последняя точка отрисовку траэктории (1 - 100% линии нарисовано)
        shapeMask.strokeColor = #colorLiteral(red: 0.2953388691, green: 0.8497148156, blue: 0.3902329504, alpha: 1).cgColor
        shapeMask.opacity = 0.7
        
        progress_backing.layer.addSublayer(shapeMask)
        
        // рисование path маски
        shapeMask.frame = progress_backing.layer.bounds
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: lineWidth/2))            // начальная точка прямой
        path.addLine(to: CGPoint(x: maskWidth, y: lineWidth/2)) // конечная точка прямой
        shapeMask.path = path.cgPath
        
        progress_filling.layer.mask = shapeMask
    }

    
    
    
    
    

    


    @IBAction func onStartClick(_ sender: Any) {
        
        resetTimer()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
    }
    
    
    
    public func timerFunc(){
      
        progress += 0.01
        if (progress >= 1) {
//            onStartClick(self)
            timer.invalidate()
        }
    }
    
 
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        resetTimer()
    }
    
    
    
    private func resetTimer(){
        if (timer != nil) {
            timer.invalidate()
            timer = nil
            progress = 0
        }
    }
    

}



















