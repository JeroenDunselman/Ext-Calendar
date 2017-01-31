//
//  ViewController.swift
//  My MF Tableview
//
//  Created by Jeroen Dunselman on 06/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//
import Foundation
import UIKit
import Firebase

struct crud {
//  var crudEdit = false
  enum crudMode {
    case create, read, update, delete
  }
}

class ViewController: UIViewController {
  var crudController:EventsPVC = EventsPVC()
  let newEventTitle = "Adding New Event"
  var selectedMatchItemKey:String = ""
  
  var mode = crud.crudMode.read
  var items:[MatchItem] = []
  var currentMatchItem:MatchItem?
  @IBAction func addEventButton(_ sender: Any) {

      if let user = FIRAuth.auth()?.currentUser {
        
        let refString:String = "/users/\(user.uid)/match-items"
        let ref = FIRDatabase.database().reference(withPath: refString )
        let matchItem =
          MatchItem(date: NSNumber(value:Date().timeIntervalSince1970), name: "een nieuw item", participants: "",
                    addedByUser: "jerodunsch@gmail.com",
                    completed: false)
        
        let newEventRef = ref.childByAutoId()
        newEventRef.setValue(
          matchItem.toAnyObject()
        )
        currentMatchItem = matchItem
        selectedMatchItemKey = newEventRef.key
        showNextPVC(title: newEventTitle)
      }
    
  }
  @IBOutlet var tableView: UITableView!
  
  public var eventCards = SportsCardStore.eventCards()
  public var theCard:SportsCard?
  
  let textCellIdentifier = "eventCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(EventCell.self, forCellReuseIdentifier: textCellIdentifier)

    if let user = FIRAuth.auth()?.currentUser {
      let refString:String = "/users/\(user.uid)/match-items"
      let ref = FIRDatabase.database().reference(withPath: refString )
      ref.observe(.value, with: { snapshot in
        var newItems: [MatchItem] = []
        for item in snapshot.children { let matchItem = MatchItem(snapshot: item as! FIRDataSnapshot)
          newItems.append(matchItem)
        }
        self.items = newItems
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
      })
    }
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  // MARK:  UITextFieldDelegate Methods
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count //eventCards.count
  }
  
  internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
    
//    let cell:EventCell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier) as! EventCell
    let row = indexPath.row
    cell.textLabel?.text = items[row].title()
    return cell
  }
  
  // MARK:  UITableViewDelegate Methods
  
  func goBack(){
    dismiss(animated: true, completion: nil)
    if crudController.crudMode == crud.crudMode.create {
    
    } else {
      print(crudController.crudMode)
    }
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    theCard = self.eventCards[indexPath.row % self.eventCards.count]
    let activeMatchItem:MatchItem = items[indexPath.row]
    selectedMatchItemKey = activeMatchItem.key
    
    currentMatchItem = items[indexPath.row]
    showNextPVC(title:items[indexPath.row].title())
  }
  
  func showNextPVC(title: String) {
    
    if title == newEventTitle {
      mode = crud.crudMode.create
    } else {mode = crud.crudMode.read}
    
    if let crudVC = storyboard!.instantiateViewController(withIdentifier: "theNextPVC") as? EventsPVC {
      crudController = crudVC
      crudController.crudMode = mode
      crudController.matchItemKey = selectedMatchItemKey //String(describing: items[row].key)
      crudController.currentMatch = currentMatchItem
      crudController.navigationItem.title = title //order.name
      crudController.navigationItem.leftBarButtonItem =         UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
      
      let navController = UINavigationController(rootViewController: crudController)
      
      let transition = CATransition()
      transition.duration = 0.2
      transition.type = kCATransitionPush
      transition.subtype = kCATransitionFromRight
      view.window!.layer.add(transition, forKey: kCATransition)
      
      present(navController, animated: false, completion: nil)
    }
  }
 
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let item = items[indexPath.row]
      item.ref?.removeValue()
    }
  }
}

