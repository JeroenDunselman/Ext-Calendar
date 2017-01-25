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
    let participants : String
    let result : String
    
    func defaultData () {
        
    }
    init(name: String, addedByUser: String, completed: Bool, key: String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.ref = nil
        
//        defaultData()
        place = "defaultdata"
        time = "defaultdata"
        participants = "defaultdata"
        result = "defaultdata"
        sport = "defaultsport"
    }
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
            "result" : result
        ]
    }
   /* */
}
