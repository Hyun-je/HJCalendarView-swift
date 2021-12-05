//
//  HJCalendarData.swift
//  HJCalendarView-example
//
//  Created by JaehyeonPark on 2018. 7. 1..
//  Copyright © 2018년 JaehyeonPark. All rights reserved.
//

import Foundation


struct HJCalendarData {
    
    static let calendar = Calendar(identifier: .gregorian)
    
    private var date = Date()
    
    
    init(date: Date = Date()) {
        let comp: DateComponents = HJCalendarData.calendar.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: date))
        if let date = HJCalendarData.calendar.date(from: comp) {
            self.date = date
        }
    }
    
    init(year: Int, month: Int) {
        let comp = DateComponents(year: year, month: month)
        if let date = HJCalendarData.calendar.date(from: comp) {
            self.date = date
        }
    }
    
    
    
    var year: Int? {
        let comp: DateComponents = HJCalendarData.calendar.dateComponents([.year], from: date as Date)
        return comp.year
    }
    
    var month: Int? {
        let comp: DateComponents = HJCalendarData.calendar.dateComponents([.month], from: date as Date)
        return comp.month
    }
    
    var numberOfDay: Int {
        let range = HJCalendarData.calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    var weekOfFirstDay: Int {
        return HJCalendarData.calendar.dateComponents([.weekday], from: date).weekday! - 1
    }
    

    
    
    func nextMonth() -> HJCalendarData {
        var periodComponents = DateComponents()
        periodComponents.month = 1
        
        return HJCalendarData(date: HJCalendarData.calendar.date(byAdding: periodComponents, to: date)!)
    }

    func previousMonth() -> HJCalendarData {
        var periodComponents = DateComponents()
        periodComponents.month = -1
        
        return HJCalendarData(date: HJCalendarData.calendar.date(byAdding: periodComponents, to: date)!)
    }
    
}
