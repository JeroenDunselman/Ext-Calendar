//
//  EventsVC.swift
//  All-Sports
//
//  Created by Jeroen Dunselman on 27/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit
import Firebase
import EventKit

struct sportsDate {
  var event:EKEvent?
  var matchItem:MatchItem?
  var calendar:SportsCalendar
}

class EventsVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var eventStore = EKEventStore()
  var sportsCalendars: [SportsCalendar] = []
  var sportsEvents: [MatchItem] = []
  var titles: [String] = []
  var events: [EKEvent] = []
//  var systemCalendars:[calendarInfo] = []
  var dates:[sportsDate] = []
  
  var selectedMatchItemKey:String = ""
  var currentMatchItem:MatchItem?
  //  var pastEventsNoResult:
  //  var pastEvents: [MatchItem]
  
  let textCellIdentifier = "sportsEventCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.sportsCalendars = []
    self.sportsEvents = []
    self.events = []
    self.dates = []
    tableView.delegate = nil
    tableView.dataSource = nil
    DispatchQueue.global().async() {
      self.getActiveSportsCalendars()
    }
    
  }
  
  func getActiveSportsCalendars() {
    if let user = FIRAuth.auth()?.currentUser {
      let refString:String = "/users/\(user.uid)/calendars"
      let ref = FIRDatabase.database().reference(withPath: refString )
      ref.observe(.value, with: { snapshot in
        
        for item in snapshot.children { let calendar = SportsCalendar(snapshot: item as! FIRDataSnapshot)
          if calendar.active {
            self.sportsCalendars.append(calendar)
          }
        }
        
        self.getUserCalendarEventsForActiveSportsCalendars()

        
        //        DispatchQueue.main.async() {
        //          self.calendars = self.calendars.filter{$0.active}
        //          DispatchQueue.global().async() {
        
//        self.getSystemCalendars()
        //          }
        //          self.inactiveSportsCalendars = calendars.filter{!$0.active}
        //          self.getSystemCalendars()
        //        }
        
      })
    }
  }
  
  
  func getUserCalendarEventsForActiveSportsCalendars() {
    var startDates : [NSDate] = []
    var endDates : [NSDate] = []
    let calendars = self.eventStore.calendars(for: .event)
    let activeSportsCalendarTitles = self.sportsCalendars.map{$0.name}
    let calendarsActive = calendars.filter{activeSportsCalendarTitles.contains($0.title)}

    if activeSportsCalendarTitles.count > 0 {
      let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600*12)
      let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600*12)
      
      let predicate = self.eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: calendarsActive)
      
      self.events = []
      self.titles = []
      let events = self.eventStore.events(matching: predicate)
      
      for event in events {
        let participants = event.firstOpponentName()
        self.titles.append("\(participants) \(event.startDate) \(event.title)")
        self.events.append(event)
        startDates.append(event.startDate as NSDate)
        endDates.append(event.endDate as NSDate)
      }
      self.matchEventsToMatchItems()
    }
  }
  
  func matchEventsToMatchItems() {
    
    if let user = FIRAuth.auth()?.currentUser {
      let refString:String = "/users/\(user.uid)/match-items"
      let ref = FIRDatabase.database().reference(withPath: refString)
      ref.observe(.value, with: { snapshot in
        var matchItems: [MatchItem] = []
        for item in snapshot.children { let matchItem = MatchItem(snapshot: item as! FIRDataSnapshot)
          matchItems.append(matchItem)
        }
        self.sportsEvents = matchItems
        for event in self.events {
          let calendars = self.sportsCalendars.filter{$0.name == event.calendar.title}
          let sportCalendar:SportsCalendar = calendars[0]
  
          let date = NSNumber(value: event.startDate.timeIntervalSince1970)
          let items:[MatchItem] = self.sportsEvents.filter{$0.dTime == date}
          
          if items.count > 0 {
            
            let sportsItem = items[0]
            let sportsCalendarEvent = sportsDate(event: event, matchItem: sportsItem, calendar: sportCalendar)
            self.dates.append(sportsCalendarEvent)
          } else {
            self.dates.append(sportsDate(event: event, matchItem: nil, calendar: sportCalendar))
          }
          
          
        }
        
        DispatchQueue.main.async() {
//          print(self.titles)
          
          self.tableView.delegate = self
          self.tableView.dataSource = self
          self.tableView.reloadData()
        }
        
      })
      
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}



// MARK:  UITableViewDelegate Methods
extension EventsVC: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.events.count
  }
  
  internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    var cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
    
