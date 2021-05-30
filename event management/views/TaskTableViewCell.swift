//
//  TaskTableViewCell.swift
//  event management
//
//  Created by Mosh on 23/02/2021.
//

//class for View a single Task


import UIKit

class TaskTableViewCell: UITableViewCell {
    var isFinish = false
    var tasksTableViewController:TasksTableViewController?
    var idCategory = ""
    var idTask = ""
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var budgetLubel: UILabel!
    
    @IBOutlet weak var btnFinishOutlet: UIButton!
    
    @IBAction func btnFinish(_ sender: UIButton) {
       
        if isFinish{
            isFinish = false
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
            self.showProgress(title: "Not Finish")
        }else{
            isFinish = true
            sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            self.showProgress(title: "Finish")
        }
        Event.event.categorys[idCategory]?.tasks[idTask]?.done = isFinish
        sender.isEnabled = false
        
        Event.event.editTask(idCateg: idCategory, task: nil, idTask: idTask, isFinish: isFinish) { [weak self](err, bool) in
            if let err = err{
                self?.showError(title: "Error!", subtitle: err.localizedDescription)
                sender.isEnabled = true
            }else if bool{
                self?.showSuccess(title: "Done!")
                sender.isEnabled = true
            }
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
