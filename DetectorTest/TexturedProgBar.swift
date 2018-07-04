//
//  TexturedProgBar.swift
//  DetectorTest
//
//  Created by Viacheslav on 05.07.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit

class TexturedProgBar: UIViewController {

    
    private var backTexture:String?
    private var fillTexture:String?
    private var overallWidth:Int?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }


    
    
    
    
    init(backTexture:String, fillTexture:String, overallWidth:Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.fillTexture = fillTexture
        self.backTexture = backTexture
        self.overallWidth = overallWidth
        
        
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    



}
