//
//  MainEventViewController.swift
//  event management
//
//  Created by Mosh on 21/02/2021.
//

import UIKit
import FirebaseUI

class MainEventViewController: UIViewController {
    
    
    @IBOutlet weak var outletBudget: UIButton!
    var countPress = 0
    @IBAction func actionBudget(_ sender: UIButton) {
        countPress += 1
       let press = countPress % 5
        
        switch press {
        case 0:
            sender.setTitle("\(didBudget)  -  \(Event.event.budget)", for: .normal)
        case 1:
            sender.setTitle("Budget: \(Event.event.budget)", for: .normal)
        case 2:
            sender.setTitle("You used:  \(didBudget)", for: .normal)
        case 3:
            sender.setTitle(" Remains: \(Event.event.budget - didBudget)", for: .normal)
        case 4:
            var d = IO.formatDouble.string(from: NSNumber(value: (Double(didBudget) / Double(Event.event.budget)) * 100.0))
            sender.setTitle("\(d ?? "0") %", for: .normal)
         
        default: break
            
        }
    }
    
    var timer:Timer?
    var timeInterval:TimeInterval = 0
    
    
    @IBAction func baceToEvent(_ sender: UIBarButtonItem) {
        Router.shared.determineRootViewController()
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dayTimerLabel: UILabel!
    
    @IBOutlet weak var timeTimerLabel: UILabel!
    
   
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timeInterval = Date().distance(to: Event.event.dateEvent)
        timer = Timer()
        colorBtnBudget()
        paintViews()
    }
    
    func colorBtnBudget(){
        if (Double(self.didBudget) / Double(Event.event.budget)) > 0.9{
            self.outletBudget.backgroundColor = .red
        }else{
            self.outletBudget.backgroundColor = .green
            
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(stopwatch), userInfo: nil, repeats: true)
        
        Event.event.getEvent { [weak self](err, event) in
            if err != nil{
                User.user.deleteEventFromUser(uid: IO.getUid(), eventId: Router.shared.eventId ?? "") { (err, bool) in
                    guard err == nil, bool == false else {
                        self?.showError(title: err?.localizedDescription ?? "fail")
                        Router.shared.determineRootViewController()
                        return
                    }
                    self?.showError(title: "fail")
                    Router.shared.determineRootViewController()                    
                }
                return
            }
            guard let event = event else {
                self?.showError(title: ErrorData.errorDecodingData.localizedDescription)
                return
            }
            Event.event = event
            self?.paintViews()
        }
    }
    
    var didBudget:Int{
        var budget = 0
        let categorys = Event.event.categorys
            for (_, category) in categorys{
                let tasks = category.tasks
                for (_, task) in tasks{
                    budget += task.budget
                }
            }
        return budget
    }
    
    func paintViews(){
        timeInterval = Date().distance(to: Event.event.dateEvent)
        DispatchQueue.main.async {
            self.nameLabel.text = Event.event.name
            self.typeLabel.text = Event.event.typeEvent

            let strBudget = "\(self.didBudget)  -  \(Event.event.budget)"
            self.outletBudget.setTitle(strBudget, for: .normal)
            self.colorBtnBudget()
            
            let time = IO.formatDay.string(from: Event.event.dateEvent)
            let date = IO.formatDate.string(from: Event.event.dateEvent)
            self.dateLabel.text = date
            self.timeLabel.text = time
            
            let ref = Storage.storage().reference().child("events")
            if ref.child("\(Event.event.id).jpg") != nil{
                self.imageView?.sd_setImage(with: ref.child("\(Event.event.id).jpg"), placeholderImage: UIImage(systemName: "photo"))
            }
            
            
        }
    }
    
    @objc func stopwatch(){
        DispatchQueue.main.async {
            let days: Int = Int(self.timeInterval) / (60 * 60 * 24)
            var seconds:Int = Int(self.timeInterval) % (60 * 60 * 24)
            let hours = seconds / (60 * 60)
            seconds = seconds % (60 * 60)
            let minutes = seconds / 60
            seconds = seconds % 60
            self.dayTimerLabel.text = "\(days) days"
            self.timeTimerLabel.text = "\(hours):\(minutes):\(seconds)"
            self.timeInterval -= 1
        }
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
//protocol  MainEventViewControllerDelegate{
//    func thisEvent(event: Event)
//}
