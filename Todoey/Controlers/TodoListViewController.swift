//
//  ViewController.swift
//  Todoey
//
//  Created by Shadab Khan on 12/21/17.
//  Copyright © 2017 Shadab Khan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

   var itemArray = [Item]()
    //let defaults = UserDefaults.standard
    
    var textField = UITextField()
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.Plist", isDirectory: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        print(dataFilePath!)
        
//        let newitem = Item()
//        newitem.title = "First"
//        itemArray.append(newitem)
//        
//        let newitem1 = Item()
//        newitem1.title = "Second"
//        itemArray.append(newitem1)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
        loadItems()
    }

    //Mark--TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
            let item = itemArray[indexPath.row]
        
              cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //Mark--TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveitems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
  //Mark - Add New Buttons
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        
        let alert = UIAlertController(title: "Add new Todoey item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // textField = textField.text
            print(self.textField.text!)
            
            let newitem = Item()
            newitem.title = self.textField.text!
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
    
    func saveitems() {
        let encoder = PropertyListEncoder()
        
        do {
            let  data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath! )
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error in decoding item \(error)")
            }
        }
    }
    
}

