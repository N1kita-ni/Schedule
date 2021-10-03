//
//  RealmManager.swift
//  Schedule
//
//  Created by Никита Ничепорук on 8/28/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    
    private init() {}
    
    let localRealm = try! Realm()
    
     func saveScheduleModel(model: ModelRealm) {
        try! localRealm.write {
            localRealm.add(model)
        }
    }

    func deleteScheduleModel(model: ModelRealm) {
        try! localRealm.write {
            localRealm.delete(model)
        }
    }
}