//    if cell == nil {
//      cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: textCellIdentifier)
//    }
//    var cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier)! as UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: textCellIdentifier)
//    if cell == nil {
//      cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: textCellIdentifier)
//    }
    
    let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "textCellIdentifier")

    let row = indexPath.row
    
    cell.backgroundColor = UIColor.black
    cell.textLabel?.textColor = UIColor.white
    cell.textLabel?.text = self.events[row].firstOpponentName()
//
    cell.detailTextLabel?.text = "\(self.events[row].title): \(self.dates[row].calendar.sport)"
    if let sportsEvent = self.dates[row].matchItem {
      cell.textLabel?.text = "\(sportsEvent.sport): \(sportsEvent.participants)"
//      cell.detailTextLabel?.text = "\(self.titles[row]) \(self.events[row].startDate)"
      cell.backgroundColor = UIColor.white
      cell.textLabel?.textColor = UIColor.black
    }
    cell.detailTextLabel?.textColor = UIColor.white
    cell.detailTextLabel?.backgroundColor = UIColor(cgColor: self.events[row].calendar.cgColor)

//    cell.textLabel?.backgroundColor    
    return cell
  }
  
  func goBack(){
    dismiss(animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    var result:String = ""
    //    if section == 0 {
    //      result = "Sports Calendars"
    //      if self.sportsCalendars.count == 0 {
    //        result = "Select Calendar For Tracking Sport Results"
    //      }
    //    } else if section == 1 {
    //      result =  "Calendars" //self.inactiveCalendarTitles.count
    //    }
    return result
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    
    func showMatchPVC(title: String) {
      
      if let matchPVC = storyboard!.instantiateViewController(withIdentifier: "theNextPVC") as? EventsPVC {
        matchPVC.matchItemKey = selectedMatchItemKey
        matchPVC.currentMatch = currentMatchItem
        matchPVC.currentEvent = events[indexPath.row]
        matchPVC.navigationItem.title = title //order.name
        matchPVC.navigationItem.leftBarButtonItem =         UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        
        let navController = UINavigationController(rootViewController: matchPVC)
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        present(navController, animated: false, completion: nil)
      }
    }
    
    func createMatchItem(){
      if let user = FIRAuth.auth()?.currentUser {
        
        let refString:String = "/users/\(user.uid)/match-items"
        let ref = FIRDatabase.database().reference(withPath: refString )
        
        if let event = self.events[indexPath.row] as EKEvent! {

          let participants = event.firstOpponentName()
          let matchItem =
            MatchItem(date: NSNumber(value: event.startDate.timeIntervalSince1970),
                      name: event.title,
                      participants: participants,
                      addedByUser: "jerodunsch@gmail.com",
                      completed: false)
          
          let newEventRef = ref.childByAutoId()
          newEventRef.setValue(
            matchItem.toAnyObject()
          )
          self.currentMatchItem = matchItem
          self.selectedMatchItemKey = newEventRef.key
          self.dates[indexPath.row].matchItem = matchItem
        }
        
      }
    }

    if self.dates[indexPath.row].matchItem == nil {
      createMatchItem()
    } else {
      self.currentMatchItem = self.dates[indexPath.row].matchItem
      self.selectedMatchItemKey = (self.dates[indexPath.row].matchItem?.key)!
    }
    showMatchPVC(title: (self.dates[indexPath.row].matchItem?.name)!) //self.titles[indexPath.row])
  }
}

