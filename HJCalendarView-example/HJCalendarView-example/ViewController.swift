//
//  ViewController.swift
//  HJCalendarView-example
//
//  Created by JaehyeonPark on 2018. 6. 28..
//  Copyright © 2018년 JaehyeonPark. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HJCalendarViewDelegate, HJCalendarViewDataSource {
    

    @IBOutlet weak var calendarView: HJCalendarView!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var calendarSelectionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        calendarView.setCurrentCalendar(year: 2018, month: 4)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func didChangeCalendar(_ calendarView: HJCalendarView, year: Int, month: Int) {
        print(#function)
        
        calendarLabel.text = "\(year) \(month)"
        calendarSelectionLabel.text = ""
        
    }
    
    func didSelectDay(_ calendarView: HJCalendarView, indexPath: IndexPath, dateComponents:DateComponents?) {
        print(#function)

        if let year = dateComponents?.year,
           let month = dateComponents?.month,
           let day = dateComponents?.day {
            calendarSelectionLabel.text = "\(year) \(month) \(day)"
        }
        
    }
    
    func calendarView(_ calendarView: HJCalendarView, indexPath: IndexPath, dateComponents:DateComponents?) -> String {
        
        if let year = dateComponents?.year,
            let month = dateComponents?.month,
            let day = dateComponents?.day {
            

            
            if (year == 2018 && month == 3 && day == 15) {
                
                return "▪︎▪︎"
                
            }
            
            if (year == 2018 && month == 4 && day == 5) {
                
                return "★★"
                
            }
            
            if (year == 2018 && month == 4 && day == 10) {
                
                return "★"
                
            }
            
            if (year == 2018 && month == 4 && day == 27) {
                
                return "★★★"
                
            }
            
        }
        
        
        return ""
        
    }



}

