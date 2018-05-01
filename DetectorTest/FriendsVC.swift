//
//  FriendsVC.swift
//  DetectorTest
//
//  Created by Admin on 03.02.18.
//  Copyright © 2018 HomeMade. All rights reserved.
//

import UIKit
import CoreData

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    
    @IBOutlet weak var titleTF: UINavigationItem!
    @IBOutlet weak var backBttn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countTF: UILabel!
    @IBOutlet weak var editBttn: UIBarButtonItem!

    var searchController: UISearchController!
    
    var instances: [Sharedobject] = [] // сюда запишем все экземпляры Sharedobject, полученые в viewDidLoad
    var filteredData:[Sharedobject] = [] // сюда будем складывать результаты поиска
    
    var fetchResultsController: NSFetchedResultsController<Sharedobject>!
    var statments = [Int:Bool]() // массив состояний (стоит галочка или нет)
    
    var LANG:Int = 0
    let dict = Dictionary().dict
    var selected:Int = 0
    
   

    
//   var myNames = ["Вася", "Петя", "Колян", "Витёк", "Дрюня", "Лушпак", "Автандил", "Даня", "Сеня","Лёва","Жека","Лёлик","Болик","Гриша", "Миша", "Ариша", "Яцык", "Серый", "Игорь", "Зёзик", "Артемий", "Тёма"]
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        MainVC.designFor(button: backBttn, radius: 8)
        backBttn.setTitle(dict[4]![LANG], for: .normal)
        countTF.text = dict[6]![LANG] + " " + String(selected)
        
        fetchData()
        
        titleTF.title = dict[0]![LANG]
        
        
        // передаем нил, чтоб результаты отображались в главном экране (на том, котором будет поисковая панель)
        searchController = UISearchController(searchResultsController: nil)
        
        //отключаем затемнение вьюконтроллера при вводе
        searchController.dimsBackgroundDuringPresentation = false
//        searchController.obscuresBackgroundDuringPresentation = true
        // не разрешаем прятать навбар при фокусе в поле поиска
