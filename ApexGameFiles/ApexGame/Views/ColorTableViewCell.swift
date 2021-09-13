//
//  ColorTableViewCell.swift
//  ApexGame
//
//  Created by Adam Abdalla on 4/24/20.
//  Copyright © 2020 Adam Abdalla. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    @IBOutlet weak var gradientStack: UIStackView!
    @IBOutlet weak var useButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
