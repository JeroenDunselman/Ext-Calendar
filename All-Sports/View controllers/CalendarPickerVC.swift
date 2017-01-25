//
//  CalendarPickerVC.swift
//  All-Sports
//
//  Created by Jeroen Dunselman on 25/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit
import EventKit
//import EventKitUI

class CalendarPickerVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  
  
  var calendarItems:[String] = []
  let textCellIdentifier = "calendarCell"
  
    override func viewDidLoad() {
        super.viewDidLoad()
getActiveCalendars()
      
//      dispatch_async(DispatchQueue.global(DispatchQueue.GlobalQueuePriority.default, 0)) {
//      
//      }
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  func getActiveCalendars() {
    var eventStore = EKEventStore()
    var titles : [String] = []
    var startDates : [NSDate] = []
    var endDates : [NSDate] = []
    
    // inside viewDidLoad
    eventStore = EKEventStore.init()
    
    eventStore.requestAccess(to: .event, completion: {
      (granted, error) in
      
      if granted {
        //        print("granted \(granted)")
        // add self.fetchEvents()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
          print(calendar.title)
//          titles.append(calendar.title)
          self.calendarItems.append(calendar.title)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
      } else {
        print("error \(error)")
      }
      
    })
    
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
extension CalendarPickerVC: UITableViewDataSource, UITableViewDelegate {
  // MARK:  UITextFieldDelegate Methods
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.calendarItems.count //eventCards.count
  }
  
  internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
    
    //    let cell:EventCell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier) as! EventCell
    let row = indexPath.row
    cell.textLabel?.text = calendarItems[row]
    return cell
  }
  
  // MARK:  UITableViewDelegate Methods
  
  func goBack(){
    dismiss(animated: true, completion: nil)
//    if crudController.crudMode == crud.crudMode.create {
//      
//    } else {
//      print(crudController.crudMode)
//    }
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//    theCard = self.eventCards[indexPath.row % self.eventCards.count]
//    let activeMatchItem:MatchItem = items[indexPath.row]
//    selectedMatchItemKey = activeMatchItem.key
//    
//    currentMatchItem = items[indexPath.row]
//    showNextPVC(title:items[indexPath.row].title())
  }
}
//  func showNextPVC(title: String) {
//    
//    if title == newEventTitle {
//      mode = crud.crudMode.create
//    } else {mode = crud.crudMode.read}
//    
//    if let crudVC = storyboard!.instantiateViewController(withIdentifier: "theNextPVC") as? EventsPVC {
//      crudController = crudVC
//      crudController.crudMode = mode
//      crudController.matchItemKey = selectedMatchItemKey //String(describing: items[row].key)
//      crudController.currentMatch = currentMatchItem
//      crudController.navigationItem.title = title //order.name
//      crudController.navigationItem.leftBarButtonItem =         UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
//      
//      let navController = UINavigationController(rootViewController: crudController)
//      
//      let transition = CATransition()
//      transition.duration = 0.2
//      transition.type = kCATransitionPush
//      transition.subtype = kCATransitionFromRight
//      view.window!.layer.add(transition, forKey: kCATransition)
//      
//      present(navController, animated: false, completion: nil)
//    }
//  }
//  
//  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//    if editingStyle == .delete {
//      let item = items[indexPath.row]
//      item.ref?.removeValue()
//    }
//  }
//}
