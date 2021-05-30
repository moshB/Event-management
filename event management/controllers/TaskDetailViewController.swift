//
//  TaskDetailViewController.swift
//  event management
//
//  Created by Mosh on 03/05/2021.
//

import UIKit

class TaskDetailViewController: UIViewController {

    var idCategory = ""
    var idTask = ""
    var task:Task?
    
    var isFinish = false
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        
        sender.isEnabled = false
        
        guard let _ = task else {
            showError(title: "task does not exist")
            sender.isEnabled = false
            return
        }
        
        guard let id = task?.id else{
         return
        }
        guard let budget:Int = Int(budgetTaskTextField.text ?? "0") else{
            self.showError(title: "Budget must be a number!")
            sender.isEnabled = true
         return
        }
        guard let name = nameTaskTextField.text else{
            self.showError(title: "Task need a name!")
            sender.isEnabled = true
         return
        }
        guard name.count > 1 else {
            self.showError(title: "Task need a name longer then one")
            sender.isEnabled = true
            return
        }
        
        let note = noteTextField.text ?? ""
        
        let task = Task(id: id, name: name, note: note, budget: budget , done: isFinish)
        self.task = task
        showProgress(title: "Save")
        Event.event.editTask(idCateg: idCategory, task: task, idTask: nil, isFinish: nil) { [weak self](err, bool) in
            if let err = err{                self?.showError(title: "Error!", subtitle: err.localizedDescription)
                sender.isEnabled = true
            }else if bool{
                //TODO:- update event.categorys.tasks.task local
                Event.event.categorys[self?.idCategory ?? ""]?.tasks[self?.idTask ?? ""] = task
                self?.showSuccess(title: "Done!")
                sender.isEnabled = true
            }else{
                self?.showError(title: "Error!")
                sender.isEnabled = true
            }
        }        
    }
    
    
    @IBOutlet weak var nameTask: UINavigationItem!
    @IBOutlet weak var finishBarButtonItemOutlet: UIBarButtonItem!
    @IBAction func finishBarButtonItem(_ sender: UIBarButtonItem) {
        if isFinish{
            isFinish = false
        sender.setBackgroundImage(UIImage(systemName: "circle"), for: .normal, barMetrics: .default)
        }else{
            isFinish = true
            sender.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal, barMetrics: .default)
        }
    }
    
    @IBOutlet weak var nameTaskTextField: UITextField!
    @IBOutlet weak var budgetTaskTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        paintViews()
        
    }

    func paintViews(){
        if let category:Category = Event.event.categorys[idCategory],
           let task:Task = category.tasks[idTask] {
            self.task = task
            nameTaskTextField.text = task.name
            nameTask.title = task.name
            budgetTaskTextField.text = "\(task.budget)"
            noteTextField.text = task.note
            if task.done{
                isFinish = true
                finishBarButtonItemOutlet.setBackgroundImage(UIImage(systemName: "circle.fill"), for: .normal, barMetrics: .default)
            }else{
                isFinish = false
                finishBarButtonItemOutlet.setBackgroundImage(UIImage(systemName: "circle"), for: .normal, barMetrics: .default)
            }
        }
    }
}
