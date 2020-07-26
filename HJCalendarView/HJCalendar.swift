//
//  HJCalendar.swift
//  HJCalendarView-example
//
//  Created by JaehyeonPark on 2018. 7. 1..
//  Copyright © 2018년 JaehyeonPark. All rights reserved.
//

import Foundation


struct HJCalendar {
    
    static let calendar = Calendar(identifier: .gregorian)
    
    private var date = Date()
    
    
    init(date: Date = Date()) {
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
    
    
    
    var year: Int? {
        let comp: DateComponents = HJCalendar.calendar.dateComponents([.year], from: date as Date)
        return comp.year
    }
    
    var month: Int? {
        let comp: DateComponents = HJCalendar.calendar.dateComponents([.month], from: date as Date)
        return comp.month
    }
    
    var numberOfDay: Int {
        let range = HJCalendar.calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    var weekOfFirstDay: Int {
        return HJCalendar.calendar.dateComponents([.weekday], from: date).weekday! - 1
    }
    

    
    
    func nextMonthCalendar() -> HJCalendar {
        var periodComponents = DateComponents()
        periodComponents.month = 1
        
        return HJCalendar(date: HJCalendar.calendar.date(byAdding: periodComponents, to: date)!)
    }

    func previousMonthCalendar() -> HJCalendar {
        var periodComponents = DateComponents()
        periodComponents.month = -1
        
        return HJCalendar(date: HJCalendar.calendar.date(byAdding: periodComponents, to: date)!)
    }
    
}
