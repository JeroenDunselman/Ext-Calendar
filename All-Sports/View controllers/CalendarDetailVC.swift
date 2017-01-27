//
//  CalendarDetailVC.swift
//  All-Sports
//
//  Created by Jeroen Dunselman on 25/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit
import Firebase

class CalendarDetailVC: UIViewController{
  //, UIPickerViewDelegate, UIPickerViewDataSource {
  public var key: String?
  public var info:calendarInfo?
  public var color:UIColor?
  @IBOutlet weak var switchView: UIView!
  
  @IBOutlet weak var lblSelectCalendar: UILabel!
  @IBOutlet weak var switchActivateCalendar: UISwitch!
  @IBOutlet weak var labelInfoCalendar: UILabel!
  
  @IBOutlet weak var sportPickerView: UIView!
  
  override func viewWillDisappear(_ animated: Bool) {
    if let user = FIRAuth.auth()?.currentUser {
      //save uid/calendars/name/switchView.value
//      if let itemKey = self.title  {
      if switchActivateCalendar!.isOn != info?.isActiveCalendar {
      
        let calendar = SportsCalendar(name: (self.info?.title!)!, sport: "Voetbal", key: self.key!, active:switchActivateCalendar!.isOn, numberOfRecords: 0)
//
        if self.key == "" {
          
          let refString:String = "/users/\(user.uid)/calendars/" //\(itemKey)
          let ref = FIRDatabase.database().reference(withPath: refString )
          let newCalendarRef = ref.childByAutoId()
          newCalendarRef.setValue(calendar.toAnyObject())
        } else {
          
          let refString:String = "/users/\(user.uid)/calendars/\(self.key!)/active"
          let ref = FIRDatabase.database().reference(withPath: refString )
          ref.setValue(switchActivateCalendar!.isOn)
        }
      }
    }
  }
  
//  func dit() {
//  if let user = FIRAuth.auth()?.currentUser {
//    
//    let refString:String = "/users/\(user.uid)/match-items"
//    let ref = FIRDatabase.database().reference(withPath: refString )
//    let matchItem =
//      MatchItem(name: "een nieuw item",
//                addedByUser: "jerodunsch@gmail.com",
//                completed: false)
//    
//    let newEventRef = ref.childByAutoId()
//    newEventRef.setValue(
//      matchItem.toAnyObject()
//    )
////    currentMatchItem = matchItem
////    selectedMatchItemKey = newEventRef.key
////    showNextPVC(title: newEventTitle)
//  }
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let sportPickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idSportPicker") as? SportPVC {
      
      self.switchView.backgroundColor = color
      self.view.backgroundColor = color
      lblSelectCalendar.lineBreakMode = NSLineBreakMode.byWordWrapping
      lblSelectCalendar.numberOfLines = 0
//      self.lblSelectCalendar.lineBreakMode = NSLineBreakByWordWrapping
//      self.lblSelectCalendar.numberOfLines = 0
      self.lblSelectCalendar.text = "Select sport for \(self.title!) Calendar"
      lblSelectCalendar.sizeToFit()
    
      switchActivateCalendar.isOn = false
      if let active = (info?.isActiveCalendar) {
        switchActivateCalendar.isOn = active
      }
      
        sportPickerVC.theSport = "Schoonspringen" //value
        sportPickerVC.view.frame = self.sportPickerView.bounds
        self.addChildViewController(sportPickerVC)
        sportPickerVC.didMove(toParentViewController: self)
        self.sportPickerView!.addSubview(sportPickerVC.view!)
      
    }
    
    
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
