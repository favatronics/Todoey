//
//  ViewController.swift
//  Todoey
//
//  Created by Luca Favaron on 19/06/19.
//  Copyright © 2019 Luca Favaron. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    @IBOutlet weak var barraRicerca: UISearchBar!
    
    let realm = try! Realm()        // nova istanza realm
    
    var todoItems: Results<Item>?   // formato realm RESULTS
    
    var categoriaSelezionata : Category? {
        didSet {
            loadItems()
        }
    }
    
    // MARK: - SESION --- funsion viewDidLoad ---
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    //MARK: - SESION --- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        title = categoriaSelezionata?.name
        
        guard let colHex = categoriaSelezionata?.colore else {fatalError("1")}
        
        updateNavBar(withHexCode: colHex)
    }

    //MARK: - SESION --- viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    // MARK: - SEZIONE --- Metodi di setup della Navigation Bar ---
    
    func updateNavBar(withHexCode colourHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("il NavigationBar non esiste!\n")}
        
        guard let coloreNavBar = UIColor(hexString: colourHexCode) else {fatalError("2") }
        
        navBar.barTintColor = coloreNavBar
        navBar.tintColor = ContrastColorOf(coloreNavBar, returnFlat: true)
        barraRicerca.barTintColor = coloreNavBar
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(coloreNavBar, returnFlat: true)]
    }

    // MARK: - SEZIONE --- Metodi di riempimento della tableview ---
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) // ciama tableview(... cellForRow su SwipeTable...
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let colore = UIColor(hexString: categoriaSelezionata!.colore)?
                .darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count))
            {
                cell.backgroundColor = colore
                cell.textLabel?.textColor = ContrastColorOf(colore, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "nessun elemento inserito nella lista \(String(describing: categoriaSelezionata))"
        }
        
        return cell
    }
    
    // MARK: - SEZIONE --- Metodi delegate della tableview ---
    // metodo riga seesionada
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("ERRORE NEL SALVARE LA SPUNTA \(error)")
            }
        }
        tableView.reloadData()
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
                        newItem.dateCreated = Date()
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
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let rigaDaCancear = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(rigaDaCancear)
                }
            } catch {
                print ("ERROR nel cancear a riga \(error)")
            }
        }
    }
    
}

// MARK: - Estension che implementa a barra de ricerca
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    // torna aea lista inissial col tastin x
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
