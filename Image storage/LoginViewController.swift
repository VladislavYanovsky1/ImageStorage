

import UIKit
import SwiftyKeychainKit

class LoginViewController: UIViewController {

    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    let keychain = Keychain(service: "passwordStorage")
    let accessTokenKey = KeychainKey<String>(key: "accsesToken")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        do {
            try keychain.set("1", for: accessTokenKey)
        } catch let error {
            debugPrint(error)
        }
    }
    

    @IBAction func loginButtonPressed(_ sender: UIButton) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstViewController = storyboard.instantiateViewController(identifier: String(describing:FirstViewController.self)) as FirstViewController
        firstViewController.modalPresentationStyle = .fullScreen
        do {
            let password = try keychain.get(accessTokenKey)
            firstViewController.model = CustomImageModel(isLoggedUser:  password == passwordTextField.text)
        } catch let error {
            debugPrint(error)
        }
        self.navigationController?.pushViewController(firstViewController, animated: true)
    }
    
}
