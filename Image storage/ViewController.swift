

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    
    
    var initialBottomConstraintConstant: CGFloat = 0
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        registerForKeyboardNotifications()
        
        initialBottomConstraintConstant = bottomViewConstraint.constant
        
        
       
    }
    
    
    private func registerForKeyboardNotifications() {
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
      }
    
    
       @objc private func keyboardWillShow(_ notification: NSNotification) {
           guard let userInfo = notification.userInfo,
                 let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
                 let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
           
           if notification.name == UIResponder.keyboardWillHideNotification {
               bottomViewConstraint.constant = 0
           } else {
               bottomViewConstraint.constant = keyboardScreenEndFrame.height + 10
           }
           
           view.needsUpdateConstraints()
           
           UIView.animate(withDuration: animationDuration) {
               self.view.layoutIfNeeded()
           }
       }
       
   }


    

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

