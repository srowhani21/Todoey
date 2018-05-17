//
//  ViewController.swift
//  Todoey
//
//  Created by Salar Rowhani on 5/4/18.
//  Copyright © 2018 Salar Rowhani. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

//    let defaults = UserDefaults.standard
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first\
//        print(dataFilePath!)
        // Do any additional setup after loading the view, typically from a nib.
        
//        let newItem1 = Item()
//        newItem1.title = "Test1"
//        itemArray.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "Test2"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Test3"
//        itemArray.append(newItem3)
        
     
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("dd \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
//        Ternary Operator
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
//        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // Something will occurr once the action Button is pressed
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveItem()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
        
    }
    func saveItem () {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding itemArray \(error)" )
        }
        
        self.tableView.reloadData()
    }
    func loadData (){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
                
            }catch{
                print ("Error decodig from data\(error)")
            }

        }
    }
}

