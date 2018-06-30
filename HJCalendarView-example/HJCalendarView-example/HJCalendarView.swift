//
//  HJCalendarView.swift
//  HJCalendarView-example
//
//  Created by JaehyeonPark on 2018. 6. 28..
//  Copyright © 2018년 JaehyeonPark. All rights reserved.
//

import UIKit




class MonthCell {
    
    static let calendar = Calendar(identifier: .gregorian)
    var date = Date()
    
    var calendarCount = [Int](repeating: 0, count:31)
    
    
    init() {
        let comp: DateComponents = MonthCell.calendar.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: date))
        if let date = MonthCell.calendar.date(from: comp) {
            self.date = date
        }
    }
    
    init(year: Int, month: Int) {
        let comp = DateComponents(year: year, month: month)
        if let date = MonthCell.calendar.date(from: comp) {
            self.date = date
        }
    }
    
    func getYear() -> Int? {
        let comp: DateComponents = MonthCell.calendar.dateComponents([.year], from: date as Date)
        return comp.year
    }
    
    func getMonth() -> Int? {
        let comp: DateComponents = MonthCell.calendar.dateComponents([.month], from: date as Date)
        return comp.month
    }
    
    func getNumberOfDay() -> Int {
        let range = MonthCell.calendar.range(of: .day, in: .month, for: date)!
        return range.count
        
    }
    
    func getWeekOfFirstDay() -> Int {
        return MonthCell.calendar.dateComponents([.weekday], from: date).weekday! - 1
    }

    func setNextMonth() {
        var periodComponents = DateComponents()
        periodComponents.month = 1
        date = MonthCell.calendar.date(byAdding: periodComponents, to: date)!
    }
    
    func setPreviousMonth() {
        var periodComponents = DateComponents()
        periodComponents.month = -1
        date = MonthCell.calendar.date(byAdding: periodComponents, to: date)!
    }
    
    
    
}






protocol HJCalendarViewDelegate: NSObjectProtocol {
    
    func didChangeCalendar(_ calendarView: HJCalendarView, year: Int, month: Int)
    
    func didSelectDay(_ calendarView: HJCalendarView, indexPath: IndexPath, date:Date?)
    
    func didDeselectDay(_ calendarView: HJCalendarView, indexPath: IndexPath, date:Date?)
    
}



class HJCalendarView: UICollectionView {
    
    weak var calendarDelegate: HJCalendarViewDelegate?
    
    private let stringWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    private var monthCellArray = [MonthCell]()

    
    @IBInspectable var dayHeaderColor = UIColor.gray
    @IBInspectable var dateColor = UIColor.black
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        

        // set view
        isPagingEnabled = true
        allowsMultipleSelection = false
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        clipsToBounds = true
        
   
        // set layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        self.collectionViewLayout = layout


        // register cell
        self.register(HJCalendarViewCell.self, forCellWithReuseIdentifier: "HJCalendarViewCell")
        
        
        // init monthcell
        for _ in 0..<3 {
            monthCellArray.append(MonthCell())
        }
        
        monthCellArray[0].setPreviousMonth()
        monthCellArray[2].setNextMonth()
        
        delegate = self
        dataSource = self
        
    }
    
    
    
    
    func setCurrentCalendar(year: Int, month: Int) {

        for i in 0..<3 {
            monthCellArray[i] = MonthCell(year: year, month: month)
        }
        
        monthCellArray[0].setPreviousMonth()
        monthCellArray[2].setNextMonth()
        
    }
    
    func getCurrentCalendar() -> (year: Int?, month: Int?) {

        return (monthCellArray[1].getYear(), monthCellArray[1].getMonth())
        
    }
    
    func setHighlighted(date: Date, isHighlighted: Bool, color: UIColor) {
        
        
        
        
        //cell.setHighlighted(true)
        
    }
    
    func setCount(date: Date, count: Int) {
    
        
    
    }

}







