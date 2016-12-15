//
//  EventList.swift
//  Snap
//
//  Created by Daniel Marcenco on 11/14/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import Realm
import RealmSwift

typealias RealmList = RealmModel<EventList>

class EventList: Object {
    dynamic var guid: String = ""
    dynamic var name = ""
    dynamic var date = Date()
    dynamic var userGuid: String = ""

    override static func primaryKey() -> String? {
        return #keyPath(EventList.guid)
    }

    var events: Results<EventModel> {
        return RealmEvent.where("listGuid = %@", guid)
    }
}
