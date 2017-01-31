//
//  CalendarPickerVC.swift
//  All-Sports
//
//  Created by Jeroen Dunselman on 25/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit
import EventKit
import Firebase
//import EventKitUI

struct calendarInfo {
  var title:String?
  var color:CGColor?
  var numberOfEvents:Int?
  var isActiveCalendar:Bool?
  var isSportsCalendar:Bool?
}

class CalendarPickerVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  let textCellIdentifier = "calendarCell"
  
  var systemCalendars:[calendarInfo] = []
  var inactiveCalendars:[calendarInfo] = []
  var sportsCalendars:[SportsCalendar] = []
  var inactiveSportsCalendars:[SportsCalendar] = []
  var titles:[String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    DispatchQueue.global().async() {
      self.getActiveSportsCalendars()
    }
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func createDataSet() {
    self.titles = sportsCalendars.map{$0.name}
    if self.titles.count > 0 {
      inactiveCalendars = systemCalendars.filter{!self.titles.contains($0.title!)}
    } else {
      inactiveCalendars = systemCalendars
    }
//      .map{$0.title!}
//    titles.append(contentsOf: inactiveCalendarTitles)
  }
  
  func getActiveSportsCalendars() {
    if let user = FIRAuth.auth()?.currentUser {
      let refString:String = "/users/\(user.uid)/calendars"
      let ref = FIRDatabase.database().reference(withPath: refString )
      ref.observe(.value, with: { snapshot in
        var calendars: [SportsCalendar] = []
        for item in snapshot.children { let calendar = SportsCalendar(snapshot: item as! FIRDataSnapshot)
          calendars.append(calendar)
        }
        DispatchQueue.main.async() {
          self.sportsCalendars = calendars.filter{$0.active}
          self.inactiveSportsCalendars = calendars.filter{!$0.active}
          self.getSystemCalendars()
        }
        //      self.tableView.delegate = self
        //      self.tableView.dataSource = self
        //      self.tableView.reloadData()
      })
    }
  }
  
  func getSystemCalendars() {
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
        self.systemCalendars = []
        for calendar in calendars {
          print(calendar.title)
          //          titles.append(calendar.title)
          let info = calendarInfo(title: calendar.title, color:calendar.cgColor, numberOfEvents: 0, isActiveCalendar: false, isSportsCalendar: false)
          self.systemCalendars.append(info)
          print(calendar.cgColor)
        }
        
        DispatchQueue.main.async() {
          //calendar sets fb/icloud in/active in seperate sections
          self.createDataSet()
          self.tableView.reloadData()
        }
        //        self.tableView.reloadData()
        
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

// MARK:  UITableViewDelegate Methods
extension CalendarPickerVC: UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var result:Int = 0
    if section == 0 {
      result = self.sportsCalendars.count //eventCards.countcalendarItems
    } else if section == 1 {
      result = self.inactiveCalendars.count
    }
    return result
  }
  
  internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
    let row = indexPath.row
    
    cell.backgroundColor = UIColor.black
    cell.textLabel?.textColor = UIColor.white

    switch (indexPath.section) {
    case 0:
      cell.textLabel?.text = sportsCalendars[row].title()
      let sysCal =
        systemCalendars.filter{$0.title == sportsCalendars[row].name}
      if sysCal.count > 0 {
        cell.backgroundColor = UIColor(cgColor: sysCal[0].color!)
      }
    case 1:
      cell.textLabel?.text = inactiveCalendars[row].title
      let uiColor = UIColor(cgColor: inactiveCalendars[row].color!)
      cell.backgroundColor = uiColor
    default:
      cell.textLabel?.text = "Other"
    }
    return cell
  }
  
  func goBack(){
    dismiss(animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var result:String = ""
    if section == 0 {
      result = "Sports Calendars"
      if self.sportsCalendars.count == 0 {
        result = "Select Calendar For Tracking Sport Results"
      }
    } else if section == 1 {
      result =  "Calendars" //self.inactiveCalendarTitles.count
    }
    return result
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    
    func loadCalendarDetailVC() {
      
      if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCalendarDetailVC") as? CalendarDetailVC {
        
        detailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title:   "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        
        var info:calendarInfo
        var key:String
        if (indexPath.section == 0) {
          //get color from systemCalendars for equal title
          let sysCal = systemCalendars.filter{$0.title == sportsCalendars[indexPath.row].name}
          
          var theColor = UIColor.black.cgColor
          if sysCal.count > 0 {
            theColor = sysCal[0].color!
          }
          
          info = calendarInfo(title :sportsCalendars[indexPath.row].name,
                                color: theColor,
                                numberOfEvents: 0,
                                isActiveCalendar: true, isSportsCalendar: true)
          key = sportsCalendars[indexPath.row].key
        } else {
          // does systemCalendar exist as inactive sportscalendar?
          let sportsCal = inactiveSportsCalendars.filter{$0.name == inactiveCalendars[indexPath.row].title}
          if sportsCal.count > 0 {
            info = calendarInfo(title: sportsCal[0].name,
                                color: inactiveCalendars[indexPath.row].color,
                                numberOfEvents: 0,
                                isActiveCalendar: false, isSportsCalendar: true)
            key = sportsCal[0].key
          } else {
            info = inactiveCalendars[indexPath.row]
            key = ""
          }
        }
        
        detailVC.key = key
        detailVC.info = info
        detailVC.title = info.title
        detailVC.color = UIColor(cgColor: info.color!)
        let navController = UINavigationController(rootViewController: detailVC)
        self.present(navController, animated:true, completion: nil)
      }
    }
    loadCalendarDetailVC()
    
  }
  
  
  
}

