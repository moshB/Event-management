//
//  EditMainViewController.swift
//  event management
//
//  Created by Mosh on 21/04/2021.
//

import UIKit
import FirebaseUI

class EditMainViewController: UIViewController {

    var event:Event?
    
    @IBOutlet var myView: UIView!
    
    @IBAction func saveDetails(_ sender: UIBarButtonItem) {
        guard let name = nameEventTextField.text,
              let typeEvent = typeEventTextField.text,
              let dateEvent = datePicker else {
            showError(title: "You did not enter the details correctly")
            return
        }
        
        guard let budget:Int = Int(budgetTextField.text ?? "0") else{
            self.showError(title: "Budget must be a number!")
            sender.isEnabled = true
         return
        }
        event?.name = name
        event?.typeEvent = typeEvent
        event?.dateEvent = dateEvent.date
        event?.budget = budget
        
        showProgress(title: "Plase whit!")
        
        func saveProductCallback(_ error: Error?, _ success: Bool){
            sender.isEnabled = true
            if success {
                self.showSuccess(title: "Done!")
                //pop back to the tableview controller
                self.navigationController?.popViewController(animated: true)
            }else {
                showError(title: "Please try again")
            }
            event = nil
        }
        
        if didSelectImage, let image = eventImageView.image{
            event?.edit(image: image, callback: saveProductCallback)
        }else{
            event?.edit(callback: saveProductCallback)
        }
        
        
        
    }
    
    @IBAction func openCamera(_ sender: UIBarButtonItem) {
        //take photo: cam/gallery
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true

        //func inside a func
        func takeAction(_ action: UIAlertAction){
            if action.title == "Camera" && UIImagePickerController.isSourceTypeAvailable(.camera){
                picker.sourceType = .camera
            }
            present(picker, animated: true)
        }

        //show dialog:
        let actionSheetDialog = UIAlertController(title: "Choose Source",
                                                  message: nil, preferredStyle: .actionSheet)
        actionSheetDialog.addAction(UIAlertAction(title: "Gallery", style: .default, handler:takeAction))
        actionSheetDialog.addAction(UIAlertAction(title: "Camera", style: .destructive, handler: takeAction))
        actionSheetDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))//nil!
        
        present(actionSheetDialog, animated: true)
    }
    
    @IBOutlet weak var nameEventTextField: UITextField!
    
    @IBOutlet weak var typeEventTextField: UITextField!
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var budgetTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var didSelectImage = false

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        event = Event.event
        paintViews()
//        scrollViewDidScroll(scrollView)
        // Do any additional setup after loading the view.
    }
    
    func paintViews() {
        nameEventTextField.text = event?.name
        typeEventTextField.text = event?.typeEvent
        budgetTextField.text = event?.budget.description
        datePicker.date = event?.dateEvent ?? Date()
        
        let ref = Storage.storage().reference().child("events")
        if ref.child("\(event?.id).jpg") != nil{
            self.eventImageView?.sd_setImage(with: ref.child("\(Event.event.id).jpg"), placeholderImage: UIImage(systemName: "photo"))
        }
    }
    


}
extension EditMainViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage{
            eventImageView.image = image
            didSelectImage = true
        }
        picker.dismiss(animated: true)
    }
}
