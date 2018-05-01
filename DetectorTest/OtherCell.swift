//
//  OtherCell.swift
//  DetectorTest
//
//  Created by Viacheslav on 02.05.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import Foundation
import UIKit


class OtherCell:UICollectionViewCell{
    
    
    @IBOutlet weak var picture: ImageLoader!
    
    public var photoName:String = ""
    
    public func loadPhotos(){

        let photoLink = "http://zslavman.esy.es/imgdb/" + photoName
        picture.downloadImageFrom(urlString: photoLink, imageMode: .scaleAspectFill)
        
    }
    
    
}


