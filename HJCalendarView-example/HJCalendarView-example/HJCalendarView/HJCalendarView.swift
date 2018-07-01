//
//  HJCalendarView.swift
//  HJCalendarView-example
//
//  Created by JaehyeonPark on 2018. 6. 28..
//  Copyright © 2018년 JaehyeonPark. All rights reserved.
//

import UIKit




protocol HJCalendarViewDelegate: NSObjectProtocol {
    
    func didChangeCalendar(_ calendarView: HJCalendarView, dateComponents: DateComponents?)
    
    func didSelectDay(_ calendarView: HJCalendarView, indexPath: IndexPath, dateComponents:DateComponents?)

}

protocol HJCalendarViewDataSource: NSObjectProtocol {
    
    func calendarView(_ calendarView: HJCalendarView, indexPath: IndexPath, dateComponents:DateComponents?) -> String
    
    //func calendarView(_ calendarView: HJCalendarView, colorForItemAt indexPath: IndexPath, date:Date?) -> UIColor
    
}




class HJCalendarView: UICollectionView {
    
    weak var calendarDelegate: HJCalendarViewDelegate?
    weak var calendarDataSource: HJCalendarViewDataSource?
    
    
    private let stringWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    private var calendarArray = [HJCalendar]()

    
    @IBInspectable var headerColor:UIColor     = UIColor.gray
    @IBInspectable var dayColor:UIColor        = UIColor.black
    @IBInspectable var saturdayColor:UIColor   = UIColor.blue
    @IBInspectable var sundayColor:UIColor     = UIColor.red
    @IBInspectable var subTextColor:UIColor    = UIColor.orange
    @IBInspectable var selectionColor:UIColor  = UIColor(white: 0.05, alpha: 0.1)
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        

        // Set UICollectionView
        isPagingEnabled = true
        allowsSelection = true
        allowsMultipleSelection = false
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        clipsToBounds = true

        
   
        // Set UICollectionViewFlowLayout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        self.collectionViewLayout = layout


        // Register HJCalendarViewCell
        self.register(HJCalendarViewCell.self, forCellWithReuseIdentifier: "HJCalendarViewCell")
        
        
        // Init HJCalendar array
        for _ in 0..<3 {
            calendarArray.append(HJCalendar())
        }
        
        calendarArray[0].setPreviousMonth()
        calendarArray[2].setNextMonth()
        
        delegate = self
        dataSource = self
        
    }
    
    
    func setCalendarToday() {

        // Init HJCalendar array
        for i in 0..<3 {
            calendarArray[i] = HJCalendar()
        }
        
        calendarArray[0].setPreviousMonth()
        calendarArray[2].setNextMonth()
        
        DispatchQueue.main.async {
            
            self.reloadData()
            
            let dateComponents = HJCalendar.calendar.dateComponents([.year, .month], from: self.calendarArray[1].date)
            self.calendarDelegate?.didChangeCalendar(self, dateComponents: dateComponents)
            
            let indexPath = IndexPath(row: 0, section: 1)
            self.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
            
        }
        
        
    }
    
    func setCalendar(year: Int, month: Int) {

        for i in 0..<3 {
            calendarArray[i] = HJCalendar(year: year, month: month)
        }
        
        calendarArray[0].setPreviousMonth()
        calendarArray[2].setNextMonth()
        
        DispatchQueue.main.async {
            
            self.reloadData()
            
            let dateComponents = HJCalendar.calendar.dateComponents([.year, .month], from: self.calendarArray[1].date)
            self.calendarDelegate?.didChangeCalendar(self, dateComponents: dateComponents)
            
            let indexPath = IndexPath(row: 0, section: 1)
            self.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
            
        }
        
    }
    
    func getCalendar() -> (year: Int?, month: Int?) {

        return (calendarArray[1].getYear(), calendarArray[1].getMonth())
        
    }

}







extension HJCalendarView: UICollectionViewDelegateFlowLayout {

