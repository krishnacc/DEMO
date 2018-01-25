//
//  ChatTableViewCell.swift
//  ATChat
//
//  Created by komal on 3/22/17.
//  Copyright © 2017 komal. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    
    @IBOutlet var imgvw: UIImageView!
    
    @IBOutlet var lblname: UILabel!
    
    @IBOutlet var lbllastname: UILabel!
    
    @IBOutlet var lblemail: UILabel!
    override func awakeFromNib() {
       
        super.awakeFromNib()
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
