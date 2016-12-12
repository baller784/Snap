//
//  RealmModel.swift
//  Snap
//
//  Created by Daniel Marcenco on 12/8/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

final class RealmModel<T: Object> {
    static var objects: Results<T> {
        return RealmManager.defaultRealm.objects(T.self)
    }

    static func object(from params: [String: Any]) -> T {
        let object = T.init()
        for (key, value) in params {
            if (value is NSNull) {
                continue
            }
            object.setValue(value, forKey: key)
        }
        return object
    }

    static func save(_ object: T) -> Bool {
        return RealmManager.insideRealmWriteTransaction { realm in
            realm.add(object)
        }
    }

    static func update(_ object: T) -> Bool {
        return RealmManager.insideRealmWriteTransaction { realm in
            realm.add(object, update: true)
        }
    }

    static func delete(_ object: T) -> Bool {
        return RealmManager.insideRealmWriteTransaction { realm in
            realm.delete(object)
        }
    }

    static func deleteAll() -> Bool {
        return RealmManager.insideRealmWriteTransaction { realm in
            realm.delete(objects)
        }
    }

    static func `where`(_ format: String, _ args: Any...) -> Results<T> {
        return objects.filter(NSPredicate(format: format, argumentArray: args))
    }

    static var count: Int {
        return objects.count
    }
}
