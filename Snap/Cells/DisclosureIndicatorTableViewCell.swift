//
//  DisclosureIndicatorTableViewCell.swift
//  Snap
//
//  Created by Daniel Marcenco on 11/23/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit

class DisclosureIndicatorTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
