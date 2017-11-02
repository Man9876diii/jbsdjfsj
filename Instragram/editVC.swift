//
//  editVC.swift
//  Meme
//
//  Created by MAH on 08.6.17.
//  Copyright © 2017 MAH. All rights reserved.
//

import UIKit
import Parse


class editVC: UIViewController, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UI objects
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextView!
    
    
    
    // value to hold keyboard frmae size
    var keyboard = CGRect()
    
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check notifications of keyboard - shown or not
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(editVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(editVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(editVC.hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // tap to choose image
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(editVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.userInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        // call alignment function
        alignment()
        
        // call information function
        information()
    }
    
    
    // func to hide keyboard
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    // func when keyboard is shown
    func keyboardWillShow(notification: NSNotification) {
        
        // define keyboard frame size
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
        
        // move up with animation
        UIView.animateWithDuration(0.4) { () -> Void in
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2
        }
    }
    
    
    // func when keyboard is hidden
    func keyboardWillHide(notification: NSNotification) {
        
        // move down with animation
        UIView.animateWithDuration(0.4) { () -> Void in
            self.scrollView.contentSize.height = 0
        }
    }
    
    
    // func to call UIImagePickerController
    func loadImg (recognizer : UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    // method to finilize our actions with UIImagePickerController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // alignment function
    func alignment() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        scrollView.frame = CGRectMake(0, 0, width, height)
        
        avaImg.frame = CGRectMake(148, 10, 80, 80)
        fullnameTxt.frame = CGRectMake(10, avaImg.frame.origin.y + 100, width - 20, 45)
        usernameTxt.frame = CGRectMake(10, fullnameTxt.frame.origin.y + 50, width - 20, 45)
        webTxt.frame = CGRectMake(10, usernameTxt.frame.origin.y + 50, width - 20, 45)
        bioTxt.frame = CGRectMake(10, webTxt.frame.origin.y + 50, width - 20, 100)
        
    }
    
    
    // user information function
    func information() {
        
        // receive profile picture
        let ava = PFUser.currentUser()?.objectForKey("ava") as! PFFile
        ava.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            self.avaImg.image = UIImage(data: data!)
        }
        
        // receive text information
        usernameTxt.text = PFUser.currentUser()?.username
        fullnameTxt.text = PFUser.currentUser()?.objectForKey("fullname") as? String
        bioTxt.text = PFUser.currentUser()?.objectForKey("bio") as? String
        webTxt.text = PFUser.currentUser()?.objectForKey("web") as? String
        
    }
    
    // regex restrictions for email textfield
    func validateEmail (email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
        let range = email.rangeOfString(regex, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    // regex restrictions for web textfield
    func validateWeb (web : String) -> Bool {
        let regex = "www.+[A-Z0-9a-z._%+-]+.[A-Za-z]{2}"
        let range = web.rangeOfString(regex, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    
    // alert message function
    func alert (error: String, message : String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // clicked save button
    @IBAction func save_clicked(sender: AnyObject) {
        
        // save filled in information
        let user = PFUser.currentUser()!
        user.username = usernameTxt.text?.lowercaseString
        user["fullname"] = fullnameTxt.text?.lowercaseString
        user["web"] = webTxt.text?.lowercaseString
        user["bio"] = bioTxt.text
        
        // send profile picture
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        // send filled information to server
        user.saveInBackgroundWithBlock ({ (success:Bool, error:NSError?) -> Void in
            if success{
                
                // hide keyboard
                self.view.endEditing(true)
                
                // dismiss editVC
                self.dismissViewControllerAnimated(true, completion: nil)
                
                // send notification to homeVC to be reloaded
                NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
                
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
    
    
    // clicked cancel button
    @IBAction func cancel_clicked(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // PICKER VIEW METHODS
    // picker comp numb
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
}