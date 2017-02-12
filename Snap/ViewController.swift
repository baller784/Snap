//
//  ViewController.swift
//  Snap
//
//  Created by Daniel Marcenco on 10/10/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit
import SnapKit
import Realm
import RealmSwift
import Firebase

class ViewController: UIViewController {
    fileprivate let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: EventListTableViewCell.reuseIdentifier)
        tableView.estimatedRowHeight = EventListTableViewCell.defaultHeight
        tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.01))
        return tableView
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()

    let now = Date(timeIntervalSinceNow: 0)
    var currentCreateAction: UIAlertAction!

    var user: FIRUser!
    var ref: FIRDatabaseReference!
    var notification: NotificationToken?

    var lists: Results<EventList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = FIRAuth.auth()?.currentUser
        self.ref = FIRDatabase.database().reference()
        lists = RealmList.objects
        setup()
        setupTableView()
        updateUI()
        setupLongPress()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    fileprivate func updateUI() {
        notification = lists.addNotificationBlock {[weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }

            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, _):

                tableView.beginUpdates()

                tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                                     with: .automatic)

                tableView.endUpdates()
                break
            case .error(let error):
                print(error)
                break
            }
        }
    }
    
    func listNameFieldDidChange(textField: UITextField){
        self.currentCreateAction.isEnabled = textField.text!.characters.count > 0
    }
    
    @objc func addEventListAlert() {
        let alertController = UIAlertController(title: "New List", message: "Add new event list", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let inputTextField = alertController.textFields![0] as UITextField
            
            if inputTextField.text!.characters.count > 0 {
                let newList = EventList()
                newList.guid = UUID().uuidString
                newList.name = inputTextField.text!
                newList.userGuid = self.ref.child("users").child(self.user.uid).key

                try! RealmManager.performRealmWriteTransaction {
                    if !RealmModel.save(newList) {
                        print("error")
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func editListPressed() {
        
    }

    func openAddEventVC(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewEventVC") as? NewEventVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    @objc fileprivate func logoutPressed() {
        let message = "What? Are you leaving us?"
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true, completion: nil)
            AppDelegate.main.switchToSignInScreen()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        [logOutAction, cancelAction].forEach { controller.addAction($0) }

        self.present(controller, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let eventTasks = lists {
            return eventTasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventListTableViewCell.reuseIdentifier, for: indexPath) as! EventListTableViewCell
        let list = lists[indexPath.row]
        
        cell.eventName.text = list.name
        cell.infoLabel.text = list.events.count > 1 || list.events.count == 0 ? "\(list.events.count) events" : "\(list.events.count) event"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let eventVC = EventViewController.storyboardInstance(withTitle: lists[indexPath.row].name) as! EventViewController
        eventVC.selectedList = lists[indexPath.row]
        navigationController?.pushViewController(eventVC, animated: true)
    }
}

// MARK: - Layout
extension ViewController {
    func layout() {
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(60)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.center.equalTo(bottomView.center)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
}

// MARK: - Setup
extension ViewController {
    fileprivate func setup() {
        title = "Events"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEventListAlert))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editListPressed))
        view.addSubview(bottomView)
        bottomView.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(logoutPressed), for: .touchUpInside)
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    fileprivate func setupLongPress() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        tableView.addGestureRecognizer(lpgr)
    }
    
    func handleLongPress(_ gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            return
        }
        
        let p = gestureReconizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: p)
        
        if let index = indexPath {
            _ = tableView.cellForRow(at: index)
            print(index.row)
            
            let listToBeDeleted = lists[index.row]
            try! RealmManager.performRealmWriteTransaction {
                if !RealmList.delete(listToBeDeleted) {
                    print("cannot delete upcoming event")
                }
            }
        } else {
            print("Could not find index path")
        }
    }
}
