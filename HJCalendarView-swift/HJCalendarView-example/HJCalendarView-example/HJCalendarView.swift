//
//  HJCalendarView.swift
//  HJCalendarView-example
//
//  Created by JaehyeonPark on 2018. 6. 28..
//  Copyright © 2018년 JaehyeonPark. All rights reserved.
//

import UIKit




class MonthCell {
    
    let calendar = Calendar(identifier: .gregorian)
    var date = Date()
    
    var calendarCount = [Int](repeating: 0, count:31)
    
    
    init() {
        let comp: DateComponents = calendar.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: date))
        date = calendar.date(from: comp)!
    }
    
    func getYear() -> Int {
        let comp: DateComponents = calendar.dateComponents([.year, .month, .day], from: date as Date)
        return comp.year!
    }
    
    func getMonth() -> Int {
        let comp: DateComponents = calendar.dateComponents([.year, .month, .day], from: date as Date)
        return comp.month!
    }
    
    func getNumberOfDay() -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
        
    }
    
    func getWeekOfFirstDay() -> Int {
        return calendar.dateComponents([.weekday], from: date).weekday! - 1
    }
    
    func printDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        print(dateFormatter.string(from:  date))
    }
    
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        return dateFormatter.string(from:  date)
    }
    
    func setNextMonth() {
        var periodComponents = DateComponents()
        periodComponents.month = 1
        date = calendar.date(byAdding: periodComponents, to: date)!
    }
    
    func setPreviousMonth() {
        var periodComponents = DateComponents()
        periodComponents.month = -1
        date = calendar.date(byAdding: periodComponents, to: date)!
    }
    
    
    
}






protocol HJCalendarViewDelegate: NSObjectProtocol {
    
    func didChangeCalendar(_ calendarView: HJCalendarView, calendar:Calendar)
    
    func didSelectDay(_ calendarView: HJCalendarView, date:Date)
    
    func didSelectBlank(_ calendarView: HJCalendarView)
    
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
            let monthCell = MonthCell()
            monthCellArray.append(monthCell)
        }
        
        monthCellArray[0].setPreviousMonth()
        monthCellArray[2].setNextMonth()


        delegate = self
        dataSource = self

        
    }
    
    
    
    
    func setCurrentCalendar(_ calendar: Calendar) {
        
        
        
        
    }
    
    func getCurrentCalendar() -> Calendar {

        return monthCellArray[1].calendar
        
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
            
            calendarDelegate?.didChangeCalendar(self, calendar: monthCellArray[1].calendar)
            
        }
        
        let indexPath = IndexPath(row: 0, section: 1)
        scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: false)
        
        self.reloadData()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellIndex = collectionViewIndexTransform(index:indexPath.row) - 7
        let dateIndex = cellIndex - monthCellArray[indexPath.section].getWeekOfFirstDay()
        
        if dateIndex >= 0 && dateIndex < monthCellArray[indexPath.section].getNumberOfDay() {
            
            let cell = collectionView.cellForItem(at: indexPath) as! HJCalendarViewCell

            calendarDelegate?.didSelectDay(self, date: monthCellArray[1].date) // !!!!!!!!

        }
        else {
            calendarDelegate?.didSelectBlank(self)
        }
        
    }
    
}






extension HJCalendarView: UICollectionViewDataSource {
    
    func collectionViewIndexTransform(index:Int) -> Int {
        
        let row = index/7
        let col = index%7
        
        return col*7 + row
        
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
        
        let cellIndex = collectionViewIndexTransform(index:indexPath.row) - 7
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
            
        }
        else {
            // 빈킨 표시 텍스트
            cell.setCellType(.BlankCell)
        }

        return cell
        
    }
    
}
