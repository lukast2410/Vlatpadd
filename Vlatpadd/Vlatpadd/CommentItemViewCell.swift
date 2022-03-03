//
//  CommentItemViewCell.swift
//  Vlatpadd
//
//  Created by Lukas Tanto on 13/01/22.
//  Copyright © 2022 Lukas Tanto. All rights reserved.
//

import UIKit

class CommentItemViewCell: UITableViewCell {
    @IBOutlet var usernameLbl: UILabel!
    @IBOutlet var contentTV: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
