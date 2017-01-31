//
//  MatchItem.swift
//  AllSports
//
//  Created by Jeroen Dunselman on 28/12/2016.
//  Copyright © 2016 Jeroen Dunselman. All rights reserved.
//
import Foundation
//import FirebaseDatabase
import Firebase
struct MatchItem {

    let key: String
    let sport: String
    let name: String
    let addedByUser: String
    let ref: FIRDatabaseReference?
    var completed: Bool //tutorial to-do-item
 
//    let theMatchDetails = ["Locatie", "Datum", "Deelnemers", "Resultaat", "Foto"]
    let place: String
    let time: String
    var dTime: NSNumber
//    var eventDate: NSDate
    let participants : String
    let result : String
    
    func defaultData () {
        
    }
  init(date: NSNumber , name: String, participants: String,  addedByUser: String, completed: Bool, key: String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.ref = nil
        self.dTime = date //.timeIntervalSince1970
//        defaultData()
        place = "defaultdata"
        time = "defaultdata"
      
        self.participants = participants
        result = "defaultdata"
        sport = "defaultsport"
    }
  //  init(date: NSDate , name: String, addedByUser: String, completed: Bool, key: String = "") {
//    dTime = date.timeIntervalSince1970
//    self.init(name: name, addedByUser: addedByUser, completed: completed, key: key)
//  }

  
  public func title() -> String {
    if (self.participants as String!) != "defaultdata" {
      return self.sport + ": " + self.participants
    } else {
      return self.sport
    }
  }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        sport = snapshotValue["sport"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
        
//        defaultData()
        place = snapshotValue["place"] as! String
        time = snapshotValue["time"] as! String
        participants = snapshotValue["participants"] as! String
        result = snapshotValue["result"] as! String
        dTime = snapshotValue["dTime"] as! NSNumber
      //    get a date from a double:
      //    var interval = Double()
      //    var date = NSDate()
      //    date = NSDate(timeIntervalSince1970: interval)

//        eventDate = NSDate(timeIntervalSince1970: time)
    }
    //  Use setValue(_:) to save data to the database. This method expects a Dictionary. GroceryItem has a helper function called toAnyObject() to turn it into a Dictionary.
    func toAnyObject() -> Any {
        return [
            "key": key,
            "sport": sport,
            "name": name,
            "addedByUser": addedByUser,
            "completed": completed,
            "place" : place,
            "time" : time,//Date().debugDescription,
            "participants" : participants,
            "result" : result,
            "dTime" : dTime
          
        ]
    }
   /* */
}
