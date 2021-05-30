//
//  TeamTableViewController.swift
//  event management
//
//  Created by Mosh on 26/05/2021.
//

import UIKit

class TeamTableViewController: UITableViewController {
    
    @IBAction func actionAddUser(_ sender: UIBarButtonItem) {
        //1) let alertVC
        let alertVC = UIAlertController(title: "Add a friend", message: "A valid email of an existing user must be entered", preferredStyle: .alert)
        
        // configure (add text fields)
        alertVC.addTextField { (emailTextField) in
            //set the properties of the text field:
            emailTextField.placeholder = "Email"
            emailTextField.keyboardType = .emailAddress
            
            
            //icon (imageView) right side
            let image = UIImage(systemName: "envelope") //use SFSymbols for system images.
            let imageView = UIImageView(image: image)
            imageView.frame.size = CGSize(width: 20, height: 20)
            
            
            //rightView is hidden by default -> show it:
            emailTextField.rightViewMode = .always
            
            //use the imageview as the right view of the TextField:
            emailTextField.rightView = imageView
        }
        
        // configure (add actions)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            //already dismissed
            
            self.showProgress(title: "work")
            Event.event.addUserToEvent(email: alertVC.textFields?[0].text ?? "") { (err, bool, uid, name) in
                if let err = err{
                    self.showError(title: err.localizedDescription)
                    
                }else if bool{
                    User.user.addEventToUser(uid: uid, eventId: Event.event.id, eventName: Event.event.name) { (err, bool) in
                        if let err = err{
                            self.showError(title: err.localizedDescription)
                        }else if bool{
                            Event.event.eventPartner?[uid] = name
                            self.team.append(name)
                            self.teamId.append(uid)
                            self.showSuccess(title: "\(name) add")
                            self.tableView.reloadData()
                        }else{
                            self.showError(title: "somting dosn't work")
                        }
                    }
                }else{
                    self.showError(title: "somting dosn't work")
                }
            }
        }))
        
        //disable the action
        alertVC.actions[0].isEnabled = false
        
        
        alertVC.textFields?.forEach{
            //target action:
            $0.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        }        
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        
        //2) present VC
        present(alertVC, animated: true)
    }
    
    @objc func textChanged(_ sender: UITextField){
        //1) let alertVC = ...
        //2) present(alertVc)
        guard let alertVC = presentedViewController as? UIAlertController else {return}
        
        
        //get the action from the alert:
        let okAction = alertVC.actions[0]
        
        //get the text from the alertVC
        let email = alertVC.textFields?[0].text ?? ""
        
        okAction.isEnabled = email.isEmail()
    }
    
    
    @IBAction func actionDeleteEvent(_ sender: UIBarButtonItem) {
        //func inside a func
        func takeAction(_ action: UIAlertAction){
            showProgress(title: "Delete Event")
            Event.event.deleteEvent { (err, bool) in
                guard err == nil , bool == true else{
                    self.showError(title: err.debugDescription)
                    return
                }
                self.showSuccess(title: "Delete Complete")
                Router.shared.determineRootViewController()
            }
        }
        
        //show dialog:
        let actionSheetDialog = UIAlertController(title: "Deleting will delete all information under this Event \n Are you sure???",
                                                  message: nil, preferredStyle: .actionSheet)
        actionSheetDialog.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: takeAction))
        actionSheetDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))//nil!
        
        present(actionSheetDialog, animated: true)
    }
    
    @IBAction func actionLeaveTeam(_ sender: UIBarButtonItem) {
        //func inside a func
        let uid = IO.getUid()
        func takeAction(_ action: UIAlertAction){
            Event.event.eventPartner?[uid] = nil
            showProgress(title: "Leave Team")
            Event.event.deleteUserFromEvent(idUser:uid) { (err, bool) in
                guard err == nil , bool == true else{
                    self.showError(title: err.debugDescription)
                    return
                }
                User.user.deleteEventFromUser(uid: uid, eventId: Event.event.id) { (err, bool) in
                    guard err == nil , bool == true else{
                        self.showError(title: err.debugDescription)
                        return
                    }
                    self.showSuccess(title: "Leave Success")
                    Router.shared.determineRootViewController()
                }
            }
        }
        
        //show dialog:
        let actionSheetDialog = UIAlertController(title: "Are you sure you want to leave this team",
                                                  message: nil, preferredStyle: .actionSheet)
        actionSheetDialog.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: takeAction))
        actionSheetDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        present(actionSheetDialog, animated: true)
    }
    
    
    
    var team:[String] = []
    var teamId:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let partner = Event.event.eventPartner{
            for (key, value) in  partner {
                team.append(value)
                teamId.append(key)
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return team.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = team[indexPath.row]
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let tId = teamId[indexPath.row]
            Event.event.deleteUserFromEvent(idUser: tId) { (err, bool) in
                if err == nil && bool{
                    Event.event.eventPartner?[tId] = nil
                    self.team.remove(at: indexPath.row)
                    self.teamId.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
