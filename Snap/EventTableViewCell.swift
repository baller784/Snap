//
//  EventTableViewCell.swift
//  Snap
//
//  Created by Daniel Marcenco on 11/16/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit
import SnapKit

class EventTableViewCell: UITableViewCell {
    
    var eventName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0)
        return label
    }()
    var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "20.02.16"
        return label
    }()
    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    static var defaultHeight: CGFloat {
        return 60.0
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [eventName, dateLabel, infoLabel].forEach { addSubview($0) }
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        eventName.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(eventName.snp.bottom).offset(5)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(eventName.snp.centerYWithinMargins)
        }
    }
    
//    func set(event: EventModel) {
//        eventName.text = event.name
//        dateLabel.text = DateUtils.convertDate(date: event.date)
//        infoLabel.text = event.info
//        eventName.sizeToFit()
//        dateLabel.sizeToFit()
//        infoLabel.sizeToFit()
//    }
}

