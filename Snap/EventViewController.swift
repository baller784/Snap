//
//  EventViewController.swift
//  Snap
//
//  Created by Daniel Marcenco on 11/15/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class EventViewController: UIViewController {
    let realm = try! Realm()
    fileprivate var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.estimatedRowHeight = EventListTableViewCell.defaultHeight
        tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.01))
        return tableView
    }()
    
    var selectedList: EventList!
    var upcomingEvents: Results<EventModel>!
    var finishedEvents: Results<EventModel>!

    var event: EventModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEventPressed))
        upcomingEvents = selectedList.events.filter("isCompleted = false")
        finishedEvents = selectedList.events.filter("isCompleted = true")
        self.title = selectedList.name
        setupTableView()
    }

    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.height.width.equalToSuperview()
        }
    }
    
    @objc func addEventPressed() {
        let addEventVC = NewEventVC.storyboardInstance(withTitle: "New Event") as! NewEventVC
        addEventVC.delegate = self
        let eventNavVC = UINavigationController(rootViewController: addEventVC)
        self.present(eventNavVC, animated: true, completion: nil)
    }

}

// MARK: - TableViewDataSource
extension EventViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return upcomingEvents.count
        }
        return finishedEvents.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Upcoming Events"
        }
        return "Finished Events"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! EventTableViewCell
        
        if indexPath.section == 0 {
            event = upcomingEvents[indexPath.row]
        } else {
            event = finishedEvents[indexPath.row]
        }
        
        cell.eventName.text = event.name
        cell.infoLabel.text = event.info
        cell.dateLabel.text = DateUtils.convertDate(date: event.date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            if indexPath.section == 0 {
                let listToBeDeleted = self.upcomingEvents[indexPath.row]
                try! RealmManager.performRealmWriteTransaction {
                    if !RealmEvent.delete(listToBeDeleted) {
                        print("cannot delete upcoming event")
                    }
                }

                tableView.reloadData()
            } else {
                let listToBeDeleted = self.finishedEvents[indexPath.row]
                try! RealmManager.performRealmWriteTransaction {
                    if !RealmEvent.delete(listToBeDeleted) {
                        print("cannot delete upcoming event")
                    }
                }
                tableView.reloadData()
            }
        }
        delete.backgroundColor = UIColor.red
        
        let finish = UITableViewRowAction(style: .normal, title: "Finish") { action, index in
            var eventsToBeUpdated: EventModel!
            if indexPath.section == 0 {
                eventsToBeUpdated = self.upcomingEvents[indexPath.row]
            } else {
                eventsToBeUpdated = self.finishedEvents[indexPath.row]
            }

            try! self.realm.write {
                eventsToBeUpdated.isCompleted = true
                tableView.reloadData()
            }
        }
        finish.backgroundColor = UIColor.blue
        
        if indexPath.section == 0 {
            return [delete, finish]
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - TableViewDelegate
extension EventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EventViewController: NewEventVCDelegate {
    func reloadList(with newEvent: EventModel) {
        newEvent.listGuid = selectedList.guid
        try! RealmManager.performRealmWriteTransaction {
            if !RealmEvent.save(newEvent) {
                print("cannot save new event")
            } else {
                print("success")
            }
        }
        tableView.reloadData()
    }
}