extension HJCalendarView: UICollectionViewDelegateFlowLayout {

    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if newWindow == nil {
            // UIView disappear
            
            
        } else {
            // UIView appear
            
            let indexPath = IndexPath(row: 0, section: 1)
            self.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
            
            calendarDelegate?.didChangeCalendar(self, year: monthCellArray[1].getYear()!, month: monthCellArray[1].getMonth()!)

            
        }
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let visibleCell = visibleCells[(visibleCells.count-1)/2]
        
        let scrollDirection = 1 - (visibleCell as! HJCalendarViewCell).indexPath.section
        if scrollDirection != 0 {
            for i in 0..<3 {
                
                switch scrollDirection {
                case 1:
                    monthCellArray[i].setPreviousMonth()
                case -1:
                    monthCellArray[i].setNextMonth()
                default:
                    break
                }
                
            }
            
            calendarDelegate?.didChangeCalendar(self, year: monthCellArray[1].getYear()!, month: monthCellArray[1].getMonth()!)
            
            if let selectedIndexArray = self.indexPathsForSelectedItems {
                
                for selectedIndex in selectedIndexArray {
                    
                    let cell = cellForItem(at: selectedIndex) as? HJCalendarViewCell
                    cell?.setHighlighted(false)
                    
                }
                
                
            }
            
        }
        
        let indexPath = IndexPath(row: 0, section: 1)
        scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
        
        self.reloadData()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = self.cellForItem(at: indexPath) as! HJCalendarViewCell
        
        let cellIndex = collectionViewIndexTransform(index:indexPath.row)
        let dateIndex = cellIndex - monthCellArray[indexPath.section].getWeekOfFirstDay()
        
        if dateIndex >= 0 && dateIndex < monthCellArray[indexPath.section].getNumberOfDay() {
            
            let comp = DateComponents(year: monthCellArray[1].getYear(), month: monthCellArray[1].getMonth(), day: dateIndex + 1)
            calendarDelegate?.didSelectDay(self, indexPath: indexPath, date: MonthCell.calendar.date(from: comp))
            cell.setHighlighted(true)
            
        }
        else {
            calendarDelegate?.didSelectDay(self, indexPath: indexPath, date: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = self.cellForItem(at: indexPath) as! HJCalendarViewCell
        
        let cellIndex = collectionViewIndexTransform(index:indexPath.row)
        let dateIndex = cellIndex - monthCellArray[indexPath.section].getWeekOfFirstDay()
        
        if dateIndex >= 0 && dateIndex < monthCellArray[indexPath.section].getNumberOfDay() {
            
            let comp = DateComponents(year: monthCellArray[1].getYear(), month: monthCellArray[1].getMonth(), day: dateIndex + 1)
            calendarDelegate?.didDeselectDay(self, indexPath: indexPath, date: MonthCell.calendar.date(from: comp))
            cell.setHighlighted(false)
            
        }
        else {
            calendarDelegate?.didDeselectDay(self, indexPath: indexPath, date: nil)
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
        return CGSize(width: self.frame.width/7, height: self.frame.height/7)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HJCalendarViewCell", for: indexPath) as! HJCalendarViewCell
        
        cell.indexPath = indexPath
        
        let cellIndex = collectionViewIndexTransform(index:indexPath.row)
        let dateIndex = cellIndex - monthCellArray[indexPath.section].getWeekOfFirstDay()
        
        
        if cellIndex < 0 {
            // 상단 주 표시 텍스트
            cell.mainLabel.text = stringWeek[cellIndex+7]
            cell.mainLabel.textColor = dayHeaderColor
            cell.setCellType(.DayHeaderCell)
        }
        else if dateIndex >= 0 && dateIndex < monthCellArray[indexPath.section].getNumberOfDay() {
            // 날짜 표시 텍스트
            cell.mainLabel.textColor = dateColor
            cell.setCellType(.DateCell)
            cell.mainLabel.text = "\(dateIndex + 1)"
            
            let comp = DateComponents(year: monthCellArray[1].getYear(), month: monthCellArray[1].getMonth(), day: dateIndex + 1)
            cell.date = MonthCell.calendar.date(from: comp)
        }
        else {
            // 빈킨 표시 텍스트
            cell.setCellType(.BlankCell)
        }

        return cell
        
    }
    
}
