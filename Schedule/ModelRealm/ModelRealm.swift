//
//  Model.swift
//  Schedule
//
//  Created by Никита Ничепорук on 8/28/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import Foundation
import RealmSwift

final class ModelRealm: Object {
    @objc dynamic var scheduleDate = Date()
    @objc dynamic var scheduleTime = Date()
    @objc dynamic var scheduleName: String = ""
    @objc dynamic var sceduleLocation: String = ""
    @objc dynamic var scheduleDifficult: String = ""
    @objc dynamic var scheduleImportance: String = ""
}
