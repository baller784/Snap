
//
//  EventListTableViewCell.swift
//  Snap
//
//  Created by Daniel Marcenco on 10/11/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit
import SnapKit

class EventListTableViewCell: DisclosureIndicatorTableViewCell {
    var eventName = UILabel()
    var dateLabel = UILabel()
    var infoLabel = UILabel()
    
    static var reuseIdentifier: String {
        return "EventCell"
    }
    
    static var defaultHeight: CGFloat {
        return 60.0
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [eventName, infoLabel].forEach { addSubview($0) }
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(_ list: EventList) {
        eventName.text = list.name
        dateLabel.text = DateUtils.convertDate(date: list.date)
    }
    
    func layout() {
        eventName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(20)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-7)
            make.top.equalTo(eventName.snp.bottom).offset(10)
        }
    }
}
