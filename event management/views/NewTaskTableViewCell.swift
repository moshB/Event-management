//
//  NewTaskTableViewCell.swift
//  event management
//
//  Created by Mosh on 02/05/2021.
//

import UIKit

class NewTaskTableViewCell: UITableViewCell {
    var tasksTableViewController:TasksTableViewController?
    var idCategory:String = ""
    @IBOutlet weak var newTaskTextField: UITextField!
    
    @IBAction func newTaskTextFieldEditingChanged(_ sender: UITextField) {
        saveTaskOutlet.isEnabled = sender.text?.count ?? 0 > 1
    }
    
    @IBAction func cancelTask(_ sender: UIButton) {
        tasksTableViewController?.cancelNewTask(to: idCategory)
    }
    
    @IBOutlet weak var saveTaskOutlet: UIButton!
    
    @IBAction func saveTask(_ sender: UIButton) {
        if let text = newTaskTextField.text , text.count > 1{
            tasksTableViewController?.saveNewTask(to: idCategory, task: text)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
