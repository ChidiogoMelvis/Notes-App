//
//  NotesViewController.swift
//  Notes app
//
//  Created by Mac on 21/04/2023.
//

import UIKit
import CoreData

var notes = [Notes]()

class NotesViewController: UIViewController {
    
    var load = true
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray6
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
   
    lazy var newNoteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add New Note", for: .normal)
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapBtn), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .black
        table.frame = view.bounds
        table.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        return table
    }()
    
    @objc func tapBtn() {
        let vc = EditViewController()
        navigationController?.pushViewController(vc, animated: false)
        navigationController?.navigationBar.tintColor = UIColor.systemGray6
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
        setupFetchData()
    }
    
    // MARK: - This function fetches the data saved by coredata
    func setupFetchData() {
        if (load) {
            load = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let requestData = NSFetchRequest<Notes>(entityName: "Notes")
            do {
                let results: NSArray = try context.fetch(requestData) as NSArray
                for result in results {
                    let note = result as! Notes
                    notes.insert(note, at: 0)
                    saveItems()
                    tableView.reloadData()
                }
            }
            catch {
                print("failed to fetch data")
            }
        }
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(newNoteButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            newNoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            newNoteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newNoteButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: newNoteButton.bottomAnchor, constant: -50),
        ])
    }
}

