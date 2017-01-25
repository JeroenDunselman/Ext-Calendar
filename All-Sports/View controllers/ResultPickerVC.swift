//
//  ResultPickerVC.swift
//  PageControl MF
//
//  Created by Jeroen Dunselman on 20/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit
import Firebase
class ResultPickerVC: UIViewController {
  public var theResult:String?
  public var refString:String?
  
  @IBAction func resultChanged(_ sender: Any) {
    
    let ref = FIRDatabase.database().reference(withPath: refString! )
    //    if let text = fillInText.text {
    ref.setValue(resultSC.selectedSegmentIndex.description)
  }
  @IBOutlet weak var resultSC: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

      
      resultSC.selectedSegmentIndex = 2
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
