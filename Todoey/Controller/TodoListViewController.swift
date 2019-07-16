//
//  ViewController.swift
//  Todoey
//
//  Created by Luca Favaron on 19/06/19.
//  Copyright © 2019 Luca Favaron. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    // path del file dove memorizzo i elementi dea lista
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - SESION --- funsion viewDidLoad ---
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadItems()
    }

    // MARK: - SEZIONE --- Metodi di riempimento della tableview ---
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // se fatto (item.done == true) metto a spunta altrimenti gnente
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - SEZIONE --- Metodi delegate della tableview ---
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // cambia el segno de spunta quando seesionemo na riga
        
        saveItems() // salva el segno de spunta
       
        tableView.deselectRow(at: indexPath, animated: true) // assa a riga no evidenziada
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
            
            //con CoreData
            let newItem = Item(context: self.context)
            newItem.title = elementoNovo.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            // salvemo a lista
            self.saveItems()
            
        }
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "zonta novo elemento"
            elementoNovo = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    
    // MARK: - SEZIONE - metodi de manipoeasion del model
    // Salva i elementi dea lista
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("casso error nel salvar el context")
        }
        self.tableView.reloadData()     // fa el refresh dea tabea
    }
    
    /*
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("ERRORE DECODIFICA ARRAY ITEMS \(error)")
            }
        } else {
            print("casso")
        }
    }*/
    
}

