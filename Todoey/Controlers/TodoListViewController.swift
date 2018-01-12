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

class TodoListViewController: UITableViewController{

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
        
        
    }

    //MARK: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSLocalizedString("ToDoItemCell", comment: ""), for: indexPath)
        
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

