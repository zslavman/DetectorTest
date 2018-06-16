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
    
    
    public var thisWidth:Int = 130 // ширина прелоадера
    private var lineWidth:Int = 15// жирность прелоадера
    
    private var shapeLayer:CAShapeLayer = CAShapeLayer()
        
   

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createProgressLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createProgressLayer()
    }
    
    
    
  
    // бэк прелоадера (нижний слой)
    func createProgressLayer() {
        
        shapeLayer.lineWidth = CGFloat(lineWidth)
        shapeLayer.lineCap = "round"
        shapeLayer.fillColor = nil // не делать автозаливку открытых path
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1 // последняя точка отрисовку траэктории, 0 - начальная
        shapeLayer.strokeColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1).cgColor
        
        layer.addSublayer(shapeLayer)
        shapeLayer.frame = bounds
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0)) // начальная точка прямой
        path.addLine(to: CGPoint(x: thisWidth, y: 0)) // конечная точка прямой
        shapeLayer.path = path.cgPath
//        print("createProgressLayer")
    }
    
    
    
    

    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    

    
    
    
    
    
    
}
