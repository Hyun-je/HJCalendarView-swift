//
//  ViewController.swift
//  HJCalendarView-example
//
//  Created by JaehyeonPark on 2018. 6. 28..
//  Copyright © 2018년 JaehyeonPark. All rights reserved.
//

import UIKit

class ViewController: UIViewController, HJCalendarViewDelegate {

    

    @IBOutlet weak var calendarView: HJCalendarView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calendarView.calendarDelegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func didChangeCalendar(_ calendarView: HJCalendarView, calendar: Calendar) {
        print(#function)
    }
    
    func didSelectDay(_ calendarView: HJCalendarView, date: Date) {
        print(#function)
    }
    
    func didSelectBlank(_ calendarView: HJCalendarView) {
        print(#function)
    }


}

