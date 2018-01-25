//
//  sidebarcell.swift
//  Swift_interviewApp
//
//  Created by heli on 11/18/16.
//  Copyright © 2016 com.zaptechsolution. All rights reserved.
//

import UIKit

class sidebarcell: UITableViewCell {

    @IBOutlet var lbl_sidebar: UILabel!
    @IBOutlet var img_sidebar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
