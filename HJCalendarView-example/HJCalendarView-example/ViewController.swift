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
    @IBOutlet weak var calendarLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calendarView.calendarDelegate = self
        
        calendarView.setCurrentCalendar(year: 2018, month: 4)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func didChangeCalendar(_ calendarView: HJCalendarView, year: Int, month: Int) {
        print(#function)
        
        calendarLabel.text = "\(year) \(month)"
        
    }
    
    func didSelectDay(_ calendarView: HJCalendarView, indexPath: IndexPath, date: Date?) {
        print(#function)
        
        let cell = calendarView.cellForItem(at: indexPath) as! HJCalendarViewCell
        cell.setHighlighted(true)
        
    }
    
    func didDeselectDay(_ calendarView: HJCalendarView, indexPath: IndexPath, date: Date?) {
        
        let cell = calendarView.cellForItem(at: indexPath) as! HJCalendarViewCell
        cell.setHighlighted(false)
        
    }



}

