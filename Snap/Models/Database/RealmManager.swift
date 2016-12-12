//
//  RealmManager.swift
//  Snap
//
//  Created by Daniel Marcenco on 12/7/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    private static var shared = RealmManager()
    private var realm: Realm? = nil

    static var defaultRealm: Realm {
        if let realm = shared.realm {
            return realm
        }
        let config = Realm.Configuration.defaultConfiguration
        do {
            shared.realm = try Realm(configuration: config)
            return shared.realm!
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }

    class func insideRealmWriteTransaction(block: (Realm) throws -> ()) -> Bool {
        let realm = self.defaultRealm
        do {
            try block(realm)
            return true
        } catch {
            realm.cancelWrite()
            return false
        }
    }

    class func performRealmWriteTransaction(block: () throws -> ()) throws {
        var rethrowable: Swift.Error?
        do {
            try self.defaultRealm.write {
                do {
                    try block()
                } catch let error {
                    self.defaultRealm.cancelWrite()
                    rethrowable = error
                }
            }
        } catch let error {
            rethrowable = error
        }
        if let error = rethrowable {
            throw(error)
        }
    }
}
