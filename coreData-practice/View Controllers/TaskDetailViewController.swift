//
//  TaskDetailViewController.swift
//  coreData-practice
//
//  Created by Dongwoo Pae on 7/12/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var task: Task? {
        didSet {
            self.updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
        self.toggleSaveButton()
        self.nameTextField.addTarget(self, action: #selector(toggleSaveButton), for: .editingChanged)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let taskName = self.nameTextField.text,
            !taskName.isEmpty else {return}
        
        let notes = self.notesTextView.text
        
        if let task = self.task {
            //Edit existing task
            task.name = taskName
            task.notes = notes
        } else {
            //create a new task
            let _ = Task(name: taskName, notes: notes)
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else {return}
        
        self.title = self.task?.name ??  "Create Task"
        self.nameTextField.text = task?.name
        self.notesTextView.text = task?.notes
    }
    
    @objc private func toggleSaveButton() {
        self.saveButton.isEnabled = !self.nameTextField.text!.isEmpty
    }
}
