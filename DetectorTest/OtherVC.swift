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
    
    public var jsonDict = [String: Any]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBttn.setTitle(dict[4]![LANG], for: .normal)
        getJSON()

    }

    
    
    
    public func getJSON() -> Void{
        
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
                        print("Элементов в массиве =  \(jsonArray.count)")
                        
                        for eachElement in jsonArray{
                            print((eachElement as! NSDictionary)["view"] as! String)
                            print((eachElement as! NSDictionary)["description"] as! String)
                        }
                    }
                }
                catch {
                    print("Ошибка сериализации JSON")
                }
            }
        }
        //***********
        
        
        
//        let task = URLSession.shared.dataTask(with: link!) {
//            (data, response, error) in
//            
//            if let data = data{
//                do{
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
//                        print(json)
//                    }
//                }
//                catch{
//                    print(error.localizedDescription)
//                }
//            }
//        }
//        task.resume()

    }
}

















