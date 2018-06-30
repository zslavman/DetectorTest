//
//  CustomProgBar.swift
//  DetectorTest
//
//  Created by Viacheslav on 26.06.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit

class CustomProgBar: UIViewController {

    
    @IBOutlet weak var progress_filling:UIImageView!
    private var shapeMask:CAShapeLayer = CAShapeLayer()
    public var thisWidth:CGFloat = 10       // ширина прелоадера
    private var lineWidth:CGFloat = 10  // толщина (жирность) линии прелоадера
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Кастомный прогрессбар"
        lineWidth = progress_filling.frame.height
        print("высота прогрессбара = \(progress_filling.frame.height)")
        
        thisWidth = progress_filling.frame.width
        print("ширина прогрессбара = \(progress_filling.frame.width)")

        
        createMask()
        
    }
    
    
    
    
    private func createMask(){
       
        shapeMask.lineWidth = CGFloat(lineWidth - 3)
        shapeMask.lineCap = "butt" // прямоугольные очертания
        shapeMask.fillColor = nil  // не делать автозаливку открытых path
        shapeMask.strokeStart = 0  // начальная точка отрисовку траэктории
        shapeMask.strokeEnd = 0.6    // последняя точка отрисовку траэктории (1 - 100% линии нарисовано)
        shapeMask.strokeColor = #colorLiteral(red: 0.2953388691, green: 0.8497148156, blue: 0.3902329504, alpha: 1).cgColor
        shapeMask.opacity = 0.7
        
        progress_filling.layer.addSublayer(shapeMask)
        
        // рисование path маски
        shapeMask.frame = progress_filling.layer.bounds
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: lineWidth/2))            // начальная точка прямой
        path.addLine(to: CGPoint(x: thisWidth, y: lineWidth/2)) // конечная точка прямой
        shapeMask.path = path.cgPath
        
        progress_filling.layer.mask = shapeMask

        
        
        
        
    }


    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}















