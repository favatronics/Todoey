//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Luca Favaron on 02/08/19.
//  Copyright © 2019 Luca Favaron. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70.0  // Altezza righe tabea
    }
    
    // MARK: - TableView metodi datasource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Scancea") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)

        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "cestino")
        
        return [deleteAction]
    }
        
    // opzione che permette di cancear swippando a riga senza cliccar sul cestino
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
            var options = SwipeTableOptions()
            options.expansionStyle = .destructive
            return options
    }
    
    //update del db
    func updateModel(at indexPath: IndexPath) {
        // update del database (realm) --> vien sovrascritta dopo pa scancear a riga
    }
}

