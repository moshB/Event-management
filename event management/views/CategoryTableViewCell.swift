//
//  CategoryTableViewCell.swift
//  event management
//
//  Created by Mosh on 23/02/2021.
//


//class for View a single Category


import UIKit

class CategoryTableViewCell: UITableViewCell {

    var idCategory:String = ""
    var tasksTableViewController:TasksTableViewController?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var budgetLabel: UILabel!

    @IBOutlet weak var myView: UIView!
    var textField:UITextField = UITextField()
    var btnAddTaskToCategory:UIButton = UIButton()
 
    @IBAction func btnAddTask(_ sender: UIButton) {
        tasksTableViewController?.addCellToNewTask(to: idCategory)
    }
    
    @IBAction func btnDeleteCategory(_ sender: UIButton) {
    }
    
    @IBOutlet weak var imageViewCross: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        
    }
//    func addTask(callback:@escaping (String)->Void){
//        callback(idCategory)
//    }
    
}
