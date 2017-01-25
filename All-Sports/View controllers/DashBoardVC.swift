//
//  DashBoardVC.swift
//  PageControl MF
//
//  Created by Jeroen Dunselman on 20/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit
import Firebase
class DashBoardVC: UIViewController {
  typealias Entry = (Character, [String])
  
  var items:[MatchItem] = []
  var scores:[String] = []
  @IBOutlet weak var textView: UITextView!
  
  struct scoreCount{
    var won:Int = 0
    var draw:Int = 0
    var lost:Int = 0
    
    func toString() -> String {
      var x:String = ""
      x = "\n" + "Won: \(won)" + "\n" + "Draw: \(draw) \n" + "Lost: \(lost) \n"
      return x    
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let user = FIRAuth.auth()?.currentUser {
      let refString:String = "/users/\(user.uid)/match-items"
      let ref = FIRDatabase.database().reference(withPath: refString )
      self.scores = []
      ref.observe(.value, with: { snapshot in
        //        print(snapshot.value)
        var newItems: [MatchItem] = []
        
        // 3
        for item in snapshot.children {
          // 4
          let matchItem = MatchItem(snapshot: item as! FIRDataSnapshot)
          newItems.append(matchItem)
          self.scores.append(matchItem.result)
        }
        
        // 5
        self.items = newItems
        var result = scoreCount()
        result.won = (self.scores.filter{$0 == "0"}).count
        result.draw = (self.scores.filter{$0 == "1"}).count
        result.lost = (self.scores.filter{$0 == "2"}).count
        
        var resultDct:[String:Int] = [:]
        resultDct.updateValue(result.won, forKey: "Won")
        resultDct.updateValue(result.draw, forKey: "Draw")
        resultDct.updateValue(result.lost, forKey: "Lost")

        let sports = (newItems.map { $0.sport }).reduce([], { (a: [String], b: String) -> [String] in
          if a.contains(b) {
            return a
          } else {
            return a + [b]
          }
        })
        
        var sportsDct:[String:String] = [:]
        for (sport) in sports {
          let sportItems = newItems.filter{ $0.sport == sport }
          let sportResults = sportItems.map{$0.result}
          var sportResult = scoreCount(won: 0, draw: 0,  lost: 0)
          sportResult.won = (sportResults.filter{$0 == "0"}).count
          sportResult.draw = (sportResults.filter{$0 == "1"}).count
          sportResult.lost = (sportResults.filter{$0 == "2"}).count

          sportsDct.updateValue("Plays: \(sportItems.count)" + sportResult.toString(), forKey: sport)
        }
        
        var resultTxt = ""
        for (index, element) in sportsDct {
         resultTxt += "\nSport: " + index + "\n" + element
        }
        self.textView.text =
          resultTxt + "\n" + "AllSports: " + "\n" + resultDct.description
//          sportsDct.description + "\n" + newItems.description
      })
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
