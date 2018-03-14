//
//  NatureVC.swift
//  DetectorTest
//
//  Created by Admin on 03.02.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit

class NatureVC: UIViewController {
    
    
//    @IBOutlet weak var backBttn: UIButton!
    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var labelMain: UILabel!
    
//    var LANG:Int = 0
//    let dict = Dictionary().dict
    var index = 0 // индекс для вьюконтроллеров пейджвьюконтроллера
    
    var imageName:String = ""
    var str:String = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard UIImage(named: imageName) != nil else { return }
        
        imageBack.image = UIImage(named: imageName)
        
        labelMain.text = str
        

    }
    


    


}
