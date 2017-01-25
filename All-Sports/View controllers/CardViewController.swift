import UIKit
import Firebase
import EventKit
import EventKitUI
private let revealSequeId = "revealSegue"

class CardViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet fileprivate weak var cardView: UIView!
  @IBOutlet fileprivate weak var titleLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  
  @IBOutlet weak var pickerView: UIView!
  var pageIndex: Int?
  var petCard: PetCard?
  var sportsCard: SportsCard?
  
  var defaultText:String = "Vul iets in"
  public var currentMatch:MatchItem?
  var key: String?
  var value:String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textField.delegate = self
    textField.returnKeyType = UIReturnKeyType.done
    
    getCurrentData()
    
    self.title = sportsCard?.name
    //    titleLabel.layer.cornerRadius = 20?
    titleLabel.text = sportsCard?.description
    detailLabel.text = sportsCard?.name
    prepareCardView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    //    self.fillInText.text = result
  }
  
  func getCurrentData() {
    let myPageViewController = self.parent as! EventsPVC
    currentMatch = myPageViewController.currentMatch!
    
    if let keyType = self.sportsCard?.matchItemKey  {
      switch (keyType){
      case "sport":
        value = currentMatch!.sport
      case "participants":
        value = currentMatch!.participants
      case "time":
        value = currentMatch!.time
      case "result":
        value = currentMatch!.result
        //      case "image":
      //        value = currentMatch.
      default:
        value = defaultText
      }
    }
    
    self.textField.text = value//. //"" //getDbValue() //result
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    
    if let user = FIRAuth.auth()?.currentUser {
      if let itemKey = (self.sportsCard?.matchItemKey)  {
        let refString:String = "/users/\(user.uid)/match-items/\(self.key!)/\(itemKey)"
        let ref = FIRDatabase.database().reference(withPath: refString )
        if let text = textField.text {
          ref.setValue(text)
        }
      }
    }
    
    return true;
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
  }
  
  func prepareSportPicker() {
    if let sportPickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idSportPicker") as? SportPVC {
      
      if let user = FIRAuth.auth()?.currentUser {
        if let itemKey = (self.sportsCard?.matchItemKey)  {
          let refString:String = "/users/\(user.uid)/match-items/\(self.key!)/\(itemKey)"

          sportPickerVC.refString = refString
          sportPickerVC.theSport = value
          sportPickerVC.view.frame = self.pickerView.bounds
          self.addChildViewController(sportPickerVC)
          sportPickerVC.didMove(toParentViewController: self)
          self.pickerView!.addSubview(sportPickerVC.view!)
        }
      }
      
      
    }
  }
  func prepareOpponentPicker(){
    
  }
  var reminders: [EKReminder]!
  var eventStore = EKEventStore()
  
  func prepareEventPicker() {
    
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
        let calendars = self.eventStore.calendars(for: .event)
        
        for calendar in calendars {
          print(calendar.title)
          if calendar.title == "Work" {
          
            let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600*12)
            let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600*12)
            
            let predicate = self.eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
            
            var events = self.eventStore.events(matching: predicate)
            
            for event in events {
              titles.append(event.title)
              startDates.append(event.startDate as NSDate)
              endDates.append(event.endDate as NSDate)
            }
            print(titles)
            if let user = FIRAuth.auth()?.currentUser {
              if let itemKey = (self.sportsCard?.matchItemKey)  {
                //        let refString:String = "/users/\(user.uid)/match-items/\(self.key!)/\(itemKey)"
                
                let eVC = EKEventEditViewController()
                
//                eVC.allowsCalendarPreview = true //?
//                eVC.allowsEditing = true
//                eVC.modalPresentationCapturesStatusBarAppearance = true
                eVC.event = events[0]
//                eVC.event.location
                eVC.view.frame = self.pickerView.bounds
                self.addChildViewController(eVC)
                eVC.didMove(toParentViewController: self)
                self.pickerView!.addSubview(eVC.view!)
                
              }
            }
          }
        }
      } else {
        print("error \(error)")
      }
    
    })
  }
    /*mrcly commented on May 22, 2015
     Its much faster in a background thread.
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
     // code here
     }*/
    
