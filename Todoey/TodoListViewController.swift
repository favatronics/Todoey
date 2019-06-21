//
//  ViewController.swift
//  Todoey
//
//  Created by Luca Favaron on 19/06/19.
//  Copyright © 2019 Luca Favaron. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["remedios", "beijos", "abraços"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: - SEZIONE --- Metodi di riempimento della tableview ---
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - SEZIONE --- Metodi delegate della tableview ---
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        //print(itemArray[indexPath.row])
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)    // cava a seesion
    }
    
     // MARK: - SEZIONE --- aggiungi elementi ---
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        var elementoNovo = UITextField()
        
        //print("aggiungi")
        let alert = UIAlertController(title: "AGGIUNGI", message: "un nuovo elemento alla lista", preferredStyle: .alert)
        let action = UIAlertAction(title: "ZONTA", style: .default) {
            (alert) in
            // Codice eseguio quando selesionà el botton +
            //print(elementoNovo.text!)
            self.itemArray.append(elementoNovo.text!)
            self.tableView.reloadData()     // fa el refresh dea tabea
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "zonta novo elemento"
            elementoNovo = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    
}

