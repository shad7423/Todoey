//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shadab Khan on 1/9/18.
//  Copyright © 2018 Shadab Khan. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
//import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    var textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadcategories()
        
        tableView.rowHeight = 75.0
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Not Added yet any new categories"
      //  tableView.separatorStyle = .none
       // cell.backgroundColor = UIColor.flatYellow
        cell.backgroundColor = UIColor(hexString : (categories?[indexPath.row].colour) ?? "1D9BF6")
        if let colour = UIColor(hexString :(categories![indexPath.row].colour)){
        cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
       }
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category:Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error in saving categories, \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadcategories(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
   
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
        
        let alert = UIAlertController(title: "Add New Categories", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = self.textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
           self.tableView.reloadData()
            
        }
        
        
        
        alert.addTextField { (field) in
            self.textField = field
            self.textField.placeholder = "Add New Categories!"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexpath.row]
        }
    }
    

//MARK: - delete data from swipe

    override func updateModel(at indexpath:IndexPath){
        if let CategoryDeletion = self.categories?[indexpath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(CategoryDeletion)
                    //item.done = !item.done
                }
            }catch{
                print("Erron saving done status,\(error)")
            }
            // tableView.reloadData()
        }

    }

}
//MARK: - Swipe Table Delegate Methods

//extension CategoryViewController: SwipeTableViewCellDelegate {
//    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//        
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//            if let categoryDeletion = self.categories?[indexPath.row]{
//                do{
//                    try self.realm.write {
//                        self.realm.delete(categoryDeletion)
//                        //item.done = !item.done
//                    }
//                }catch{
//                    print("Erron saving done status,\(error)")
//                }
//                //tableView.reloadData()
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
//    
//    
//}