extension EKEvent {
  func eventOpponents() -> [EKParticipant] {
    return self.attendees!
  }
  
  public func firstOpponentName() -> String {
    var participants = ""
    if self.attendees != nil {
      
      for attendee:EKParticipant in self.attendees! {
        
        if !attendee.isCurrentUser {
          participants += attendee.name!
          //                print(attendee.name!)
        }
      }
    }
    return participants
  }
}

//  func getSystemCalendars() {
//    var eventStore = EKEventStore()
//    var titles : [String] = []
//    var startDates : [NSDate] = []
//    var endDates : [NSDate] = []
//
//    // inside viewDidLoad
//    self.eventStore = EKEventStore.init()
//
//    self.eventStore.requestAccess(to: .event, completion: {
//      (granted, error) in
//
//      if granted {
//        //        print("granted \(granted)")
//        // add self.fetchEvents()
//        let calendars = eventStore.calendars(for: .event)
//        self.systemCalendars = []
//        for calendar in calendars {
//          print(calendar.title)
//          //          titles.append(calendar.title)
//          let info = calendarInfo(title: calendar.title, color:calendar.cgColor, numberOfEvents: 0, isActiveCalendar: false, isSportsCalendar: false)
//          self.systemCalendars.append(info)
//          print(calendar.cgColor)
//        }
//
//        //        DispatchQueue.main.async() {
//        //calendar sets fb/icloud in/active in seperate sections
//        //          self.createDataSet()
//        //          self.tableView.reloadData()
//
//        self.getUserCalendarEventsForActiveSportsCalendars()
//        //        }
//        //        self.tableView.reloadData()
//
//      } else {
//        print("error \(error)")
//      }
//
//    })
//
//  }
//    // inside viewDidLoad
//    eventStore = EKEventStore.init()
//
//    eventStore.requestAccess(to: .event, completion: {
//      (granted, error) in
//
//      if granted {
//        //        print("granted \(granted)")
//        // add self.fetchEvents()

//            if let user = FIRAuth.auth()?.currentUser {
//              //              if let itemKey = (self.sportsCard?.matchItemKey)  {
//              //        let refString:String = "/users/\( )/match-items/\(self.key!)/\(itemKey)"
//
//              //                let eVC = EKEventEditViewController()
//              //
//              //                //                eVC.allowsCalendarPreview = true //?
//              //                //                eVC.allowsEditing = true
//              //                //                eVC.modalPresentationCapturesStatusBarAppearance = true
//              //                eVC.event = events[0]
//              //                //                eVC.event.location
//              //                eVC.view.frame = self.pickerView.bounds
//              //                self.addChildViewController(eVC)
//              //                eVC.didMove(toParentViewController: self)
//              //                self.pickerView!.addSubview(eVC.view!)
//
//              //              }
//            }
//          }
//        }
//      } else {
//        print("error \(error)")
//      }
//
//    })
//  }

//      let event:EKEvent = self.events[row]
//      let attendees = event.attendees
//      for p:EKParticipant in attendees! {print(p.name!)}
//      if let partner:EKParticipant = attendees?[0] {
//        cell.textLabel?.text = "\(partner.name!) \(sportsEvent.name): \(sportsEvent.sport)"
//      } else {
//    UIColor(cgColor: sysCal[0].color!)
//    switch (indexPath.section) {
//    case 0:
//      cell.textLabel?.text = sportsCalendars[row].title()
//      let sysCal =
//        systemCalendars.filter{$0.title == sportsCalendars[row].name}
//      if sysCal.count > 0 {
//        cell.backgroundColor = UIColor(cgColor: sysCal[0].color!)
//      }
//    case 1:
//      cell.textLabel?.text = inactiveCalendars[row].title
//      let uiColor = UIColor(cgColor: inactiveCalendars[row].color!)
//      cell.backgroundColor = uiColor
//    default:
//      cell.textLabel?.text = "Other"
//    }
