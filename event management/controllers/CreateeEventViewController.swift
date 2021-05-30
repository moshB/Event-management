//
//  CreateeEventViewController.swift
//  event management
//
//  Created by Mosh on 17/02/2021.
//

import UIKit

class CreateeEventViewController: UIViewController {

    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
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
    var didSelectImage = false
    var event:Event?
    @IBOutlet weak var datePicker: UIDatePicker!
    var date:Date?
    @IBAction func saveDate(_ sender: UIButton) {
        let dateEvent = datePicker.date
        date = dateEvent
        dateLabel.text = dateEvent.description
        dismissDialog()
    }
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!{
        didSet{
            let tap = UITapGestureRecognizer(
                target: self,
                action: #selector(dismissTapped(_:))
            )
            
            
            visualEffectView.isUserInteractionEnabled = true
            visualEffectView.addGestureRecognizer(tap)
        }
    }
    
    @objc func dismissTapped(_ sender: UITapGestureRecognizer){
        
       dismissDialog()
    }
    fileprivate func dismissDialog() {
        setDate.removeFromSuperview()
        visualEffectView.isHidden = true
    }

    @IBOutlet var setDate: UIView!
    
    @IBAction func showDialogSetDate(_ sender: UIButton) {
        setDate.center.x = view.center.x
        setDate.center.y = 0 - setDate.frame.height / 2

        setDate.transform = CGAffineTransform(rotationAngle: .pi)

        //add the view to the view hirarchy of our View Controller
        view.addSubview(setDate)

        UIView.animate(withDuration: 0.4) {[weak self] in
            self?.setDate.center = self?.view.center ?? .zero

            
            self?.visualEffectView.isHidden = false
            
            self?.setDate.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
        }
        
        
        

    }
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var eventNameTextField: UITextField!
    
    @IBOutlet weak var eventTypeTextField: UITextField!
    
    @IBOutlet weak var dateLabel: UILabel!
    
   
    @IBOutlet weak var eventBudgetTextField: UITextField!
        
   
    @IBAction func saveEvent(_ sender: UIBarButtonItem) {
        
        guard let name = eventNameTextField.text,
              let typeEvent = eventTypeTextField.text,
              let dateEvent = date else {
            showError(title: "You did not enter the details correctly")
            return
        }
        guard let budgetStr = eventBudgetTextField.text, budgetStr.count > 0,
              let budget = Int(budgetStr) else {
            showError(title: "Must fill a numerical budget")
            return
        }
        
        showProgress(title: "Plase whit!")
        event = Event(name: name, typeEvent: typeEvent, budget: budget, dateEvent: dateEvent)
        
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
            event?.save(image: image, callback: saveProductCallback)
        }else{
            event?.save(callback: saveProductCallback)
        }
    }
    
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        User().getMyEvents { (err, dict) in
            if let _ = err{
                return
            }
            guard let dict = dict else{
                return}
        }
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CreateeEventViewController:UIImagePickerControllerDelegate,
                                   UINavigationControllerDelegate{
    
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

