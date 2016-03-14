//
//  myTableViewCell.swift
//  EnglishDiary
//
//  Created by 三浦宏予 on 2016/03/14.
//  Copyright © 2016年 Hiroyo Miura. All rights reserved.
//

import UIKit

class myTableViewCell: UITableViewCell {

    @IBOutlet var firstImage: UIImageView!
    @IBOutlet var firstDate: UILabel!
    @IBOutlet var firstTitle: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
