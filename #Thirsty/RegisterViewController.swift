//
//  RegisterViewController.swift
//  #Thirsty
//
//  Created by Omar Baradei on 3/14/17.
//  Copyright © 2017 Omar Baradei. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    
    var cameFromLogin = false
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var userTypeSegmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = "Register"

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if cameFromLogin {
            self.navigationController?.viewControllers.remove(at: 1)
        }
    }
    
    @IBAction func registerRequested(_ sender: Any) {
        // check if all things are filled out, then check to see if all are valid
        if usernameTextField.text?.characters.count == 0 || emailTextField.text?.characters.count == 0 || passwordTextField.text?.characters.count == 0 || confirmPassTextField.text?.characters.count == 0 {
            displayError(for: nil, error: "One or more text fields are empty.")
        } else if !isValidEmail(testStr: emailTextField.text!) {
            displayError(for: emailTextField, error: "Email provided is invalid.")
        } else if passwordTextField.text != confirmPassTextField.text {
            displayError(for: confirmPassTextField, error: "Password fields do not match.")
        } else {
            performSegue(withIdentifier: "unwindToWelcomeSegue", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToWelcomeSegue" {
            let nav = segue.destination as! WelcomeViewController
            nav.didRegisterSuccessfully = true
            
            // put new user information into database
            let newUser = WelcomeViewController.userDB.child((usernameTextField.text)!)
            
            var userType: String!
            switch userTypeSegmented.selectedSegmentIndex {
            case 0:
                userType = "User"
            case 1:
                userType = "Worker"
            case 2:
                userType = "Admin"
            case 3:
                userType = "Manager"
            default:
                break
            }
            let userInfo = ["Password": passwordTextField.text, "Email": emailTextField.text, "User Type": userType]
            newUser.setValue(userInfo)
        }
    }
    
    func displayError(for field: UITextField?, error issue: String) {
        let ac = UIAlertController(title: "Error Registering", message: "\(issue)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> () in
            if let realField = field {
                if realField == self.confirmPassTextField {
                    self.confirmPassTextField.text?.removeAll()
                }
                realField.becomeFirstResponder()
            }
        }))
        present(ac, animated: true)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}
