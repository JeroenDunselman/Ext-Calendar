//
//  AccountVC.swift
//  PageControl MF
//
//  Created by Jeroen Dunselman on 16/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit

extension AccountVC: UITableViewDelegate, UITableViewDataSource  {
  // MARK: - Table view data source
  func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return items.count //eventCards.count
  }
  
  internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 64
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "idAccountCell")! //as! EventCell
//    cell.backgroundColor = UIColor.blue
//    cell.textLabel?.backgroundColor = UIColor.black
//    cell.textLabel?.textColor = UIColor.white
//    let theCard = eventCards[indexPath.row]
//    cell.titleLabel!.text = theCard.description
    cell.textLabel?.text = self.items[indexPath.row]
//    cell.detailTextLabel?.text = theCard.description
    
    return cell
  }
  
  
  
  func loadCalendarPicker() {
    if let pickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCalendarPicker") as? CalendarPickerVC {
      pickerVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title:   "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
      pickerVC.title = "My Calendars"
      let navController = UINavigationController(rootViewController: pickerVC)
      self.present(navController, animated:true, completion: nil)
    }
  }

//
//  // PizzaMenuTableViewController class:
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let row = indexPath.row
       let section = indexPath.section
    
    if items[indexPath.row] == "Calendars" {
      loadCalendarPicker()
    }
    
    //dit crasht
//    if let accountDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCardViewControllerEvents") as? CardViewController {
////    cardViewController.pageIndex = index
//      accountDetailVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
//      
//      let navController = UINavigationController(rootViewController: accountDetailVC)
//      
//      self.present(navController, animated:true, completion: nil)
//
//    }

    
//    //
//    //    let event = myEvents.items[section][row]
//    //   let order = menuItems.items[section][row]
//    
//    //    event.name += " " + myEvents.sections[section]
//    //   order.name += " " + menuItems.sections[section]
//    theCard = self.eventCards[indexPath.row]
//    if let resultController = storyboard!.instantiateViewController(withIdentifier: "Purple") as UIViewController? {
//      resultController.navigationItem.title = theCard?.name //order.name
//      resultController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.goBack))
//      
//      let navController = UINavigationController(rootViewController: resultController)
//      //      self.present(navController, animated:true, completion: nil)
//      
//      let transition = CATransition()
//      transition.duration = 0.2
//      transition.type = kCATransitionPush
//      transition.subtype = kCATransitionFromRight
//      view.window!.layer.add(transition, forKey: kCATransition)
//      
//      present(navController, animated: false, completion: nil)
//      
//    }
//    
  }
//
//  func goBack(){
//    dismiss(animated: true, completion: nil)
//  }
//  
}

class AccountVC: UIViewController {
  let items = ["Calendars", "Username", "Favorites", "Contact", "Logout"]
  
  @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.frame = self.view.bounds
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "idAccountCell")
//      tableSubView.addSubview(tableAccountItems.)
////      tableView.register(EventCell.self, forCellReuseIdentifier: "idAccountCell")    tableView.register(EventCell.self, forCellReuseIdentifier: "idAccountCell")    tableView.register(EventCell.self, forCellReuseIdentifier: "idAccountCell")
        // Do any additional setup after loading the view.
    }
  
    func goBack(){
      dismiss(animated: true, completion: nil)
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
