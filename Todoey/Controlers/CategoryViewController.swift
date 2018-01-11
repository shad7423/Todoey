//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Shadab Khan on 1/9/18.
//  Copyright © 2018 Shadab Khan. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadcategories()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(){
        
        do{
            try context.save()
        } catch {
            print("Error in saving categories, \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadcategories(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
        categories = try context.fetch(request)
        } catch {
            print("Error in loading categories,\(error)")
        }
        tableView.reloadData()
    }
   
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
        
        let alert = UIAlertController(title: "Add New Categories", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = self.textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
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
            destinationVC.selectedCategory = categories[indexpath.row]
        }
    }
    
}
