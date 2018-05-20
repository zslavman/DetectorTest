//
//  PageVC.swift
//  DetectorTest
//
//  Created by Admin on 24.02.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {

    
    let headersArray = ["Ать", "Два", "Три", "Всё!"]
    let imagesArray = ["nat1.jpg", "nat2.jpg", "nat3.jpg", "nat4.jpg"]
    
    
    
    // прячем статусбар
    override var prefersStatusBarHidden: Bool { return true }
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        dataSource = self
        
        if let firstVC = displayViewController(atIndex: 0){
            // метод для загрузки вьюконтроллеров
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
//        let pageControlAppearance = UIPageControl.appearance()
//        pageControlAppearance.backgroundColor = #colorLiteral(red: 0.2140321434, green: 0.635050118, blue: 0.9231165051, alpha: 0.3598599138)
//        pageControlAppearance.pageIndicatorTintColor = UIColor.lightGray
//        pageControlAppearance.currentPageIndicatorTintColor = UIColor.red
        
    }
    
    
    
    
    
    // убираем фон с индикатора страниц
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if let pageScrollView = view.subviews.first {
            pageScrollView.frame = view.bounds
        }
    }
    

    
    /* =======================================================*/
    /* === ВОЗВРАЩАЕТ ВК NatureVC (как страницу пагинатора) ==*/
    /* =======================================================*/
    func displayViewController(atIndex index: Int ) -> NatureVC?{
        
        //вьюконтроллер будет отображаться лишь если index наход. в пределах [0, headersArray.count]
        guard index >= 0 else { return nil}
        guard index < headersArray.count else { return nil}
        
        guard let natureVC = storyboard?.instantiateViewController(withIdentifier: "natureVC") as? NatureVC else{ return nil }
        natureVC.imageName = imagesArray[index]
        natureVC.str = headersArray[index]
        natureVC.index = index
        
        return natureVC
    }

    
    
    // обязательный метод, говорит о том, какой будет следующий ВК
    func nextVC(atIndex index:Int){
        
        // пробуем вызвать следующий вьюконтроллер
        if let contentVC = displayViewController(atIndex: index + 1){
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
        }
    }



}

// для перемещения по страницах подписываемся на
extension PageVC: UIPageViewControllerDataSource{
    
    //как будет меняться индекс когда листаем вперед
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! NatureVC).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    
    //как будет меняться индекс когда листаем назад
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        var index = (viewController as! NatureVC).index
        index += 1
        return displayViewController(atIndex: index)
    }
    
    
    
    // !!!! не будет отображаться если трансишн будет на Page Curl
    // кол-во слайдов
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return headersArray.count
    }
    
    // индекс текущего слайда
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        let natureVC = storyboard?.instantiateViewController(withIdentifier: "natureVC") as? NatureVC
        return natureVC!.index
    }
    
    // в родном индикаторе страниц (в виде точек) все печально, потому создадим свой кастомный индикатор страниц, перетащив на сториобард элемент Page Control
  
}


















