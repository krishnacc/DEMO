//
//  NotesTableViewCell.swift
//  ATChat
//
//  Created by komal on 3/31/17.
//  Copyright © 2017 komal. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
//MARK: OUTLET
    @IBOutlet var lblnotesname: UILabel!
    @IBOutlet var lbldisc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
