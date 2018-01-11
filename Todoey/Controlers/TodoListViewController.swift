//
//  ViewController.swift
//  Todoey
//
//  Created by Shadab Khan on 12/21/17.
//  Copyright © 2017 Shadab Khan. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{

   var itemArray = [Item]()
    //let defaults = UserDefaults.standard
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    var textField = UITextField()
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.Plist", isDirectory: true)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        loadItems()
        
        
    }

    //MARK: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSLocalizedString("ToDoItemCell", comment: ""), for: indexPath)
        
            let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.tittle
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
       // context.delete(itemArray[indexPath.row])
       // itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveitems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add New Buttons
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        
        let alert = UIAlertController(title: "Add new Todoey item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // textField = textField.text
            print(self.textField.text!)
            
            
            
            let newitem = Item(context: self.context)
            newitem.tittle = self.textField.text!
            newitem.done = false
            newitem.parrentCategory = self.selectedCategory
            self.itemArray.append(newitem)
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveitems()
            
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
    func saveitems() {
        
        do {
            try context.save()
        } catch {
            print("Error Saving Context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parrentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let  additional = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates : [categoryPredicate,predicate!])
            request.predicate = compoundPredicate
            } else {
            request.predicate = categoryPredicate
            }
        
        do {
        itemArray =  try context.fetch(request)
        } catch {
            print("Error in Fething data from context, \(error)")
        }
        tableView.reloadData()
    }
    
    
}
//MARK: - Extension of class

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
       let predicate = NSPredicate(format: "tittle CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "tittle", ascending: true)]
        
        loadItems(with: request ,predicate: predicate)
        
    
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

