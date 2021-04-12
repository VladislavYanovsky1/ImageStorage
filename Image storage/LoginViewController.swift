

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var test: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let password = "1"


    override func viewDidLoad() {
        super.viewDidLoad()
// test git
        
        // test git 2
        
        
    }
    
    

    @IBAction func test(_ sender: UIButton) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstViewController = storyboard.instantiateViewController(identifier: String(describing:FirstViewController.self)) as FirstViewController
        firstViewController.modalPresentationStyle = .fullScreen
    
        firstViewController.model = CustomImageModel(isLoggedUser: password == passwordTextField.text)
       
        
        
        self.navigationController?.pushViewController(firstViewController, animated: true)
        
        
    }
    
}
