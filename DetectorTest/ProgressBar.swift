//
//  Preloader.swift
//  DetectorTest
//
//  Created by Viacheslav on 16.06.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit


// рисует прелоадер
class ProgressBar:UIView {
    
    
    public var thisWidth:Int = 150  // ширина прелоадера
    private var lineWidth:Int = 10 // толщина линии прелоадера
    
    private var backShapeLayer:CAShapeLayer = CAShapeLayer()
    private var topShapeLayer:CAShapeLayer = CAShapeLayer()
        
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        createProgressLayer()
//    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createBars()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
  
    // задаем параметры для шкал на верхнем и нижнем слоях
    func createBars() {
        
        backShapeLayer.lineWidth = CGFloat(lineWidth)
        backShapeLayer.lineCap = "round"
        backShapeLayer.fillColor = nil // не делать автозаливку открытых path
        backShapeLayer.strokeStart = 0 // начальная точка отрисовку траэктории
        backShapeLayer.strokeEnd = 1 // последняя точка отрисовку траэктории (1 - 100% линии нарисовано)
        backShapeLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        layer.addSublayer(backShapeLayer)

        topShapeLayer.lineWidth = CGFloat(lineWidth - 3)
        topShapeLayer.lineCap = "round"
        topShapeLayer.fillColor = nil
        topShapeLayer.strokeStart = 0
        topShapeLayer.strokeEnd = 0
        topShapeLayer.strokeColor = #colorLiteral(red: 0.2953388691, green: 0.8497148156, blue: 0.3902329504, alpha: 1).cgColor
       
        layer.addSublayer(topShapeLayer)
        
        configLayers(backShapeLayer)
        configLayers(topShapeLayer)
        
//        layer.mask = backShapeLayer
    }
        
    
    
    // рисование путей шкал
    private func configLayers(_ shapeLayer:CAShapeLayer){
        
        shapeLayer.frame = layer.bounds
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0)) // начальная точка прямой
        path.addLine(to: CGPoint(x: thisWidth, y: 0)) // конечная точка прямой
        shapeLayer.path = path.cgPath
    }
    
    
    // сеттер для шкалы прогресса (получается с анимацией, но ступенчато)
    public var setProgress:Float = 0 {
        didSet {
            topShapeLayer.strokeEnd = CGFloat(setProgress)
        }
    }
    
    
    
    // ф-ция анимирующая заполнение шкалы
    public func startAnimate(_ duration:Int){
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.toValue = 1
        animation.duration = CFTimeInterval(duration)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fillMode = kCAFillModeBoth
        animation.isRemovedOnCompletion = false
        
        topShapeLayer.add(animation, forKey: nil)
    }
    
    
    public func stopAnimation(){
        topShapeLayer.removeAllAnimations()
        setProgress = 0
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    

    
    
    
    
    
    
}
