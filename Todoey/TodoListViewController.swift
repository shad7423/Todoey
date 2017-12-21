//
//  ViewController.swift
//  Todoey
//
//  Created by Shadab Khan on 12/21/17.
//  Copyright © 2017 Shadab Khan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["first","second","third"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Mark--TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
              cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //Mark--TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
    
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
