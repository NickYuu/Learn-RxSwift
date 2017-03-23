//
//  RepositoryInfoTableViewCell.swift
//  RxNetworkDemo
//
//  Created by Tsung Han Yu on 2017/3/22.
//  Copyright © 2017年 Boxue. All rights reserved.
//

import UIKit

class RepositoryInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detail: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
    }
}
