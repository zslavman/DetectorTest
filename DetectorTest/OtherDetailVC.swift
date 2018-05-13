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
    
    var barIsHidden = false
    var navigationBarHeight: CGFloat = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.flashScrollIndicators()
        
        scrollView.delegate = self
        
        nameTF.text = ""
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGest)
        
        // запоминаем высоту навбара
        navigationBarHeight = (navigationController?.navigationBar.frame.size.height)!
        
        print(navigationBarHeight)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideAndShowBar))
        view.addGestureRecognizer(tapGesture)
        
//        picture.frame = CGRect(x: 0, y: -64, width: 240, height: 320)
//        picture.frame.offsetBy(dx: 0.0, dy: 100.0)
//        picture.frame.origin = CGPoint(x: 0, y: 200)
        
        loadPhotos()
        loadInfo()
        
//        scrollView.contentSize.height = 100

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
    
    
    
    
    // событие поворота экрана
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scrollView.setZoomScale(1, animated: true)
    }
        
    
    
    // аля диспоз
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    
    
    
    
    /* ================================================*/
    /* ========== ДВОЙНОЙ КЛИК ПО КАРТИНКЕ ============*/
    /* ================================================*/
    
    func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        }
        else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = picture.frame.size.height / scale
        zoomRect.size.width  = picture.frame.size.width  / scale
        let newCenter = picture.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    
    
    
    
    
    func hideAndShowBar() {
        if barIsHidden == false {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.navigationController?.navigationBar.alpha = 0.0
                self.navigationController?.navigationBar.frame.size.height = 0.0
            }, completion: {
                (_) in
                self.barIsHidden = true
            })
        }
        else {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.navigationController?.navigationBar.alpha = 1.0
                self.navigationController?.navigationBar.frame.size.height = self.navigationBarHeight
            }, completion: {
                (_) in
                self.barIsHidden = false
            })
        }
    }
    
    
    
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    
    


}

















