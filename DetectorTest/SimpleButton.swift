//
//  SimpleButton.swift
//  DetectorTest
//
//  Created by Viacheslav on 17.06.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit

@IBDesignable
class SimpleButton: UIButton {
    
    private var filet = CGSize()
    
    @IBInspectable var cornerRadius:CGFloat = 7 {
        didSet{
            filet = CGSize(width: cornerRadius, height: cornerRadius)
        }
    }
    @IBInspectable var buttonColor:UIColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    @IBInspectable var shadowColor:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    var path:UIBezierPath!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
        path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.allCorners], cornerRadii: filet)
        buttonColor.setFill()
        path.fill()
        
        layer.shadowOffset = CGSize(width: 2, height: 3)
        layer.shadowRadius = 4
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = 0.6
    }
    
    
    // чтоб бокс кнопки не выходил за пределы ее видимых полей
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // лежить ли point внутри path окружности кнопки
        if let path = path{
            return path.contains(point)
        }
        return false
    }
    
    
    
}
