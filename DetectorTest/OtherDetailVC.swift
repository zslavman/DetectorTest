//
//  OtherVC.swift
//  DetectorTest
//
//  Created by Admin on 03.02.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit

class OtherDetailVC: UIViewController {
    
    
    @IBOutlet weak var picture: ImageLoader!
    @IBOutlet weak var nameTF: UILabel!

    public var num:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.text = ""
        
        loadPhotos()
        loadInfo()
    }


    
    
    public func loadInfo(){
        nameTF.text = OtherVC.jsonDict[num].value(forKeyPath: "description") as! String?
    }
    
    
    public func loadPhotos(){
        
        let photoName = OtherVC.jsonDict[num].value(forKeyPath: "view") as! String
        let photoLink = "http://zslavman.esy.es/imgdb/" + photoName
        
        picture.downloadImageFrom(urlString: photoLink, imageMode: .scaleAspectFit)

    }
    
    
    
    


}

















