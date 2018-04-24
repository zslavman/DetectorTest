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
    
    let imageCache = NSCache<NSString, AnyObject>()
    var imageURLString: String?
    
    
    
    
    func downloadImageFrom(urlString: String, imageMode: UIViewContentMode) {
        guard let url = URL(string: urlString) else { return }
        downloadImageFrom(url: url, imageMode: imageMode)
    }
    
    
    
    func downloadImageFrom(url: URL, imageMode: UIViewContentMode) {
        contentMode = imageMode
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        }
        else {
            URLSession.shared.dataTask(with: url) {
                data, response, error in
                
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                    self.image = imageToCache
                }
            }.resume()
        }
    }
}
