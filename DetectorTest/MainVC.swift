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

    
    @IBOutlet weak var bttn1: UIButton! // Друзья
    @IBOutlet weak var bttn2: UIButton! // Фонарик
    @IBOutlet weak var bttn3: UIButton! // Природа
    @IBOutlet weak var bttn4: UIButton! // JSON галлерея
    @IBOutlet weak var bttn5: UIButton! // кастомный прогрессбар
    @IBOutlet weak var langBttn: UIButton!
    
    // сюда будут возвращаться из других экранов
    @IBAction func unwindToViewController (segue: UIStoryboardSegue){
        

    }
    

    
    
    
    
    
    
    let userDefaults = UserDefaults.standard
    //  LANG = 1 // 0 - RU, 1 - EN, 2 - ES
    public static var LANG = 0
    var buttonsArr = [UIButton]() // массив всех кнопок
    let dict = Dictionary().dict
    

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        bttn4.titleLabel?.adjustsFontSizeToFitWidth = true
        bttn5.titleLabel?.adjustsFontSizeToFitWidth = true
        
        bttn5.titleLabel!.preferredMaxLayoutWidth = bttn5.layer.frame.width - 50
        //        print("Реальная ширина поля = \(bttn5.titleLabel!.frame.width)")
        //        print("Максимальная ширина поля = \(bttn5.titleLabel!.preferredMaxLayoutWidth)")
        
 
        // если первый запуск, то получим значение 0
        MainVC.LANG = userDefaults.integer(forKey: "lang")
        
        buttonsArr = [bttn1, bttn2, bttn3, bttn4]
//        for i in 0..<buttonsArr.count{
//            MainVC.designFor(button: buttonsArr[i], radius: 8)
//        }

        // заполняем все текстовые поля
        onLangClick(self)
        
        
    }

    
    
    

    
    
    /* =================================================*/
    /* ============= ПЕРЕХОД НА PageVC  ================*/
    /* =================================================*/
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
            MainVC.LANG += 1
            if MainVC.LANG == dict[0]!.count{
                MainVC.LANG = 0
            }
            saveData(MainVC.LANG)
        }
        
        for i in 0..<buttonsArr.count{
            buttonsArr[i].setTitle(dict[i]![MainVC.LANG], for: .normal)
        }
        bttn5.setTitle(dict[15]![MainVC.LANG], for: .normal)
        langBttn.setTitle(dict[100]![MainVC.LANG], for: .normal)
        title = dict[7]![MainVC.LANG]
    }

    
    
    /* =================================================*/
    /* ============= СОХРАНЕНИЕ ДАННЫХ =================*/
    /* =================================================*/
    func saveData(_ arg:Int) -> Void {
        
        userDefaults.set(arg, forKey: "lang")
        userDefaults.synchronize()
        
    }
    

    
    
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
                destinationVC.LANG = MainVC.LANG
            case "smilesSegue":
                let destinationVC = segue.destination as! Flashlight
                destinationVC.LANG = MainVC.LANG
//            case "natureSegue":
//                let destinationVC = segue.destination as! NatureVC
//                destinationVC.LANG = MainVC.LANG
            case "otherSegue":
                let destinationVC = segue.destination as! OtherVC
                destinationVC.LANG = MainVC.LANG
            default:
                assertionFailure("Did't recognize storyboard identifier")
            }
        }


        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



}