//    self.eventStore = EKEventStore()
//    self.reminders = [EKReminder]()
    
//    self.eventStore.requestAccessToEntityType(EKEntityType.Reminder) { (granted: Bool, error: NSError?) -> Void in
//      
//      if granted{
//        // 2
//        let predicate = self.eventStore.predicateForRemindersInCalendars(nil)
//        self.eventStore.fetchRemindersMatchingPredicate(predicate, completion: { (reminders: [EKReminder]?) -> Void in
//          
//          self.reminders = reminders
//          dispatch_async(dispatch_get_main_queue()) {
//            self.tableView.reloadData()
//          }
//        })
//      }else{
//        print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
//      }
//    }
  func prepareEventPickert() {
    if let pickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idEKVC") as? EKVC {
      
      if let user = FIRAuth.auth()?.currentUser {
        if let itemKey = (self.sportsCard?.matchItemKey)  {
          let refString:String = "/users/\(user.uid)/match-items/\(self.key!)/\(itemKey)"
          
//          pickerVC.refString = refString
//          pickerVC.theSport = value
          pickerVC.view.frame = self.pickerView.bounds
          self.addChildViewController(pickerVC)
          pickerVC.didMove(toParentViewController: self)
          self.pickerView!.addSubview(pickerVC.view!)
        }
      }
      
      
    }

  }
  
  func prepareResultPicker() {
    
    if let pickerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idScorePicker") as? ResultPickerVC {
      
      if let user = FIRAuth.auth()?.currentUser {
        if let itemKey = (self.sportsCard?.matchItemKey)  {
          let refString:String = "/users/\(user.uid)/match-items/\(self.key!)/\(itemKey)"
          
          pickerVC.refString = refString
          pickerVC.theResult = value
          pickerVC.view.frame = self.pickerView.bounds
          self.addChildViewController(pickerVC)
          pickerVC.didMove(toParentViewController: self)
          self.pickerView!.addSubview(pickerVC.view!)
        }
      }
      
      
    }
  }
  
  func prepareCardView(){
    let alsJeVanRondHoudt:CGFloat = 15
    cardView.layer.cornerRadius = alsJeVanRondHoudt//25
    cardView.layer.masksToBounds = true
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    cardView.addGestureRecognizer(tapRecognizer)
    
    //    let myPageViewController = self.parent as! MyNextViewController
    //    myPageViewController.resultText = fillInText.text!
    //    self.key = myPageViewController.matchItemKey
    //    let currentMatch:MatchItem = myPageViewController.currentMatch!
    //    var value:String = result
    
    self.textField.isHidden = true
    self.pickerView.isHidden = false
    if let keyType = self.sportsCard?.matchItemKey  {
      switch (keyType){
      case "sport":
        prepareSportPicker()
      case "participants":
        prepareOpponentPicker()
        self.textField.isHidden = false
        self.pickerView.isHidden = true
      case "time":
        prepareEventPicker()
      case "result":
        prepareResultPicker()
      default:
        return
      }
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == revealSequeId, let destinationViewController = segue.destination as? RevealViewController {
      destinationViewController.petCard = petCard
    }
  }
  
  func handleTap() {
    //    performSegue(withIdentifier: revealSequeId, sender: nil)
  }
}

/*
 
 func textFieldDidEndEditing(_ textField: UITextField) {
 //    print("TextField did end editing method called")
 }
 func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
 //    print("TextField should begin editing method called")
 return true;
 }
 func textFieldShouldClear(_ textField: UITextField) -> Bool {
 //    print("TextField should clear method called")
 return true;
 }
 
 func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
 //    print("While entering the characters this method gets called")
 return true;
 }
 func textFieldShouldReturn(_ textField: UITextField) -> Bool {
 //    print("TextField should return method called")
 textField.resignFirstResponder();
 return true;
 }
 */
