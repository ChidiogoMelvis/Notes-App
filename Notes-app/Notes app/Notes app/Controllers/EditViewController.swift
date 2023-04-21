//
//  EditViewController.swift
//  Notes app
//
//  Created by Mac on 21/04/2023.
//

import UIKit
import CoreData

// MARK: - Object properties
class EditViewController: UIViewController, UITextViewDelegate {
    
    var selectedNote: Notes? = nil
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(UIColor.systemGray6, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveDataButton), for: .touchUpInside)
        return button
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .black
        textView.text = "Type something here"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .lightGray
        textView.delegate = self
        textView.isScrollEnabled = true
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textAlignment = NSTextAlignment.justified
        textView.font = UIFont.systemFont(ofSize: 24)
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = .black
        if (selectedNote != nil){
            //descriptionTextView.text = selectedNote?.des
            selectedNote?.desc = descriptionTextView.text
            selectedNote?.date = Date()
        }
    }
    
    // MARK: - This function saves the data through coredata at the tap of the save button
    @objc func saveDataButton() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if (selectedNote == nil){
            let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
            let newNote = Notes(entity: entity!, insertInto: context)
            newNote.desc = descriptionTextView.text
            newNote.date = Date()
            
            do {
                try context.save()
                notes.insert(newNote, at: 0)
                navigationController?.popViewController(animated: true)
            }
            catch {
                print("error")
            }
        }
        else {
            let requestData = NSFetchRequest<Notes>(entityName: "Notes")
            do {
                let results: NSArray = try context.fetch(requestData) as NSArray
                for result in results {
                    let note = result as! Notes
                    if (note == selectedNote) {
                        note.desc = descriptionTextView.text
                        note.date = Date()
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch {
                print("failed to fetch data")
            }
        }
    }
    
    // MARK: - This function changes the textview color text when it starts editing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = UIColor.systemGray6
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = ""
            textView.textColor = .darkGray
        }
    }
    
    // MARK: - Setupviews object properties
    func setupViews() {
        view.addSubview(saveButton)
        view.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 500),
            descriptionTextView.widthAnchor.constraint(equalToConstant: view.frame.width),
        ])
    }
}
