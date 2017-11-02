//
//  tabbarVC.swift
//  Meme
//
//  Created by MAH on 08.6.17.
//  Copyright © 2017 MAH. All rights reserved.
//

import UIKit
import Parse


// global variables of icons
var icons = UIScrollView()
var corner = UIImageView()
var dot = UIView()

// custom tabbar button
let tabBarPostButton = UIButton()

class tabbarVC: UITabBarController {
    
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // color of item
        self.tabBar.tintColor = .whiteColor()
        
        // color of background
        self.tabBar.barTintColor = UIColor(red: 37.0 / 255.0, green: 39.0 / 255.0, blue: 42.0 / 255.0, alpha: 1)
        
        // disable translucent
        self.tabBar.translucent = false
        
        
        // create dot
        dot.frame = CGRectMake(self.view.frame.size.width / 5 * 3, self.view.frame.size.height - 5, 7, 7)
        dot.center.x = self.view.frame.size.width / 5 * 3 + (self.view.frame.size.width / 5) / 2
        dot.backgroundColor = UIColor(red: 255/255, green: 89/255, blue: 85/255, alpha: 1)
        dot.layer.cornerRadius = dot.frame.size.width / 2
        dot.hidden = true
        self.view.addSubview(dot)
        
        
        // call function of all type of notifications
        query(["like"], image: UIImage(named: "likeIcon.png")!)
        query(["follow"], image: UIImage(named: "followIcon.png")!)
        query(["mention", "comment"], image: UIImage(named: "commentIcon.png")!)
        
        
        // hide icons objects
        UIView.animateWithDuration(1, delay: 8, options: [], animations: { () -> Void in
            icons.alpha = 0
            corner.alpha = 0
            dot.alpha = 0
            }, completion: nil)
        
    }
    
    
    // multiple query
    func query (type:[String], image:UIImage) {
        
        let query = PFQuery(className: "news")
        query.whereKey("to", equalTo: PFUser.currentUser()!.username!)
        //query.whereKey("checked", equalTo: "no")
        query.whereKey("type", containedIn: type)
        query.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            if error == nil {
                if count > 0 {
                    self.placeIcon(image, text: "\(count)")
                }
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    
    // multiple icons
    func placeIcon (image:UIImage, text:String) {
        
        // create separate icon
        let view = UIImageView(frame: CGRectMake(icons.contentSize.width, 0, 50, 35))
        view.image = image
        icons.addSubview(view)
        
        // create label
        let label = UILabel(frame: CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height))
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        label.text = text
        label.textAlignment = .Center
        label.textColor = .whiteColor()
        view.addSubview(label)
        
        // update icons view frame
        icons.frame.size.width = icons.frame.size.width + view.frame.size.width - 4
        icons.contentSize.width = icons.contentSize.width + view.frame.size.width - 4
        icons.center.x = self.view.frame.size.width / 5 * 4 - (self.view.frame.size.width / 5) / 4
        
        // unhide elements
        corner.hidden = false
        dot.hidden = false
    }
    
    
    // clicked upload button (go to upload)
    func upload(sender : UIButton) {
        self.selectedIndex = 2
    }
    
}