//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Luca Favaron on 19/07/19.
//  Copyright © 2019 Luca Favaron. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()        // se pol far ! perché già attivo el realm

    var categoriesArray: Results<Category>?                  // array dee categorie in formto Realm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()        // Carica i dati salvati SQLite
    }
    
    // MARK: - Aggiungi nova categoria ----
    @IBAction func strucaBoton(_ sender: UIBarButtonItem) {
        var categoriaNova = UITextField()
        
        let alert = UIAlertController(title: "AGGIUNGI", message: "NUOVA CATEGORIA", preferredStyle: .alert)
        let action = UIAlertAction(title: "ZONTA", style: .default) {
            (alert) in
                let newCategory = Category()
                newCategory.name = categoriaNova.text!
                self.save(category: newCategory)   // salvemo a lista categorie
        }
        
        alert.addAction(action)
        
        alert.addTextField {(field) in
            field.placeholder = "zonta nova categoria"
            categoriaNova = field
        }
        
        present(alert, animated: true,completion: nil)
    }
    
    // MARK: - TableView: metodi datasouce ----
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1          // se no nil ritorna 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "Nessuna categoria è stata inserita"
        return cell
    }
    
    // MARK: - TableView: metodi delegate ----
    
    // metodo che agisce sulla riga selezionata
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)  // lancia il segue alla vista Elementi
        //tableView.deselectRow(at: indexPath, animated: true) // assa a riga no evidenziada
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinassionVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinassionVC.categoriaSelezionata = categoriesArray?[indexPath.row]
        }
    }
    
    // MARK: - TableView: metodi manipolazione dei dati ----
    func loadCategories() {
        categoriesArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("casso error nel salvar e categorie \(error)")
        }
        tableView.reloadData()    // fa el refresh dea tabea
    }
}
