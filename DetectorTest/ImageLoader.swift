//
//  ImageLoader.swift
//  DetectorTest
//
//  Created by Viacheslav on 24.04.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader: UIImageView {
    
   
    var imageURLString: String?
    var spiner:UIActivityIndicatorView!
    
    
    private func addSpiner(toItem target:AnyObject) {
        
        spiner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spiner.translatesAutoresizingMaskIntoConstraints = false // не позволяем xcode управлять констрейнами и авторесайзом
        spiner.hidesWhenStopped = true // прячем когда остановиться
        spiner.startAnimating()
        target.addSubview(spiner)
        
        // размещаем
        NSLayoutConstraint(item: spiner, attribute: .centerX, relatedBy: .equal, toItem: target, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spiner, attribute: .centerY, relatedBy: .equal, toItem: target, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
        
    
    
    
    public func downloadImageFrom(urlString: String, imageMode: UIViewContentMode) {
        guard let url = URL(string: urlString) else { return }
        downloadImageFrom(url: url, imageMode: imageMode)
    }
    
    
    
    
    
    
    
   public func downloadImageFrom(url: URL, imageMode: UIViewContentMode) {
        contentMode = imageMode

        if OtherVC.imageCache.keys.contains(url.absoluteString as NSString){
            image = UIImage(data: OtherVC.imageCache[url.absoluteString as NSString] as! Data)
        }
        else {
            addSpiner(toItem: self)
            
            // создаем очередь
            let queue = DispatchQueue.global(qos: .background)
            
            // добавляем процесс в очередь асинхронно
            queue.async {
                guard let imgData = try? Data(contentsOf: url) else { return } // если link существует (не битый), пытаемся получить данные картинки, иначе выходим

                DispatchQueue.main.async {
                    self.spiner.stopAnimating()
                    self.image = UIImage(data: imgData)
                    OtherVC.imageCache.updateValue(imgData as AnyObject, forKey: url.absoluteString as NSString)

                }
            }
        }
    }
    
    
}


















