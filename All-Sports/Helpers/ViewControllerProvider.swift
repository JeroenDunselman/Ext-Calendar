

import UIKit

protocol ViewControllerProvider {
  var initialViewController: UIViewController { get }
  func viewControllerAtIndex(_ index: Int) -> UIViewController?
}
