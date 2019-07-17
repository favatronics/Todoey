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
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - SESION --- funsion viewDidLoad ---
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
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
    
    // func loadItems
    // param esterno --> con
    // param interno --> richiesta
    // e valore di default --> Item.fetchRequest()
    //
    func loadItems(con richiesta: NSFetchRequest<Item> = Item.fetchRequest()) {
        //let richiestaDati : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(richiesta)
        } catch {
            print("ERRORE RICHIESTA DATI \(error)")
        }
        
        tableView.reloadData()
    }
    
}


// Estension che implementa a barra de ricerca
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let richiestaDati : NSFetchRequest<Item> = Item.fetchRequest()
        richiestaDati.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)//cd non tiene conto maiuscole, accenti etc
        
        richiestaDati.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(con: richiestaDati)
    }
    
    // torna aea lista inissial
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //richiesta sul main thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // non più barra selezionata
            }
            
        }
    }
}
