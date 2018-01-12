//
//  ViewController.swift
//  Todoey
//
//  Created by Shadab Khan on 12/21/17.
//  Copyright © 2017 Shadab Khan. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
//import SwipeCellKit

class TodoListViewController: SwipeTableViewController{

    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    var textField = UITextField()
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.Plist", isDirectory: true)
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
       loadItems()
        
        tableView.rowHeight = 75.0
        
        
    }

    //MARK: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if  let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.tittle
        
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "Not added yet any item"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                   // realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Erron saving done status,\(error)")
            }
        }
       // context.delete(todoItems[indexPath.row])
       // todoItems.remove(at: indexPath.row)
        
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add New Buttons
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {



        let alert = UIAlertController(title: "Add new Todoey item", message: " ", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // textField = textField.text
            print(self.textField.text!)


            if let currentCategory = self.selectedCategory {
                self.save(currentCategory: currentCategory)
            }

            

            self.tableView.reloadData()
            print("success")

        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            self.textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)


    }

    //MARK :- functions
    func save(currentCategory:Category) {

        do {
            try realm.write {
                let newitem = Item()
                newitem.tittle = self.textField.text!
                newitem.dateCreated = Date()
                currentCategory.items.append(newitem)
            }
        } catch {
            print("Error Saving Context, \(error)")
        }
        self.tableView.reloadData()
    }

    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "tittle", ascending: true)
        
        
        tableView.reloadData()
    }
//MARK: - delete data from swipe
    
    override func updateModel(at indexpath:IndexPath){
        if let itemDeletion = self.todoItems?[indexpath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemDeletion)
                    //item.done = !item.done
                }
            }catch{
                print("Erron saving done status,\(error)")
            }
            // tableView.reloadData()
        }
        
    }

}
//MARK: - Extension of class

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("tittle CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

}

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    
    
}



//MARK: - Swipe Table Delegate Methods

//extension TodoListViewController: SwipeTableViewCellDelegate {
//    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//        
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//            if let itemDeletion = self.todoItems?[indexPath.row]{
//                do{
//                    try self.realm.write {
//                        self.realm.delete(itemDeletion)
//                        //item.done = !item.done
//                    }
//                }catch{
//                    print("Erron saving done status,\(error)")
//                }
//               // tableView.reloadData()
//            }
//        }
//        
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
//        
//        return [deleteAction]
//    }
//    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
//        var options = SwipeTableOptions()
//        options.expansionStyle = .destructive
//        //options.transitionStyle = .border
//        return options
//    }
//}

