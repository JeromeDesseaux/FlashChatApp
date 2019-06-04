//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var messages : [Message] = [Message]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = self.messages[indexPath.row].messageBody
        cell.senderUsername.text = self.messages[indexPath.row].sender
        return cell
    }
    
    
    // Declare instance variables here

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        self.messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        
        //TODO: Set yourself as the delegate of the text field here:
        self.messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        

        //TODO: Register your MessageCell.xib file here:

        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    
    
    //TODO: Declare configureTableView here:
    func configureTableView(){
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.heightConstraint.constant = 308
//        let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//        view.layoutIfNeeded()
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
    }

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name:        UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func retrieveMessages(){
        let messageDb = Database.database().reference().child("messages")
        
        messageDb.observe(.childAdded) { (snapshot) in
            let value = snapshot.value as! Dictionary<String,String>
            
//            print(value)
            
            let text = value["messageBody"]!
            let sender = value["sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messages.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
            
        }
    }
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        
        //TODO: Send the message to Firebase and save it in our database
        self.messageTextfield.endEditing(true)
        
        self.messageTextfield.isEnabled = false
        self.sendButton.isEnabled = false
        
        let messageDb = Database.database().reference().child("messages")
        
        let message = ["sender":Auth.auth().currentUser?.email,
                       "messageBody":messageTextfield.text!]
        
        messageDb.childByAutoId().setValue(message){
            (error, reference) in
            if error != nil {
                print("error saving message")
            }else{
                print("message saved")
            }
            self.messageTextfield.isEnabled = true
            self.sendButton.isEnabled = true
        }
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("There was an error")
        }
        
    }

    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            heightConstraint.isActive = false
            view.layoutIfNeeded()
            return
        }
        let duration: TimeInterval = ((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue) ?? 0.4

        var safeAreaBottomInset:CGFloat = 0;
        if #available(iOS 11.0, *) {
            safeAreaBottomInset = self.view.safeAreaInsets.bottom;
        }
        self.heightConstraint.constant += (keyboardSize.height - safeAreaBottomInset);

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        let duration: TimeInterval = ((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue) ?? 0.4
        heightConstraint.constant = 50
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    


}
