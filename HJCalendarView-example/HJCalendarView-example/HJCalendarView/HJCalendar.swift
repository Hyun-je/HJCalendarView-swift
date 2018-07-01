//
//  HJCalendar.swift
//  HJCalendarView-example
//
//  Created by JaehyeonPark on 2018. 7. 1..
//  Copyright © 2018년 JaehyeonPark. All rights reserved.
//

import Foundation


class HJCalendar {
    
    static let calendar = Calendar(identifier: .gregorian)
    
    var date = Date()
    var calendarCount = [Int](repeating: 0, count:31)
    
    
    init() {
        let comp: DateComponents = HJCalendar.calendar.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: date))
        if let date = HJCalendar.calendar.date(from: comp) {
            self.date = date
        }
    }
    
    init(year: Int, month: Int) {
        let comp = DateComponents(year: year, month: month)
        if let date = HJCalendar.calendar.date(from: comp) {
            self.date = date
        }
    }
    
    func getYear() -> Int? {
        let comp: DateComponents = HJCalendar.calendar.dateComponents([.year], from: date as Date)
        return comp.year
    }
    
    func getMonth() -> Int? {
        let comp: DateComponents = HJCalendar.calendar.dateComponents([.month], from: date as Date)
        return comp.month
    }
    
    func getNumberOfDay() -> Int {
        let range = HJCalendar.calendar.range(of: .day, in: .month, for: date)!
        return range.count
        
    }
    
    func getWeekOfFirstDay() -> Int {
        return HJCalendar.calendar.dateComponents([.weekday], from: date).weekday! - 1
    }
    
    func setNextMonth() {
        var periodComponents = DateComponents()
        periodComponents.month = 1
        date = HJCalendar.calendar.date(byAdding: periodComponents, to: date)!
    }
    
    func setPreviousMonth() {
        var periodComponents = DateComponents()
        periodComponents.month = -1
        date = HJCalendar.calendar.date(byAdding: periodComponents, to: date)!
    }
    
    
    
}
