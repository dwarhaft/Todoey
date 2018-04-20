//
//  ViewController.swift
//  Todoey
//
//  Created by David Warhaft on 2018-03-06.
//  Copyright © 2018 David Warhaft. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    
     var itemArray = [Item]()
    
    let DataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //print(DataFilePath)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.

        loadItems()
    }

    //MARK - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none //replaces below ternary operator
        
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }
     //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //this row replaces all the code below
        saveItems()
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    //MARK Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
           
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print(alertTextField.text!)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    func saveItems () {
        let encoder = PropertyListEncoder()
        do {
            
            let data =  try encoder.encode(itemArray)
            try data.write(to: DataFilePath!)
        } catch {
            print("Error encoding item array,  \(error)")
        }
        self.tableView.reloadData()
        
    }
    func loadItems() {
        if let data = try? Data(contentsOf: DataFilePath!){
            let decoder = PropertyListDecoder()
            do
            {            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array \(error)")
            }
            
        }
    }

}




