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
    
    public var jsonDict = [NSDictionary]()
    public var num:Int = 11

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.text = ""
        
        if (jsonDict.count == 0) {
            getJSON()
        }
        else{
            loadPhotos()
        }

    }

    
    
    
    public func getJSON(){
        
        let link = URL(string: "http://zslavman.esy.es/imgdb/index.json")
        
        // создаем очередь
        let queue = DispatchQueue.global(qos: .background)
        
        // добавляем процесс в очередь асинхронно
        queue.async {
            guard let jsonURL = link, let jsonData = try? Data(contentsOf: jsonURL) else { return } // если link существует (не битый), пытаемся получить данные картинки, иначе выходим

            // возвращаемся в основной поток (все обновления интерфейса должны происходить ТОЛЬКО! в основном потоке)
            DispatchQueue.main.async {
                do {
                    // конвертируем в словарь, в котором ключи это стринги, а значения ключей - любой тип
//                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]{
//                        print(json)
//                    }
                    if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? NSArray{
//                        print("Элементов в массиве =  \(jsonArray.count)")
//                        for eachElement in jsonArray{
//                            print((eachElement as! NSDictionary)["view"]!)
//                            print((eachElement as! NSDictionary)["description"] as! String)
//                        }
                        self.jsonDict = jsonArray as! [NSDictionary]
                        self.loadPhotos()
                        self.loadInfo()
                    }
                }
                catch {
                    print("Ошибка сериализации JSON")
                }
            }
        }
    }
    
    
    public func loadInfo(){
        nameTF.text = jsonDict[num].value(forKeyPath: "description") as! String?
    }
    
    
    public func loadPhotos(){
        
        let photoName = jsonDict[num].value(forKeyPath: "view") as! String
        let photoLink = "http://zslavman.esy.es/imgdb/" + photoName
        
        picture.downloadImageFrom(urlString: photoLink, imageMode: .scaleAspectFit)

    }
    
    
    
    


}

















