//
//  newchatcellTableViewCell.swift
//  ATChat
//
//  Created by komal on 4/21/17.
//  Copyright © 2017 komal. All rights reserved.
//

import UIKit

class newchatcellTableViewCell: UITableViewCell {

    
    @IBOutlet var newchatbg: UIImageView!
    @IBOutlet var sendertime: UILabel!
   
    @IBOutlet var lblmsg1: UILabel!
   
    @IBOutlet var sendertblvwcellimg: UIImageView!
    
    
    
    
 //   @IBOutlet var reciverimgvw: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /* sendertblvwcellimg.layer.cornerRadius = sendertblvwcellimg.frame.size.width/2
         sendertblvwcellimg.clipsToBounds = true
         sendertblvwcellimg.layer.borderColor = UIColor.black.cgColor
         sendertblvwcellimg.layer.borderWidth = 1*/

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
