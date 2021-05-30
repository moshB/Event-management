//
//  PKHUD+extensions.swift
//  event management
//
//  Created by Mosh on 17/02/2021.
//

import UIKit
import PKHUD

//PKHUD:
//validate email -> show error if not valid
//validate password -> show error if not valid
protocol ShowHUD {
    //list of abstract methods
    //properties
    //protocol extensions for default implementation
}
extension ShowHUD{
    func showProgress(title:String, subtitle: String? = nil){
        HUD.show(.labeledProgress(title: title, subtitle: subtitle))
    }
    
    func showError(title:String, subtitle: String? = nil){
        HUD.flash(.labeledError(title: title, subtitle: subtitle), delay: 3)
    }
    
    func showLabel(title:String){
        HUD.flash(.label(title), delay: 3)
    }
    
    func showSuccess(title:String, subtitle: String? = nil){
        HUD.flash(.labeledSuccess(title: title, subtitle: subtitle) ,delay: 3)
    }
}

extension UIViewController: ShowHUD{}
extension UITableViewCell: ShowHUD{}
extension UITableView: ShowHUD{}
