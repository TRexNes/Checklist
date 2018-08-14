//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Rex Nesbit on 8/3/18.
//  Copyright © 2018 Rex Nesbit. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

    var checklist: Checklist!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Disable large titles for this view controller
        navigationItem.largeTitleDisplayMode = .never
        title = checklist.name
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated:true)
        
    }
    
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated:true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                             sender: Any?) {
        // 1
        if segue.identifier == "AddItem" {
            // 2
            let controller = segue.destination
                as! ItemDetailViewController
            // 3
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
        let controller = segue.destination
            as! ItemDetailViewController
        controller.delegate = self
        
        if let indexPath = tableView.indexPath(
            for: sender as! UITableViewCell) {
            controller.itemToEdit = checklist.items[indexPath.row]
        }
    }
}
   
/**********************
 * These methods take two parameters and return a value.
 * They are responsible for changing the cells in the
 * tableView
 ****************************/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection nunumberOfRowsInSection: Int) -> Int {
        return checklist.items.count
    }
    // This method sets the cell view to the data row
    override func tableView(_ tableView: UITableView,
                               cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ChecklistItem",
                for: indexPath)
            
            let item = checklist.items[indexPath.row]
            
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
            
            return cell
    }
    
    // Row selection toggles checkmark
    override func tableView(_ tableView: UITableView,
                               didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
        
        let item = checklist.items[indexPath.row]
            
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    //Swipe to delete
    override func tableView(_ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath) {
        // 1
        checklist.items.remove(at: indexPath.row)
        
        // 2
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
    }
    
    func configureCheckmark(for cell: UITableViewCell,
                               with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell,
                          with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        //label.text = item.text
        label.text = "\(item.text)"
    }
    

    
}

