//
//  EventsTableViewController.swift
//  event management
//
//  Created by Mosh on 21/02/2021.
//

import UIKit
import FirebaseAuth

class EventsTableViewController: UITableViewController {
    
    var ids:[String] = []
    var dict:[String:String] = [:]
    
    //user log out with actionSheetDialog
    @IBAction func exitUser(_ sender: UIBarButtonItem) {
        
        //func inside a func
        func takeAction(_ action: UIAlertAction){
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                Router.shared.determineRootViewController()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }

        //show dialog:
        let actionSheetDialog = UIAlertController(title: "Are you sure you want to SingOut?",
                                                  message: nil, preferredStyle: .actionSheet)
        actionSheetDialog.addAction(UIAlertAction(title: "Sing Out", style: .destructive, handler: takeAction))
        actionSheetDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))//nil!
        
        present(actionSheetDialog, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ids = []
        dict = [:]
        User().getMyEvents {[weak self] (err, dict) in
            if let _ = err{
                self?.showError(title: "Unable to import events")
                return
            }
            guard let dict = dict else{return}
            self?.dict = dict
            self?.ids.removeAll()
            for (key, _) in dict{
                self?.ids.append(key)
            }
            self?.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ids.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let cell = cell as? EventTableViewCell{
            let id = ids[indexPath.row]
            let name = dict[id] ?? ""
            cell.populate(id: id, name: name)
        }
        
        // Configure the cell...
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //todo if
        Router.shared.eventId = ids[indexPath.row]
        Router.shared.eventMenagerViewController(name: "EventMenager") 
    }
    
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     
    
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
        let ide = ids[indexPath.row]
       
        User.user.deleteEventFromUser(uid: IO.getUid(), eventId: ide) { (err, bool) in
            self.dict[ide] = nil
            self.ids.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
     // Delete the row from the data source
     
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
   
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
