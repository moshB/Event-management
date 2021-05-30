//
//  EventTableViewCell.swift
//  event management
//
//  Created by Mosh on 21/02/2021.
//


//class for View a single event

import UIKit
import FirebaseUI
//import FirebaseStorage

class EventTableViewCell: UITableViewCell {

//    populate Waiting for the table View
//    and Fills all the fields
    func populate(id:String, name:String) {
        self.textLabel?.text = name
        let ref = Storage.storage().reference().child("events")
            self.imageView?.sd_setImage(with: ref.child("\(id).jpg"), placeholderImage: UIImage(systemName: "photo"))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
