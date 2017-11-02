//
//  signInVC.swift
//  Meme
//
//  Created by MAH on 08.6.17.
//  Copyright © 2017 MAH. All rights reserved.
//

import UIKit
import Parse


class signInVC: UIViewController {
    
    // textfield
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    // buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // alignment
        label.frame = CGRectMake(10, 80, self.view.frame.size.width - 20, 50)
        usernameTxt.frame = CGRectMake(10, label.frame.origin.y + 100, self.view.frame.size.width - 20, 45)
        passwordTxt.frame = CGRectMake(10, usernameTxt.frame.origin.y + 50, self.view.frame.size.width - 20, 45)
        signInBtn.frame = CGRectMake(10, passwordTxt.frame.origin.y + 60, self.view.frame.size.width - 20, 45)
        signUpBtn.frame = CGRectMake(10, signInBtn.frame.origin.y + 50, self.view.frame.size.width - 20, 45)
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signInVC.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
    }
    
    
    // hide keyboard func
    func hideKeyboard(recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    // clicked sign in button
    @IBAction func signInBtn_click(sender: AnyObject) {
        print("sign in pressed")
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if textfields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            // show alert message
            let alert = UIAlertController(title: "Please", message: "fill in all fields", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        // login functions
        PFUser.logInWithUsernameInBackground(usernameTxt.text!, password: passwordTxt.text!) { (user:PFUser?, error:NSError?) -> Void in
            if error == nil {
                
                // remember user or save in App Memeory did the user login or not
                NSUserDefaults.standardUserDefaults().setObject(user!.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                // call login function from AppDelegate.swift class
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
                
            } else {
                
                // show alert message
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }
    
}