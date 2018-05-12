//
//  OtherVC.swift
//  DetectorTest
//
//  Created by Admin on 03.02.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit

class OtherDetailVC: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var picture: ImageLoader!
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!

    public var num:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.flashScrollIndicators()
        
        scrollView.delegate = self
        
        nameTF.text = ""
        
//        picture.frame = CGRect(x: 0, y: -64, width: 240, height: 320)
//        picture.frame.offsetBy(dx: 0.0, dy: 100.0)
        picture.frame.origin = CGPoint(x: 0, y: 200)
        
        
        loadPhotos()
        loadInfo()
    }


    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return picture
    }
    
    
    public func loadInfo(){
        nameTF.text = OtherVC.jsonDict[num].value(forKeyPath: "description") as! String?
    }
    
    
    public func loadPhotos(){
        
        let photoName = OtherVC.jsonDict[num].value(forKeyPath: "view") as! String
        let photoLink = "http://zslavman.esy.es/imgdb/" + photoName
        
        picture.downloadImageFrom(urlString: photoLink, imageMode: .scaleAspectFill)


    }
    
    
    
    


}

















