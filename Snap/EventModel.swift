//
//  EventModel.swift
//  Snap
//
//  Created by Daniel Marcenco on 10/11/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import Realm
import RealmSwift

typealias RealmEvent = RealmModel<EventModel>

class EventModel: Object {
    dynamic var guid: String = ""
    dynamic var name = ""
    dynamic var date = Date()
    dynamic var info = ""
    dynamic var isCompleted = false
    dynamic var listGuid: String = ""

    override static func primaryKey() -> String? {
        return #keyPath(EventModel.guid)
    }

    var list: Results<EventList> {
        return RealmList.where("guid = %@", listGuid)
    }
}