    override func didMoveToWindow() {
        super.didMoveToWindow()

        DispatchQueue.main.async {

            let dateComponents = HJCalendar.calendar.dateComponents([.year, .month], from: self.calendarArray[1].date)
            self.calendarDelegate?.didChangeCalendar(self, dateComponents: dateComponents)
            
            let indexPath = IndexPath(row: 0, section: 1)
            self.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
            
        }

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let visibleIndexPath = indexPathsForVisibleItems[(indexPathsForVisibleItems.count-1)/2]
        
        let scrollDirection = 1 - visibleIndexPath.section
        if scrollDirection != 0 {
            for i in 0..<3 {
                
                switch scrollDirection {
                case 1:
                    calendarArray[i].setPreviousMonth()
                case -1:
                    calendarArray[i].setNextMonth()
                default:
                    break
                }
                
            }
            
            let dateComponents = HJCalendar.calendar.dateComponents([.year, .month], from: calendarArray[1].date)
            calendarDelegate?.didChangeCalendar(self, dateComponents: dateComponents)
            
        }
        
        let indexPath = IndexPath(row: 0, section: 1)
        scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
        
        self.reloadData()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let calendarIndex = indexPath.section
        let cellIndex = collectionViewIndexTransform(index:indexPath.row)
        let dateIndex = cellIndex - calendarArray[calendarIndex].getWeekOfFirstDay()
        
        if cellIndex < 0 {
            //calendarDelegate?.didSelectDay(self, indexPath: indexPath, dateComponents: nil)
        }
        if dateIndex >= 0 && dateIndex < calendarArray[calendarIndex].getNumberOfDay() {
            
            let dateComponents = DateComponents(year: calendarArray[calendarIndex].getYear(), month: calendarArray[calendarIndex].getMonth(), day: dateIndex + 1)
            calendarDelegate?.didSelectDay(self, indexPath: indexPath, dateComponents: dateComponents)
            
        }
        else {
            calendarDelegate?.didSelectDay(self, indexPath: indexPath, dateComponents: nil)
        }
        
    }

    
}






extension HJCalendarView: UICollectionViewDataSource {
    
    func collectionViewIndexTransform(index:Int) -> Int {
        
        let row = index/7
        let col = index%7
        
        return col*7 + row - 7
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 7 x 7 array
        return CGSize(width: self.frame.width/7.01, height: self.frame.height/7.01)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HJCalendarViewCell", for: indexPath) as! HJCalendarViewCell

        let calendarIndex = indexPath.section
        let cellIndex = collectionViewIndexTransform(index:indexPath.row)
        let dateIndex = cellIndex - calendarArray[calendarIndex].getWeekOfFirstDay()

        if cellIndex < 0 {
            // 상단 주 표시 텍스트
            cell.mainLabel.text = stringWeek[cellIndex+7]
            cell.mainLabel.textColor = headerColor
            cell.setCellType(.DayHeaderCell)
        }
        else if dateIndex >= 0 && dateIndex < calendarArray[calendarIndex].getNumberOfDay() {
            
            // 날짜 표시 텍스트
            cell.setCellType(.DateCell)
            cell.mainLabel.text = "\(dateIndex + 1)"

            // 주말 표시
            if cellIndex % 7 == 0 {
                cell.mainLabel.textColor = sundayColor
            }
            else if cellIndex % 7 == 6 {
                cell.mainLabel.textColor = saturdayColor
            }
            else {
                cell.mainLabel.textColor = dayColor
            }
            
            
            let dataComponents = DateComponents(year: calendarArray[calendarIndex].getYear(), month: calendarArray[calendarIndex].getMonth(), day: dateIndex + 1)
            
            cell.dateComponents = dataComponents
            cell.subLabel.text = calendarDataSource?.calendarView(self, indexPath: indexPath, dateComponents:dataComponents)
            cell.subLabel.textColor = subTextColor
            
        }
        else {
            // 빈킨 표시 텍스트
            cell.setCellType(.BlankCell)
        }
        
        HJCalendarViewCell.selectedBackgroundColor = selectionColor

        return cell
        
    }
    
}
