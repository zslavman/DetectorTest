//
//  OtherVC.swift
//  DetectorTest
//
//  Created by Admin on 03.02.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit
import ImageIO

class OtherDetailVC: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var picture: ImageLoader!
    
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var exifTF: UILabel!
    @IBOutlet weak var infoBacking: UILabel!
    
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
        
        // запоминаем высоту навбара (чтоб прятать его)
//        navigationBarHeight = (navigationController?.navigationBar.frame.size.height)!
//        print("navigationBarHeight = \(navigationBarHeight)")
        
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(hideAndShowBar))
        view.addGestureRecognizer(doubleTap)
        
//        picture.frame = CGRect(x: 0, y: -64, width: 240, height: 320)
//        picture.frame.offsetBy(dx: 0.0, dy: 100.0)
//        picture.frame.origin = CGPoint(x: 0, y: 200)
        
        loadPhotos()
        loadInfo()
        
        
        // свайпы влево и вправо
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeft)
        
//        print("размер картинки внутри picture: \(picture.image?.size.height)")
//        picture.frame.origin.x = (scrollView.bounds.size.width - picture.frame.size.width) / 2
        
        // увеличиваем картинку чтоб полностью заполнила собой экран (aspect fill)
        scrollView.setZoomScale(scrollView.frame.height/scrollView.frame.width, animated: false)
        
//        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    
    


    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return picture
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    
    
    /* ========================================*/
    /* ========== при СКРОЛЕ и ЗУМ ============*/
    /* ========================================*/
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let imageViewSize = picture.frame.size
//        let scrollViewSize = scrollView.bounds.size
//        
//        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
//        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
//        
//        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
//        if scrollView.zoomScale < scrollView.minimumZoomScale {
//            picture.contentOffset(x: scrollView.bounds.size.width - picture.frame.size.width, y: scrollView.bounds.size.height - picture.frame.size.height)
//        }
        if !barIsHidden {
            hideAndShowBar()
        }
//        print("расположение картинки по Х: \(picture.frame.origin.x)")
        print("размер скролвью контента: \(scrollView.contentSize)")
//        print("размер границ скролвью: \(scrollView.bounds)")

        
//        let imageViewSize = picture.frame.size
//        let scrollViewSize = scrollView.bounds.size
//        print("ширина картинки =  \(imageViewSize.width)")
//        if imageViewSize.width < scrollViewSize.width {
//            picture.frame.origin.x = (scrollViewSize.width - imageViewSize.width) / 2
//        }
    }
        
    
    
    
    
    
    
    func onSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                print("Свайп влево")
                
            case UISwipeGestureRecognizerDirection.right:
                print("Свайп вправо")
                
            default:
                break
            }
        }
    }
    
    
    
    
    
    /* =============================================*/
    /* ========== ЗАГРУЗКА ФОТОК И ИНФЫ ============*/
    /* =============================================*/
    public func loadInfo(){
        let city = OtherVC.jsonDict[num].value(forKeyPath: "city") as! String!
        nameTF.text = "Город: \(city!)"
        title = OtherVC.jsonDict[num].value(forKeyPath: "description") as! String?
    }
    
    public func loadPhotos(){
        
        let photoName = OtherVC.jsonDict[num].value(forKeyPath: "view") as! String
        let photoLink = "http://zslavman.esy.es/imgdb/" + photoName
        
        picture.downloadImageFrom(urlString: photoLink, imageMode: .scaleAspectFill, callback:readEXIF)
    }



    

    
    /* ===================================*/
    /* ========== чтение EXIF ============*/
    /* ===================================*/
    func readEXIF(){
        
        let im = OtherVC.imageCache[picture.downloadedLink as NSString]
        
        if let imageSource = CGImageSourceCreateWithData(im as! CFData, nil) {
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as! NSDictionary
            
            // дата съемки
            let exifModel_ = imageProperties.value(forKey: "{Exif}") as! NSDictionary
            let dateTimeOriginal = exifModel_.value(forKey:kCGImagePropertyExifDateTimeOriginal as String) as! NSString
            
            // модель фотика
            //            let tiffModel_ = imageProperties.value(forKey: "{TIFF}")
            //            let cameraModel = (tiffModel_ as AnyObject).value(forKey: kCGImagePropertyTIFFModel as String) as! NSString
            
            var str = dateTimeOriginal as String
            str = str.replacingOccurrences(of: " ", with: "  Время: ")
            
            exifTF.text = "Дата съемки: \(str)"
        }
    }
    
    
    
    
    /* ======================================*/
    /* ========== ПОВОРОТ ЭКРАНА ============*/
    /* ======================================*/
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        scrollView.setZoomScale(1, animated: true)
    }
    
    
 
    
    

    
    
    /* ================================================*/
    /* ========== ДВОЙНОЙ КЛИК ПО КАРТИНКЕ ============*/
    /* ================================================*/
    
    func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        }
        else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
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
    
    
    
    
    
    /* ================================================*/
    /* ========== ПОКАЗАТЬ/СПРЯТАТЬ НАВБАР ============*/
    /* ================================================*/
    func hideAndShowBar() {
        if !barIsHidden { // прячем
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.navigationController?.navigationBar.alpha = 0.0
//                self.navigationController?.navigationBar.frame.size.height = 0.0
                self.exifTF.alpha = 0.0
                self.nameTF.alpha = 0.0
                self.infoBacking.alpha = 0.0
            }, completion: {
                (_) in
                self.barIsHidden = true
            })
        }
        else { // показываем
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.navigationController?.navigationBar.alpha = 1.0
//                self.navigationController?.navigationBar.frame.size.height = self.navigationBarHeight
                self.exifTF.alpha = 1.0
                self.nameTF.alpha = 1.0
                self.infoBacking.alpha = 1.0
            }, completion: {
                (_) in
                self.barIsHidden = false
            })
        }
    }
    
    

    
    
    
    
    
    /* ==============================*/
    /* ========== ДИСПОЗ ============*/
    /* ==============================*/
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the Navigation Bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
}
    





// не работает
extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        var contentRect = CGRect.zero
        for view in self.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.contentSize = contentRect.size
    }
}

















