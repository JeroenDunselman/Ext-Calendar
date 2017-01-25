//
//  SportPVC.swift
//  PageControl MF
//
//  Created by Jeroen Dunselman on 16/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit
import Firebase

class SportPVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  @IBOutlet weak var thePicker: UIPickerView!
  let data = ["Voetbal", "Golf", "Dammen", "Schoonspringen"]
  public var theSport:String?
  public var refString:String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    print(self.parent?.description)
//    theSport = "Dammen"
    thePicker.dataSource = self
    thePicker.delegate = self
    
    if data.contains(theSport!)
    { //
      thePicker.selectRow(data.index(of: theSport!)!, inComponent: 0, animated: true)
    }
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.data.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return data[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let ref = FIRDatabase.database().reference(withPath: refString! )
//    if let text = fillInText.text {
      ref.setValue(data[row])
//    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
