//
//  Calendar+Extension.swift
//  Schedule
//
//  Created by Никита Ничепорук on 8/25/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import Foundation
import FSCalendar

extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHideConstrain.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    scheduleOnDate(date: date)
    }
}
