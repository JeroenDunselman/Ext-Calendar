//
//  Copyright (c) 2015 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

import Firebase

@objc(SignInViewController)
class SignInViewController: UIViewController, UITextFieldDelegate {

 
  @IBAction func btn(_ sender: Any) {
    self.becomeFirstResponder()
    self.emailField.resignFirstResponder()
  }
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  override func viewDidLoad() {
    self.emailField.delegate = self
    self.passwordField.delegate = self
    emailField.returnKeyType = UIReturnKeyType.done
    passwordField.returnKeyType = UIReturnKeyType.done
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    if (FIRAuth.auth()?.currentUser) != nil {
    if let user = FIRAuth.auth()?.currentUser {
      self.signedIn(user)
      self.showAllSportsHome()
    }

  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField != self.emailField {
      self.becomeFirstResponder()
    }
    return true
  }
  
  @IBAction func didTapSignIn(_ sender: AnyObject) {
    // Sign In with credentials.
    guard let email = emailField.text, let password = passwordField.text else { return }
    FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      self.signedIn(user!)
      self.showAllSportsHome()
      
    }
  }
  
  @IBAction func didTapSignUp(_ sender: AnyObject) {
    
    guard let email = emailField.text, let password = passwordField.text else { return }
    
    FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      self.setDisplayName(user!)
      //create user home ref
      self.writeUserData(userId: (user?.uid)!, name: "", email: email, imageUrl: nil)
      self.showAllSportsHome()
    }
  }
  func showAllSportsHome() {
    
     if let tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idTabBarController") as? UITabBarController {
        self.present(tabBar, animated: true, completion: nil)
    }
  }
  
  func writeUserData(userId: String, name: String, email: String, imageUrl: UIImage?) {
    
    
//    FIRDatabase.database().ref("users/" + userId).setValue()
    
//    { username: name,
//            email: email,
//            profile_picture : imageUrl}
    if let user = FIRAuth.auth()?.currentUser {
      let refString:String = "users/" + user.uid
      let ref = FIRDatabase.database().reference(withPath: refString )
      
//      let matchItem =
//        MatchItem(name: "MatchItem added thru signin",
//                  addedByUser: "jerodunsch@gmail.com",
//                  completed: false)
//      let matchItemRef =
//        ref.child(user.uid.lowercased())
//      matchItemRef.
      let profile = UserProfile(name: userId, email: email)
      ref.setValue(profile.toAnyObject())
      
    }

  }

  func setDisplayName(_ user: FIRUser) {
    let changeRequest = user.profileChangeRequest()
    changeRequest.displayName = user.email!.components(separatedBy: "@")[0]
    changeRequest.commitChanges(){ (error) in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      self.signedIn(FIRAuth.auth()?.currentUser)
    }
  }

  @IBAction func didRequestPasswordReset(_ sender: AnyObject) {
    let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: .alert)
    let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
      let userInput = prompt.textFields![0].text
      if (userInput!.isEmpty) {
        return
      }
      FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
        if let error = error {
          print(error.localizedDescription)
          return
        }
      }
    }
    prompt.addTextField(configurationHandler: nil)
    prompt.addAction(okAction)
    present(prompt, animated: true, completion: nil);
  }

  func signedIn(_ user: FIRUser?) {
    
    MeasurementHelper.sendLoginEvent()

    AppState.sharedInstance.displayName = user?.displayName ?? user?.email
    AppState.sharedInstance.photoURL = user?.photoURL
    AppState.sharedInstance.signedIn = true
    let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
    NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
//    performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)

 }

}
