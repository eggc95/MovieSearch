import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    let keychainManager = CredentialsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keychainManager.saveCredentials(username: "VVVBB", password: "@bcd1234")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            showAlert(message: "Please enter both username and password.")
            return
        }
        
        if let savedPassword = keychainManager.retrievePassword(username: username), savedPassword == password {
            showAlert(message: "Sign in successful!")
         
        } else {
            showAlert(message: "Invalid username or password.")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Perform the segue to navigate to the next screen
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goToSearch", sender: self)
                }
            }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

