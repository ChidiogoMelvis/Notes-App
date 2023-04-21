//
//  Extension+NotesViewController.swift
//  Notes app
//
//  Created by Mac on 21/04/2023.
//

import Foundation
import UIKit
import CoreData

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as! NoteTableViewCell
        cell.backgroundColor = .black
        cell.descriptionLabel.textColor = UIColor.systemGray
        let noteText: Notes!
        noteText = notes[indexPath.row]
        cell.descriptionLabel.text = noteText.desc
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            //MARK: - remove object from core data
            context.delete(notes[indexPath.row] as NSManagedObject)
            saveItems()
            
            //MARK: - update UI methods
            tableView.beginUpdates()
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            appDelegate.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        let indexPath = tableView.indexPathForSelectedRow
        let noteDetail = EditViewController()
        let selectedNote: Notes!
        selectedNote = notes[indexPath!.row]
        noteDetail.selectedNote = selectedNote
        tableView.deselectRow(at: indexPath!, animated: true)
        navigationController?.pushViewController(noteDetail, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}