//        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.8683, green: 0.95, blue: 0.836, alpha: 1) // цвет самой панели
        searchController.searchBar.tintColor = #colorLiteral(red: 0.2746803761, green: 0.4887529016, blue: 0.1391218901, alpha: 1)
        searchController.searchBar.placeholder = dict[8]![LANG] // "Начните вводить имя"
        
        tableView.tableHeaderView = searchController.searchBar
        
        // чтоб searchController не переходил на другие экраны (детайлвьюконтроллер)
        definesPresentationContext = true
        
        // указываем, какой контроллер будет обновлять результаты поиска
        // обязательно нужно подписаться под протокол UISearchResultsUpdating чтоб работало!
        searchController.searchResultsUpdater = self
        
        // для соблюдения протокола UISearchBarDelegate
        searchController.searchBar.delegate = self
        
        // если это первый запуск
        if instances.isEmpty {
            // избавляемся от пустых строк и делаем таблицу без фона
            tableView.tableFooterView = UIView(frame: CGRect.zero)
            tableView.backgroundColor = UIColor.clear
        }
        
        // если бы этот класс был UITableViewController, то достаточно было бы указать кнопку для редактирования...
        // self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    
    
    
    
    
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        searchController.isActive = false;
        
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
        }
        
        // перенумеровываем строки в соотв. с тем как они сейчас расположены друг относительно друга (для сохранения порядка)
        for (index, value) in instances.enumerated() {
            value.order = Int16(index)
            print("\(value.friendName!)")
        }
        saveData(createCell: false)
    }
        
        
        
        
    
    
    
    
    /* =================================*/
    /* ======== Кликнули на "+" ========*/
    /* =================================*/
    @IBAction func onPlusClick(_ sender: UIBarButtonItem) {
        
        if tableView.isEditing { return }
        
        // принудительно заканчиваем поиск, если он начат
        if searchController.isActive{
            searchController.isActive = false
        }
        
        // "Добавление друга"
        let alertController = UIAlertController(title: nil, message: dict[10]![LANG], preferredStyle: .alert)
        
        // добавляем текстовое поле
        alertController.addTextField {
            myTF in
            myTF.placeholder = self.dict[9]![self.LANG] //"Имя друга"
            myTF.isSecureTextEntry = false
            myTF.textAlignment = .left
        }
        
        let ok = UIAlertAction(title: self.dict[11]![self.LANG], style: .default){ //"ОК"
            handler in
            
            let string = alertController.textFields?.first?.text ?? ""
            
            if (string != ""){
//                var order = self.instances.count + 1
//                if self.instances.isEmpty { order = 0 }
                self.saveData(createCell: true, friendName: string)
            }
        }
        
        let cancel = UIAlertAction(title: self.dict[12]![self.LANG], style: .cancel, handler: nil) // "Отмена"
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    /* =======================================*/
    /* ======== Кликнули на "Редакт." ========*/
    /* =======================================*/
    @IBAction func onEditClick(_ sender: UIBarButtonItem) {
        
        if searchController.isActive || instances.isEmpty { return }
        
        let allowEditing = !tableView.isEditing
        if allowEditing {
            editBttn.title = "Готово"
        }
        else{
            editBttn.title = "Редакт."
            saveData(createCell: false)
        }
        tableView.setEditing(allowEditing, animated: true)
    }


    
    
    
//    // выходим из режима редактирования при таче вне таблицы
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        if touches.first is UITableView {
////            tableView.setEditing(false, animated: true)
////        }
//        print("Касание произошло!")
//        super.touchesBegan(touches, with: event)
//    }
    
    
    

    
    
    
    /* ==================================*/
    /* ======== Сохранение данных =======*/
    /* ==================================*/
    func saveData(createCell creation:Bool, friendName arg:String = "") -> Void {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            
            if (creation){
                let sharedObj = Sharedobject(context: context)
                sharedObj.friendName = arg
                sharedObj.order = Int16(instances.count)
            }
           
//             print("Имя друга: \(arg) порядок: \(instances.count)")
            
            // сохраняем сам контекст
            do {
                try context.save()
                print("Успешно сохранено")
            }
            catch let error as NSError{
                print("Не удалось сохранить данные \(error), \(error.userInfo)")
            }
            
        }
    }
    
    
    
    
    /* =================================*/
    /* ======== Получение данных =======*/
    /* =================================*/
    func fetchData() -> Void {
        
        let fetch_Raquest: NSFetchRequest<Sharedobject> = Sharedobject.fetchRequest()
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            
            // сортируем
            let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
            fetch_Raquest.sortDescriptors = [sortDescriptor]
            
            // или без сортировки
//            fetch_Raquest.sortDescriptors = []
            
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetch_Raquest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            
            // подписались пот то, что будем реализовывать методы протокола NSFetchedResultsControllerDelegate (для обновления таблицы)
            fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                // если все ок - заполняем массив instances объектами, которые получаем через fetchResultsController
                instances = fetchResultsController.fetchedObjects!
                print("Данные получены успешно")
            }
            catch let error  as NSError{
                print("Не удалось получить данные \(error), \(error.userInfo)")
            }
        }
    }
    
    
    
    
    
    // Получение данных (способ 2) в этом способе почему то не будет обновлятся таблица при добавлении новых друзей и будет ошибка при удалении их
    func fetchData2() -> Void {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetch_Raquest: NSFetchRequest<Sharedobject> = Sharedobject.fetchRequest()
        
            do {
              instances = try context.fetch(fetch_Raquest)
                print("Данные из CoreData получены успешно")
            }
            catch let error as NSError{
                print("Не удалось получить данные \(error), \(error.userInfo)")
            }

    }
 
    
    
    
    
    
    
    
    
 
    
    /* ===================================================*/
    /* ============= ДЕЙСТВИЯ С ТАБЛИЦЕЙ =================*/
    /* ===================================================*/
    
    // MARK:  Реализация методов NSFetchedResultsControllerDelegate
    
    /// Перегружает не всю таблицу, а лишь конкретные indexPath.
    /// Cработает перед тем, как контроллер поменяет свой контент. Посути, метод предупреждает tableView, что сейчас будут обновления
    /// - Parameter controller: <#controller description#>
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // при любых изменениях с данными сработает это
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type:
        NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert, .delete: guard let indexPath = newIndexPath else {break}
            tableView.insertRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else {break}
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        instances = controller.fetchedObjects as! [Sharedobject]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell")
        
        let selectedCell = friendToDisplay(indexPath: indexPath)
        
        cell?.textLabel?.text = selectedCell.friendName // на этом этапе в instances уже загруженные с хранилища элементы
        
        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = UITableViewCellSelectionStyle.default
        
        //задаем цвет выделения ячейки при клике на нее
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        cell?.selectedBackgroundView = backgroundView

