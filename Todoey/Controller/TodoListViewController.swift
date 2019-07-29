//
//  ViewController.swift
//  Todoey
//
//  Created by Luca Favaron on 19/06/19.
//  Copyright © 2019 Luca Favaron. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm()        // nova istanza realm
    
    var todoItems: Results<Item>?   // formato realm
    
    var categoriaSelezionata : Category? {
        didSet {
            loadItems()
        }
    }
    
    // MARK: - SESION --- funsion viewDidLoad ---
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - SEZIONE --- Metodi di riempimento della tableview ---
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            // se fatto (item.done == true) metto a spunta altrimenti gnente
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "nessun elemento inserito nella lista \(String(describing: categoriaSelezionata))"
        }
        
        return cell
    }
    
    // MARK: - SEZIONE --- Metodi delegate della tableview ---
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        todoItems?[indexPath.row].done = !todoItems?[indexPath.row].done   // cambia el segno de spunta quando seesionemo na riga
//
//        saveItems() // salva el segno de spunta
       
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
            
            if let currentCategory = self.categoriaSelezionata {
                // salvemo a lista
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = elementoNovo.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print ("ERRORE NEL SALVARE GLI ITEMS \(error)")
                }
            }
            self.tableView.reloadData()
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
    
    // func loadItems
    func loadItems() {
        todoItems = categoriaSelezionata?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
//    }
    
}

// MARK: - Estension che implementa a barra de ricerca
//extension TodoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let richiestaDati : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate =  NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)//cd non tiene conto maiuscole, accenti etc
//
//        richiestaDati.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(con: richiestaDati, predicato: predicate)
//    }
//
//    // torna aea lista inissial col tastin x
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            //richiesta sul main thread
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder() // non più barra selezionata
//            }
//
//        }
//    }
}
