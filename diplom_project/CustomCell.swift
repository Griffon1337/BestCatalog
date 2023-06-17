//
//  CustomCell.swift
//  diplom_project
//
//  Created by Грифон on 28.05.23.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var customCellName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