//        // избавляемся от пустых строк и делаем таблицу без фона
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.backgroundColor = UIColor.clear
        
        tableView.separatorColor = #colorLiteral(red: 0.2746803761, green: 0.4887529016, blue: 0.1391218901, alpha: 1)
        
        // заполняем ячейку (галочка/пусто)
        doChekmark(cell!, indexPath.row, true)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredData.count
        }
        return instances.count
    }
    
    
    
    
    
    
    
    // разрешение на перетаскивание строк таблицы (изменение порядка строк)
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Disable the buttons by implementing these UITableViewDataSource methods:
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .none
//    }
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    
    
    
    // при изменение порядка строк
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedRow = instances[sourceIndexPath.row]
        instances.remove(at: sourceIndexPath.row)
        instances.insert(movedRow, at: destinationIndexPath.row)
    }
    
    
    
    
    
    /* ====================================*/
    /* ======== Кликнули по ячейке ========*/
    /* ====================================*/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // убираем выделение ячейки
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)!

        // чекаем
        doChekmark(cell, indexPath.row, false)
        
    }
        
    

    
    /// Подсчет отмеченных ячеек
    ///
    /// - Parameter arg: +1/-1
    func counter(_ arg:Int) -> () {
        
        selected += arg
        countTF.text = dict[6]![LANG] + " " + String(selected)
    }
    
    

    
    /// Проверяет и чекает/анчекает ячейки
    ///
    /// - Parameters:
    ///   - cell: ячейка таблицы
    ///   - cellNum: номер ячейки
    ///   - load: флаг, true - при создании ячейки
    func doChekmark(_ cell:UITableViewCell, _ cellNum:Int, _ load:Bool) -> Void {
        
        if statments[cellNum] != nil{
            if load {
                cell.accessoryType = (statments[cellNum] == true) ? .checkmark : .none
            }
            else{
                if (statments[cellNum] == true){
                    cell.accessoryType = .none
                    counter(-1)
                }
                else {
                    cell.accessoryType = .checkmark
                    counter(1)
                }
                statments[cellNum] = !statments[cellNum]!
            }
        }
        else {
            if load {
                cell.accessoryType = .none
            }
            else{
                statments[cellNum] = true
                cell.accessoryType = .checkmark
                counter(1)
            }
        }
    }
    
    
    
    
    
    
    
    // добавляем фунуции к ячейке при свайпе влево
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if searchController.isActive{
            return []
        }
        
        // УДАЛЕНИЕ ячейки
        let del = UITableViewRowAction(style: .default, title: dict[5]![LANG]) {
            (action, indexPath) in
            
            if self.statments[indexPath.row] == true{
                self.counter(-1)
            }
            self.statments.removeValue(forKey: indexPath.row)
            
            self.instances.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            
            
            // удаление с БД
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                
                do {
                    try context.save()
                }
                catch{
                    print("После удаления не удалось сохранить т.к. \(error.localizedDescription)")
                }
            }
        }
        return [del]
    }
            
    
    
    
    
    
    /// Ф-ция заполняющая отфильтрованный массив
    /// - Parameter text:  вводимый текст
    func filterContentFor(searchText text:String){
        
        filteredData = instances.filter{ (friend) -> Bool in
            return (friend.friendName?.lowercased().contains(text.lowercased()))!
        }
    }

    
    
    
    
    /// Выбирает источник отображения в зависимости от того задействована ли  строка поиска
    /// - Parameter indexPath: <#indexPath description#>
    /// - Returns: возвращает ячейку класса Sharedobject
    func friendToDisplay (indexPath:IndexPath) -> Sharedobject{
        
        let friend:Sharedobject
        
        //если активно поле поиска и уже есть введенный текст
        if searchController.isActive && searchController.searchBar.text != ""{
            friend = filteredData[indexPath.row]
        }
        else {
            friend = instances[indexPath.row]
        }
        return friend
    }
    
    
    
 
    

}







extension FriendsVC:UISearchResultsUpdating{
    
    // метод срабатывает при любом изменение в поисковом запросе
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
        
}



// для устранения наезжания строки поиска на таблицу когда фокус был на поиске, а кликнули по таблице
// в этом проекте НЕ БУДЕТ РАБОТАТЬ, т.к. на этом вьюконтроллере нет навбара
extension FriendsVC:UISearchBarDelegate{

    // когда щелкнули на поисковую строку
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    // после того как фокус ушел с поля поиска
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    //    searchController.isActive = false
    
//        searchBar.endEditing(true) // убираем фокус
//        searchController.searchBar.resignFirstResponder() // убираем курсор
//        searchController.searchBar.showsCancelButton = false
    
//    }
  
    
}






































