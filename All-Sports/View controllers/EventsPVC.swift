//
//  MyNextViewController.swift
//  PageControl MF
//
//  Created by Jeroen Dunselman on 05/01/2017.
//  Copyright © 2017 Jeroen Dunselman. All rights reserved.
//

import UIKit
import Firebase

class EventsPVC: UIPageViewController, UIPageViewControllerDelegate{
  
  var user: User!
  var matchItemNames: [String]?
  
  var pagesArray:[CardViewController] = []
  let myPageIndex = 0
  let eventCards = SportsCardStore.statsCards()
  public var crudMode:crud.crudMode = crud.crudMode.read
  public var resultText: String?
  public var matchItemKey: String?
  public var currentMatch:MatchItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.dataSource = self
    
    for (index, _) in self.eventCards.enumerated() {
      if let cardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idCardViewControllerEvents") as? CardViewController {
        
        cardViewController.key = self.matchItemKey
        cardViewController.pageIndex = index
        cardViewController.sportsCard = self.eventCards[index]
        self.pagesArray.append(cardViewController)
      }
    }
    self.setViewControllers([self.initialViewController], direction: .forward, animated: false, completion: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    //je kan hier de initial zetten, maar dan reload pag1 bij reload superview
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

// MARK: Page view controller data source
extension EventsPVC: UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerBefore viewController: UIViewController) -> UIViewController? {
    //Simply setting the value of this property is not enough to ensure that the view controller is preserved and restored. All parent view controllers must also have a restoration identifier.
    
    if let viewController = viewController as? CardViewController, let pageIndex = viewController.pageIndex {
      if (pageIndex > 0 ) {
        return viewControllerAtIndex(pageIndex - 1)
      } else {
        return viewControllerAtIndex(pagesArray.count - 1)
      }
    }
    
    return nil
  }
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    if let viewController = viewController as? CardViewController, let pageIndex = viewController.pageIndex {
      if (pageIndex < eventCards.count - 1) {
        return viewControllerAtIndex(pageIndex + 1)
      } else {
        return viewControllerAtIndex(0)
      }
    }
    
    return nil
  }
  
  //niet verplicht, maarrr
  // If nil, user gesture-driven navigation will be disabled.
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return self.eventCards.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    //??wat doet
    //    if let identifier = self.viewControllers?.first?.restorationIdentifier {
    //      if let index = pages.index(of: identifier) {
    //        return index
    //      }
    //    }
    return 0
  }
  
}
extension EventsPVC: ViewControllerProvider {
  
  var initialViewController: UIViewController {
    return viewControllerAtIndex(0)!
  }
  
  func viewControllerAtIndex(_ index: Int) -> UIViewController? {
    return pagesArray[index]
  }
}
extension EventsPVC: UIScrollViewDelegate {
  
  override func viewWillAppear(_ animated: Bool) {
    
    //DidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    // get pageControl and scroll view from view's subviews
    //deze crasht als de pvc op curl staat ipv scroll
    //let pageControl = view.subviews.filter{ $0 is UIPageControl }.first! as! UIPageControl
    guard let pageControl = (view.subviews.filter{ $0 is UIPageControl }.first as? UIPageControl)
      else {
        return
    }
    
    let scrollView = view.subviews.filter{ $0 is UIScrollView }.first! as! UIScrollView
    //    scrollView.delegate = self
    // remove all constraint from view that are tied to pagecontrol
    let const = view.constraints.filter { $0.firstItem as? NSObject == pageControl || $0.secondItem as? NSObject == pageControl }
    view.removeConstraints(const)
    
    // customize pagecontrol
    let heightOfPageControl:CGFloat = 60
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.addConstraint(pageControl.heightAnchor.constraint(equalToConstant: heightOfPageControl))
    pageControl.backgroundColor = view.backgroundColor
    
    // create constraints for pagecontrol
    let leading = pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
    let trailing = pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    
    // position under navcontroller
    var yPosOfPageControl:CGFloat = 0
    if self.navigationController != nil{
      yPosOfPageControl = 65 //self.view.frame.height - 165
    }
    
    let bottom = pageControl.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant:yPosOfPageControl) // add to scrollview not view
    
    // pagecontrol constraint to view
    view.addConstraints([leading, trailing, bottom])
    view.bounds.origin.y -= pageControl.bounds.maxY
    
    pageControl.pageIndicatorTintColor = UIColor.gray
    pageControl.currentPageIndicatorTintColor = UIColor.white
    pageControl.backgroundColor = UIColor.darkGray
    pageControl.numberOfPages = self.eventCards.count
    pageControl.center = self.view.center
    self.view.addSubview(pageControl)
    self.view.setNeedsDisplay()
    //    pageControl.layer.position.y = self.view.frame.height - 200;
  }
  //  func scrollViewDidScroll(scrollView: UIScrollView!) {
  //    // This will be called every time the user scrolls the scroll view with their finger
  //    // so each time this is called, contentOffset should be different.
  //
  ////    print(self.mainScrollView.contentOffset.y)
  //    viewDidLayoutSubviews()
  //    //Additional workaround here.
  //  }
}



//  func getCurrentMatch() {
//    if let user = FIRAuth.auth()?.currentUser {
//      //      user.displayName! +
//      if let itemKey = self.matchItemKey! as String?  {
//
//        let refString:String = "/users/\(user.uid)/match-items/\(itemKey)"
//        //      \((self.sportsCard?.name.lowercased())!
//        let ref = FIRDatabase.database().reference(withPath: refString )
//        ref.observe(.value, with: { snapshot in
//          //        print(snapshot.value)
//          var newItems: [MatchItem] = []
//          let matchItem = snapshot.value as! MatchItem //(snapshot: snapshot.value as! FIRDataSnapshot)
//          // 3
////          for item in snapshot.children {
////            // 4
////            let matchItem = MatchItem(snapshot: item as! FIRDataSnapshot)
////            newItems.append(matchItem)
////          }
////          self.currentMatch = newItems[0]
////          matchItem //
//
//          // 5
////          self.items = newItems
////          self.tableView.delegate = self
////          self.tableView.dataSource = self
////          self.tableView.reloadData()
//
//        })
//
//      }
//    }
//  }

// Do any additional setup after loading the view.
//    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Orange")
////    setViewControllers([vc!], // Has to be a single item array, unless you're doing double sided stuff I believe
//      direction: .forward,
//      animated: true,
//      completion: nil)
