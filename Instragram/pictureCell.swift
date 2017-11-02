//
//  pictureCell.swift
//  Meme
//
//  Created by MAH on 08.6.17.
//  Copyright © 2017 MAH. All rights reserved.
//

import UIKit

class pictureCell: UICollectionViewCell {
    
    // holds post picture
    @IBOutlet weak var picImg: UIImageView!
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.mainScreen().bounds.width
        picImg.frame = CGRectMake(0, 0, width / 3, width / 3)
    }
    
}
