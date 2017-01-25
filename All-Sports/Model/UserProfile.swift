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
struct UserProfile {

    let email: String
    let name: String
    let ref: FIRDatabaseReference?
    let place: String?
    let key: String
  
    func defaultData () {
        
    }
    init(name: String, email: String, key: String = "") {
        self.name = name
        self.email = email
        self.key = key
        self.ref = nil
        place = "defaultdata"
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        ref = snapshot.ref
        email = snapshotValue["email"] as! String
//        defaultData()
        place = "defaultdata"
    }

    func toAnyObject() -> Any {
        return [
            "name": name,
            "email": email,
            "place" : place
        ]
    }

}
