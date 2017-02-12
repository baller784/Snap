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
import UserNotifications

protocol NewEventVCDelegate: class {
    func reloadList(with newEvent: EventModel)
}

class NewEventVC: UIViewController {
    fileprivate let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10.0
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()

    fileprivate let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.red
        textField.placeholder = "Enter your name here"
        return textField
    }()
    fileprivate let infoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.green
        textField.placeholder = "Write event description"
        return textField
    }()
    fileprivate let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    fileprivate let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to list", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.backgroundColor = UIColor.black
        return button
    }()

    fileprivate var ymdDateFormatter: DateFormatter! = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd"
        return formatter
    }()

    weak var delegate: NewEventVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UNUserNotificationCenter.current().delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    @objc fileprivate func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc fileprivate func sendPressed() {
        let addedEvent = EventModel()
        addedEvent.guid = UUID().uuidString
        addedEvent.name = nameTextField.text!
        addedEvent.info = infoTextField.text!
        addedEvent.date = datePicker.date

        delegate?.reloadList(with: addedEvent)
        NotificationManager.shared.addNotification(addedEvent.name, description: addedEvent.info, type: .image)
        dismiss(animated: true, completion: nil)
    }

    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Snap", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Setup
extension NewEventVC {
    func setup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        sendButton.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
    }
}

// MARK: - Layout
extension NewEventVC {
    func layout() {
        view.addSubview(stackView)
        [nameTextField, infoTextField, datePicker, sendButton].forEach { stackView.addArrangedSubview($0) }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80.0)
            make.width.equalToSuperview()
        }

        nameTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(40.0)
        }

        infoTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(40.0)
        }

        sendButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(40.0)
        }
    }
}

extension NewEventVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "firstOption":
            self.showAlert("You pressed on first option! 🤖")
        case "secondOption":
            self.showAlert("You pressed on second option! 🇲🇩")
        default:
            break
        }
    }
}
