//
//  OtherVC.swift
//  DetectorTest
//
//  Created by Admin on 03.02.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit

class OtherVC: UIViewController {
    
    
    @IBOutlet weak var backBttn: UIButton!
    var LANG:Int = 0
    let dict = Dictionary().dict

    override func viewDidLoad() {
        super.viewDidLoad()
        
         backBttn.setTitle(dict[4]![LANG], for: .normal)

    }



}
