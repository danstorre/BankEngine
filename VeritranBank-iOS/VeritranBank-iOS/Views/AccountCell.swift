//
//  AccountCell.swift
//  VeritranBank-iOS
//
//  Created by Daniel Torres on 5/24/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCellWitTitle(_ stringID: String) {
        self.textLabel?.text = stringID
    }

}
