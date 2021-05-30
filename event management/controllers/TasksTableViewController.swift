//
//  TasksTableViewController.swift
//  event management
//
//  Created by Mosh on 23/02/2021.
//

import UIKit


class TasksTableViewController: UITableViewController {
    
    var event: Event?
    var idCategory:String?
    var idTask:String?

    //MARK: objctive-C functionthat check the text field
    @objc func textChanged(_ sender: UITextField){
        
        guard let alertVC = presentedViewController as? UIAlertController else {return}
        //get the action from the alert:
        let okAction = alertVC.actions[0]
        
        //get the text from the alertVC
        let category = alertVC.textFields?[0].text ?? ""
        let task = alertVC.textFields?[1].text ?? ""
        
        okAction.isEnabled = category.count > 1 && task.count > 1
    }
    
    
    // open dialog view for new category
    
    @IBAction func addViewCategory(_ sender: UIBarButtonItem) {
        
        //1) let alertVC
        let alertVC = UIAlertController(title: "Add new Category", message: "category and first task", preferredStyle: .alert)
        
        // configure (add text fields)
        alertVC.addTextField { (categorylTextField) in
            //set the properties of the text field:
            categorylTextField.placeholder = "Category name"
            categorylTextField.keyboardType = .default
            
            
            //icon (imageView) right side
            let image = UIImage(systemName: "questionmark.folder") //use SFSymbols for system images.
            let imageView = UIImageView(image: image)
            imageView.frame.size = CGSize(width: 20, height: 20)
            
            
            //rightView is hidden by default -> show it:
            categorylTextField.rightViewMode = .always
            
            //use the imageview as the right view of the TextField:
            categorylTextField.rightView = imageView
        }
        
        // configure (add text fields)
        alertVC.addTextField { (taskTextField) in
            //set the properties of the text field:
            taskTextField.placeholder = "Task name"
            
            //icon (imageView) right side
            let image = UIImage(systemName: "doc.text") //use SFSymbols for system images.
            let imageView = UIImageView(image: image)
            imageView.frame.size = CGSize(width: 20, height: 20)
            
            
            //rightView is hidden by default -> show it:
            taskTextField.rightViewMode = .always
            
            //use the imageview as the right view of the TextField:
            taskTextField.rightView = imageView
           
        }
        
        // configure (add actions)

        alertVC.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            //already dismissed
            
            let task = Task(name: alertVC.textFields?[1].text ?? "" )
            let category = Category(name: alertVC.textFields?[0].text ?? "" , tasks: [task.id: task])
            
            self.event?.addCategory(category: category) {[weak self] (err, bool) in
                if let err = err{
                    self?.showError(title: err.localizedDescription)
                }
                self?.event?.categorys[category.id] = category
//                categorys.append(category.id)
                self?.categTasks[category.id] = []
                self?.showSuccess(title: "Done!")
                self?.tableView.reloadData()
                
                
            }
        }))

        //disable the action
        alertVC.actions[0].isEnabled = false
        
        //target action to the textfields:

        alertVC.textFields?.forEach{
            //target action:
            $0.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        }
        
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in

        }))
        
        //2) present VC
        present(alertVC, animated: true)
        
    }
    
    
    
    
    var categorys:[String]{
        var categorys:[String] = []
        
        for (key, _) in event?.categorys ?? [:]{
            categorys.append(key)
        }
        return categorys
    }
    var categTasks:[String:[String]] = [:]
    func getItemByIndex(indexPath:Int)->(String?, String?){
        var index = 0
        let indexPath = indexPath + 1
        if index == indexPath {
            return (nil, nil)
        }
        
        for idCateg in categorys{
            index += 1
            if index == indexPath {
                return (idCateg, nil)
            }
            for task in categTasks[idCateg] ?? [] {
                index += 1
                if index == indexPath {
                    return (idCateg, task)
                }
            }
        }
        
        return (nil,nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        event = Event.event
        
        for category in categorys{
            categTasks[category] = []
        }
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: .main), forCellReuseIdentifier: "categoryCell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count = categorys.count
        for (_, task) in categTasks{
            count += task.count
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let (categ, tas) = getItemByIndex(indexPath: indexPath.row)
                
        if tas == "newTask", categ != nil{
            tableView.register(UINib(nibName: "NewTaskTableViewCell", bundle: .main), forCellReuseIdentifier: "newTaskCell")
            
            cell = tableView.dequeueReusableCell(withIdentifier: "newTaskCell", for: indexPath)
            
        }else if tas != nil, categ != nil{
            tableView.register(UINib(nibName: "TaskTableViewCell", bundle: .main), forCellReuseIdentifier: "taskCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        }
        
        if let cell = cell as? TaskTableViewCell,
           let category:Category = event?.categorys[categ!],
           let task =  category.tasks[tas!]{
            cell.idCategory = categ ?? ""
            cell.idTask = tas ?? ""
            cell.tasksTableViewController = self
            cell.budgetLubel.text = task.budget.description
            cell.titleLabel.text = task.name
            if task.done{
                cell.btnFinishOutlet.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            }else{
                cell.btnFinishOutlet.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
        
        if let cell = cell as? CategoryTableViewCell{
            if categ != nil{
                cell.idCategory = categ ?? ""
                cell.titleLabel.text = Event.event.categorys[categ!]?.name
                var budget = 0
                let tasks:[String : Task]? = Event.event.categorys[categ!]?.tasks
                for (_, task) in tasks ?? [:]{
                    budget += task.budget
                }
                cell.budgetLabel.text = "\(budget)"
                cell.tasksTableViewController = self
            }
        }
        if let cell = cell as? NewTaskTableViewCell{
            cell.tasksTableViewController = self
            cell.idCategory = categ ?? ""
            cell.newTaskTextField.text = ""
            cell.saveTaskOutlet.isEnabled = false

            let category = Event.event.categorys[categ!]?.name ?? ""
            cell.newTaskTextField.placeholder = "add task to category \(category)"
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let (categ, tas) = getItemByIndex(indexPath: indexPath.row)
        
        guard categ != nil else {
            return nil
        }
        
        guard tas != "newTask"  else{
            return nil
        }
        guard tas == nil  else{
            idTask = tas
            idCategory = categ
            performSegue(withIdentifier: "taskDetail", sender: self)
            return nil
        }
        
        if categTasks[categ!] == []{
            var tasks:[String] = []
            for (key, _) in event?.categorys[categ!]?.tasks ?? [:]{
                tasks.append(key)
            }
            
            categTasks[categ!] = tasks
            
            tableView.reloadData()
        }else{
            categTasks[categ!] = []
            
            tableView.reloadData()
        }
        return nil
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteCell(index: indexPath.row)
            
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}




//MARK:- extension
extension TasksTableViewController{
// delete cell of category or cell of task
    func deleteCell(index: Int) {
        let (categor, idTask) = getItemByIndex(indexPath: index)
        if let idCat = categor, let idTask = idTask{
            //func inside a func
            func takeAction(_ action: UIAlertAction){
                event?.deleteTask(idCateg: idCat, idTask: idTask)
                event?.categorys[idCat]?.tasks[idTask] = nil
                categTasks[idCat]?.removeAll()
                tableView.reloadData()
            }

            //show dialog:
            let actionSheetDialog = UIAlertController(title: "Deleting will delete all information under this task",
                                                      message: nil, preferredStyle: .actionSheet)
            actionSheetDialog.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: takeAction))
            actionSheetDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))//nil!
            
            present(actionSheetDialog, animated: true)
        
        }
        if let idCat = categor, idTask == nil{
            //func inside a func
            func takeAction(_ action: UIAlertAction){
                event?.deleteCategory(idCateg: idCat)
                event?.categorys[idCat] = nil
                categTasks[idCat] = nil
                tableView.reloadData()
            }

            //show dialog:
            let actionSheetDialog = UIAlertController(title: "Deleting will delete all information under this category",
                                                      message: nil, preferredStyle: .actionSheet)
            actionSheetDialog.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: takeAction))
            actionSheetDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))//nil!
            
            present(actionSheetDialog, animated: true)
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? TaskDetailViewController else {
            return
        }
        dest.idTask = idTask ?? ""
        dest.idCategory = idCategory ?? ""
    }
//    Delegate Pattern
    func addCellToNewTask(to category:String) {
            self.categTasks[category]?.append("newTask")
            self.tableView.reloadData()
    }
    
    func cancelNewTask(to category:String) {
        guard let index = self.categTasks[category]?.firstIndex(of: "newTask") else {return}
        self.categTasks[category]?.remove(at: index)
            self.tableView.reloadData()
    }
    //saving new base task just with name and defult value
    func saveNewTask(to category:String, task:String) {
        let task = Task(name: task)
        self.showProgress( title: "add Task")
        Event.event.addTask(task: task, categoryId: category){ [ self](err, bool) in
            if err != nil{
                self.showError(title: err.debugDescription)
            }
            self.event?.categorys[category]?.tasks[task.id] = task
            
            var tasks:[String] = []
            for (key, _) in self.event?.categorys[category]?.tasks ?? [:]{
                tasks.append(key)
            }
            
            self.categTasks[category] = []
            self.categTasks[category] = tasks
            
            self.tableView.reloadData()
            self.showSuccess(title: "Done!")
        }
        
            self.categTasks[category]?.append("newTask")
            self.tableView.reloadData()
    }
}
