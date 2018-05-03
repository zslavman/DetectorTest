//
//  OtherDetailVC.swift
//  DetectorTest
//
//  Created by Viacheslav on 01.05.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit




class OtherVC: UICollectionViewController{
    
    
    public static var imageCache = [NSString:AnyObject]()
    public static var jsonDict = [NSDictionary]()
    
    public var LANG:Int!
    private let dict = Dictionary().dict
    
    private var clickedCellNum:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        title = "ФотоАльбом"
        
        if (OtherVC.jsonDict.isEmpty) {
            getJSON()
        }
    }
        


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? NSArray{
                        OtherVC.jsonDict = jsonArray as! [NSDictionary]
                        self.collectionView?.reloadData()
                    }
                }
                catch {
                    print("Ошибка сериализации JSON")
                }
            }
        }
    }
    
    

    
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }

    // общее кол-во ячеек
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OtherVC.jsonDict.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! OtherCell
    
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        if OtherVC.jsonDict.count > 0{
            cell.photoName = OtherVC.jsonDict[indexPath.row].value(forKeyPath: "view") as! String
            cell.loadPhotos()
        }
            
        return cell
    }
    
    
    // регулировка размеров ячейки в зависимости от размеров экрана
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize {
        
        let screenWidth = self.view.bounds.width - 5*2 - 5*2 // ...минус indent, минсу gap
        let cellWidth = screenWidth / 3
        let size = CGSize(width: cellWidth, height: cellWidth*0.8)
        
        return size
    }
    
    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    
    // клик по ячейке
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        clickedCellNum = indexPath.row
        
        return true
    }
 

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
//    toDetailViewSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let si = segue.identifier{
            
            switch si {
            case "toDetailViewSegue":
                let destinationVC = segue.destination as! OtherDetailVC
                destinationVC.num = clickedCellNum
            default:
                assertionFailure("Did't recognize storyboard identifier")
            }
        }

        
        
    }
    
    
    
    
    

}





























