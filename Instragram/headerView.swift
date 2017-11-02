//
//  headerView.swift
//  Meme
//
//  Created by MAH on 08.6.17.
//  Copyright © 2017 MAH. All rights reserved.
//

import UIKit
import Parse


class headerView: UICollectionReusableView {
    
    // UI objects
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var webTxt: UITextView!
    @IBOutlet weak var bioLbl: UILabel!
    
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingsTitle: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.mainScreen().bounds.width
        
        avaImg.frame = CGRectMake(148, 10, 80, 80)
        button.frame = CGRectMake(98, avaImg.frame.origin.y + 80, 186, 28)
        followers.frame = CGRectMake(50, 33, 50, 21)
        followersTitle.frame = CGRectMake(50, 50, 51, 21)
        followingsTitle.frame = CGRectMake(264, 50, 60, 21)
        followings.frame = CGRectMake(268, 33, 50, 21)
        fullnameLbl.frame = CGRectMake(10, button.frame.origin.y + 40, width - 20, 21)
        webTxt.frame = CGRectMake(10, fullnameLbl.frame.origin.y + 15, width - 20, 34)
        bioLbl.frame = CGRectMake(10, webTxt.frame.origin.y + 15, width - 20, 68)
        
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        
        
    }
    
    
    // clicked follow button from GuestVC
    @IBAction func followBtn_clicked(sender: AnyObject) {
        
        let title = button.titleForState(.Normal)
        
        // to follow
        if title == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.currentUser()?.username
            object["following"] = guestname.last!
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if success {
                    self.button.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    self.button.backgroundColor = UIColor.redColor()
                    
                    // send follow notification
                    let newsObj = PFObject(className: "news")
                    newsObj["by"] = PFUser.currentUser()?.username
                    newsObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
                    newsObj["to"] = guestname.last
                    newsObj["owner"] = ""
                    newsObj["uuid"] = ""
                    newsObj["type"] = "follow"
                    newsObj["checked"] = "no"
                    newsObj.saveEventually()
                    
                    
                } else {
                    print(error?.localizedDescription)
                }
            })
            
            // unfollow
        } else {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("following", equalTo: guestname.last!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                            if success {
                                self.button.setTitle("FOLLOW", forState: UIControlState.Normal)
                                self.button.backgroundColor = .lightGrayColor()
                                
                                
                                // delete follow notification
                                let newsQuery = PFQuery(className: "news")
                                newsQuery.whereKey("by", equalTo: PFUser.currentUser()!.username!)
                                newsQuery.whereKey("to", equalTo: guestname.last!)
                                newsQuery.whereKey("type", equalTo: "follow")
                                newsQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                                    if error == nil {
                                        for object in objects! {
                                            object.deleteEventually()
                                        }
                                    }
                                })
                                
                                
                            } else {
                                print(error?.localizedDescription)
                            }
                        })
                    }
                    
                } else {
                    print(error?.localizedDescription)
                }
            })
            
        }
        
    }
    
}