//
//  Calendar+Swipe.swift
//  Schedule
//
//  Created by Никита Ничепорук on 8/25/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import Foundation
import FSCalendar

extension ScheduleViewController {
    func openCloseSwipeCalendar() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(closeCalendar))
        swipeUp.direction = .up
        calendar.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(openCalendar))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
    }

    @objc private func openCalendar() {
        calendar.setScope(.month, animated: true)
        openHideCalendar.setTitle("Close calendar", for: .normal)
    }

    @objc private func closeCalendar() {
        calendar.setScope(.week, animated: true)
        openHideCalendar.setTitle("Open calendar", for: .normal)
    }
}
