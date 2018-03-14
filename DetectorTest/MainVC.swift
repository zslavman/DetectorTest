//
//  ViewController.swift
//  DetectorTest
//
//  Created by Admin on 03.02.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    
    // сюда будут возвращаться из других экранов
    @IBAction func unwindToViewController (segue: UIStoryboardSegue){
        

    }
    
//    var fetchResultsController: NSFetchedResultsController<Sharedobject>!
    
    
    
    
    // включаем видимость статусбара снова
    override var prefersStatusBarHidden: Bool { return false }
    
    
    

    @IBOutlet weak var bttn1: UIButton!
    @IBOutlet weak var bttn2: UIButton!
    @IBOutlet weak var bttn3: UIButton!
    @IBOutlet weak var bttn4: UIButton!
    @IBOutlet weak var langBttn: UIButton!
    
    
    let userDefaults = UserDefaults.standard
    //  LANG = 1 // 0 - RU, 1 - EN, 2 - ES
    var LANG = 0
    var buttonsArr = [UIButton]() // массив всех кнопок
    let dict = Dictionary().dict
    
//    var config: [Conf] = []
   
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        fetchData()
        
        // если первый запуск, то получим значение 0
        LANG = userDefaults.integer(forKey: "lang")
        
        buttonsArr = [bttn1, bttn2, bttn3, bttn4]
        for i in 0..<buttonsArr.count{
            MainVC.designFor(button: buttonsArr[i], radius: 8)
        }

        // заполняем все текстовые поля
        onLangClick(self)
    }

    
    
    
    @IBAction func onNatureClick(_ sender: UIButton) {
        
        // переход на PageVC (вместо segue)
        if let pageViewC = storyboard?.instantiateViewController(withIdentifier: "pageVC") as? PageVC{
            pageViewC.modalTransitionStyle = .coverVertical
            present(pageViewC, animated: true, completion: nil)
        }
            
    }
    
    
    
    
    
    
    
    /* =================================================*/
    /* ============= ПЕРЕКЛЮЧЕНИЕ ЯЗЫКА ================*/
    /* =================================================*/
    @IBAction func onLangClick(_ sender: Any) {
        
        if sender is UIButton{
            LANG += 1
            if LANG == dict[0]!.count{
                LANG = 0
            }
            saveData(LANG)
        }
        
        for i in 0..<buttonsArr.count{
            buttonsArr[i].setTitle(dict[i]![LANG], for: .normal)
        }
        langBttn.setTitle(dict[100]![LANG], for: .normal)
        title = dict[7]![LANG]
    }

    
    
    /* =================================================*/
    /* ============= СОХРАНЕНИЕ ДАННЫХ =================*/
    /* =================================================*/
    func saveData(_ arg:Int) -> Void {
        
        userDefaults.set(arg, forKey: "lang")
        userDefaults.synchronize()
        
//      if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
//
//            config[0].lingua = Int16(LANG)
//
//            // сохраняем сам контекст
//            do {
//                try context.save()
//                print("Успешно сохранено")
//            }
//            catch let error  as NSError{
//                print("Не удалось сохранить данные \(error), \(error.userInfo)")
//            }
//      }
        
    }
    
    
    /* =================================================*/
    /* ============== ПОЛУЧЕНИЕ ДАННЫХ =================*/
    /* =================================================*/
//    func fetchData() -> Void {
//        
//        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
//            
//            do {
//                config = try context.fetch(Conf.fetchRequest())
//                // для первого запуска
//                if config.count == 0{
//                    let newConfig = Conf(context: context)
//                    newConfig.lingua = Int16(LANG)
//                    config.append(newConfig)
//                }
//                else{
//                    LANG = Int(config[0].lingua)
//                }
//
//                print("Данные получены успешно, res = \(config)")
//            }
//            catch let error as NSError{
//                print("Не удалось получить данные \(error), \(error.userInfo)")
//            }
//        }
//    }
    
    
    
    //MARK: - задает стиль для кнопок
    static func designFor(button: UIButton, radius:CGFloat = 0){

        button.layer.cornerRadius = (radius == 0) ? (button.bounds.height / 2) : radius
        button.layer.shadowOffset = CGSize(width: 2, height: 3)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
    }
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "friendSegue"{
//            let destinationVC = segue.destination as! FriendsVC // создаем конст. которая и есть FriendsVC
//        }
        
        if let si = segue.identifier{
            
            switch si {
            case "friendsSegue":
                let destinationVC = segue.destination as! FriendsVC
                destinationVC.LANG = LANG
            case "smilesSegue":
                let destinationVC = segue.destination as! SmilesVC
                destinationVC.LANG = LANG
//            case "natureSegue":
//                let destinationVC = segue.destination as! NatureVC
//                destinationVC.LANG = LANG
            case "otherSegue":
                let destinationVC = segue.destination as! OtherVC
                destinationVC.LANG = LANG
            default:
                assertionFailure("Did't recognize storyboard identifier")
            }
        }


        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



}

