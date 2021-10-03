//
//  Calendar+Constrain.swift
//  Schedule
//
//  Created by Никита Ничепорук on 8/25/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import Foundation
import FSCalendar

extension ScheduleViewController {
    func setConstraints() {
        
        calendarHideConstrain = NSLayoutConstraint(item: calendar, attribute: .height , relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        
        calendar.addConstraint(calendarHideConstrain)
        
        view.addSubview(calendar)
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0),
            calendar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            calendar.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: 0),
            ])
        
        view.addSubview(openHideCalendar)
        NSLayoutConstraint.activate([
            openHideCalendar.topAnchor.constraint(equalToSystemSpacingBelow: calendar.bottomAnchor, multiplier: 0),
            openHideCalendar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            openHideCalendar.heightAnchor.constraint(equalToConstant: 10),
            openHideCalendar.widthAnchor.constraint(equalToConstant: 150)
            ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: openHideCalendar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
            ])
    }
}
