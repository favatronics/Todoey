//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Luca Favaron on 19/07/19.
//  Copyright © 2019 Luca Favaron. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoriesArray = [Category]()                  // array dee categorie
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext   // el context
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()        // Carica i dati salvati SQLite
    }
    
    // MARK: - Aggiungi nova categoria
    @IBAction func strucaBoton(_ sender: UIBarButtonItem) {
        var categoriaNova = UITextField()
        
        let alert = UIAlertController(title: "AGGIUNGI", message: "NUOVA CATEGORIA", preferredStyle: .alert)
        let action = UIAlertAction(title: "ZONTA", style: .default) {
            (alert) in
                let newCategory = Category(context: self.context)
                newCategory.nome = categoriaNova.text!
            
                self.categoriesArray.append(newCategory)
                self.saveCategories()   // salvemo a lista categorie
        }
        
        alert.addAction(action)
        
        alert.addTextField {(field) in
            field.placeholder = "zonta nova categoria"
            categoriaNova = field
        }
        
        present(alert, animated: true,completion: nil)
    }
    
    // MARK: - TableView: metodi datasouce
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].nome
        
        return cell
    }
    
    
    
    
    // MARK: - TableView: metodi delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true) // assa a riga no evidenziada
    }
    
    // MARK: - TableView: metodi manipolazione dei dati
    func loadCategories() {
        let richiesta : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoriesArray = try context.fetch(richiesta)
        } catch {
            print("ERRORE RICHIESTA DATI \(error)")
        }
        tableView.reloadData()
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("casso error nel salvar e categorie \(error)")
        }
        tableView.reloadData()    // fa el refresh dea tabea
    }
}
