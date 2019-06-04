//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        

        
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: self.emailTextfield.text!, password: self.passwordTextfield.text!) { (user, error) in
            if error != nil {
                print("error")
            } else {
                print("registration successful")
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            
        }
        

        
        
    } 
    
    
}
