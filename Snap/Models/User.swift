//
//  User.swift
//  Snap
//
//  Created by Daniel Marcenco on 12/15/16.
//  Copyright © 2016 Dan Marcenco. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

typealias RealmUser = RealmModel<User>

final class User: Object {
    dynamic var guid: String = ""
    dynamic var id: Int = 0
    dynamic var email: String = ""
    dynamic var name: String = ""
    dynamic var password: String = ""

    func logOut() {
        try? RealmManager.performRealmWriteTransaction {
            RealmManager.defaultRealm.deleteAll()
        }
    }

    static var current: User? {
        return RealmUser.objects.last
    }
}
