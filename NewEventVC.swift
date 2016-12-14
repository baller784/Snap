//
//  NewEventVC.swift
//  Snap
//
//  Created by Daniel Marcenco on 10/11/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit
import SnapKit
import Realm
import RealmSwift

protocol NewEventVCDelegate: class {
    func reloadList(with newEvent: EventModel)
}

class NewEventVC: UIViewController {
    fileprivate let nameTextField = UITextField()
    fileprivate let dateTextField = UITextField()
    fileprivate let infoTextField = UITextField()
    fileprivate let sendButton    = UIButton()

    weak var delegate: NewEventVCDelegate?
    let vc: EventViewController? = EventViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupItems()
        layout()
    }

    @objc fileprivate func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc fileprivate func sendPressed() {
        let addedEvent = EventModel()
        addedEvent.guid = UUID().uuidString
        addedEvent.name = nameTextField.text!
        addedEvent.info = infoTextField.text!

        delegate?.reloadList(with: addedEvent)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup
extension NewEventVC {
    func setup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    }

    func setupItems() {
        nameTextField.borderStyle = .roundedRect
        nameTextField.backgroundColor = UIColor.red
        nameTextField.placeholder = "Enter your name here"

        dateTextField.borderStyle = .roundedRect
        dateTextField.backgroundColor = UIColor.orange
        dateTextField.placeholder = "Choose date"

        infoTextField.borderStyle = .roundedRect
        infoTextField.backgroundColor = UIColor.green
        infoTextField.placeholder = "Write event description"

        sendButton.setTitle("Add to list", for: .normal)
        sendButton.titleLabel?.textColor = UIColor.white
        sendButton.backgroundColor = UIColor.black
        sendButton.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
    }
}

// MARK: - Layout
extension NewEventVC {
    func layout() {
        self.view.addSubview(nameTextField)
        self.view.addSubview(dateTextField)
        self.view.addSubview(infoTextField)
        self.view.addSubview(sendButton)

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.topLayoutGuide.snp.top).offset(80)
            make.left.equalTo(self.view.snp.left).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-10)
        }

        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(40)
            make.left.equalTo(self.view.snp.left).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-10)
        }

        infoTextField.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(40)
            make.left.equalTo(self.view.snp.left).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-10)
        }

        sendButton.snp.makeConstraints { make in
            make.top.equalTo(infoTextField.snp.bottom).offset(40)
            make.left.equalTo(self.view.snp.left).offset(50)
            make.right.equalTo(self.view.snp.right).offset(-50)
        }
    }
}
