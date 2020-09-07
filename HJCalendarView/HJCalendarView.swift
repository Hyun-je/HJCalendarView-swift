//
//  HJCalendarView.swift
//  HJCalendarView-example
//
//  Created by JaehyeonPark on 2018. 6. 28..
//  Copyright © 2018년 JaehyeonPark. All rights reserved.
//

import UIKit



@objc public protocol HJCalendarViewDelegate: NSObjectProtocol {
    
    @objc optional func didChangeCalendar(_ calendarView: HJCalendarView, dateComponents: DateComponents?)
    
    @objc optional func didSelectDay(_ calendarView: HJCalendarView, indexPath: IndexPath, dateComponents:DateComponents?)

}

@objc public protocol HJCalendarViewDataSource: NSObjectProtocol {
    
    @objc optional func calendarView(_ calendarView: HJCalendarView, indexPath: IndexPath, dateComponents:DateComponents?) -> String

}




@IBDesignable
public class HJCalendarView: UIView {
    
    @IBInspectable var headerColor     = UIColor.gray
    @IBInspectable var dayColor        = UIColor.black
    @IBInspectable var saturdayColor   = UIColor.blue
    @IBInspectable var sundayColor     = UIColor.red
    @IBInspectable var subTextColor    = UIColor.orange
    @IBInspectable var selectionColor  = UIColor(white: 0.05, alpha: 0.1)
    
    public weak var calendarDelegate: HJCalendarViewDelegate?
    public weak var calendarDataSource: HJCalendarViewDataSource?
    
    
    private var calendarArray = [HJCalendar]()
    
    let rows = 6
    let columns = 7
    
    var scrollDirection = UICollectionView.ScrollDirection.horizontal {
        
        didSet {
            DispatchQueue.main.async {
                self.layoutSubviews()
                self.collectionView.reloadData()
            }
        }
        
    }
    
    
    lazy private var headerView: UIStackView = {
        
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        
        for week in ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"] {
            
            let label = UILabel()
            label.text = week
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 12, weight: .regular)
            label.textColor = headerColor
            view.addArrangedSubview(label)
        }
        
        return view
        
    }()
    
    lazy private var collectionView: UICollectionView = {

        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.allowsSelection = true
        view.allowsMultipleSelection = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = true
        
        view.delegate = self
        view.dataSource = self
        
        
        // Register HJCalendarViewCell
        view.register(HJCalendarViewCell.self, forCellWithReuseIdentifier: HJCalendarViewCell.identifier)
        HJCalendarViewCell.selectedBackgroundColor = selectionColor
        
        return view
    }()
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layout()
    }
    
    
    private func layout() {
        
        addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
        ])
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        setCalendarToday()

    }
    

    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.itemSize = CGSize(
            width: collectionView.frame.width/7.0001,
            height: collectionView.frame.height/6.0001
        )
        
        collectionView.collectionViewLayout = layout

        scrollToCenterPage()
        
    }

}



extension HJCalendarView {
    
    private func scrollToCenterPage() {

        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 1), at: .left, animated: false)
    }
    
    public func getCalendar() -> (year: Int?, month: Int?) {
        
        return (calendarArray[1].year, calendarArray[1].month)
    }
    
    public func setCalendar(year: Int, month: Int) {
        
        calendarArray = [
            HJCalendar(year: year, month: month).previousMonth(),
            HJCalendar(year: year, month: month),
            HJCalendar(year: year, month: month).nextMonth()
        ]

        let dateComponents = DateComponents(year: calendarArray[1].year, month: calendarArray[1].month)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.scrollToCenterPage()
        }
        
        calendarDelegate?.didChangeCalendar?(self, dateComponents: dateComponents)
        
    }
    
    public func setCalendarToday() {
        
        let calendar = HJCalendar()
        
        if  let year = calendar.year,
            let month = calendar.month {
            
            setCalendar(year: year, month: month)
        }
        
    }
    
}




extension HJCalendarView: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        isUserInteractionEnabled = false
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        isUserInteractionEnabled = true
        
        let visibleItems = collectionView.indexPathsForVisibleItems
        let visibleIndexPath = visibleItems[(visibleItems.count - 1)/2]
        
        let scrollDirection = 1 - visibleIndexPath.section
        if scrollDirection != 0 {
            
            switch scrollDirection {
            case 1:
                calendarArray = calendarArray.map{ $0.previousMonth() }
            case -1:
                calendarArray = calendarArray.map{ $0.nextMonth() }
            default:
                break
            }
            
            collectionView.reloadData()
            scrollToCenterPage()
            
            let dateComponents = DateComponents(year: calendarArray[1].year, month: calendarArray[1].month)
            calendarDelegate?.didChangeCalendar?(self, dateComponents: dateComponents)
            
        }
        
    }
    
}



extension HJCalendarView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(
            width: collectionView.frame.width / CGFloat(columns),
            height: collectionView.frame.height / CGFloat(rows)
        )
    }
    
}


extension HJCalendarView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    private func collectionViewIndexTransform(index:Int) -> Int {
        
        if scrollDirection == .horizontal {
            let row = index/rows
            let col = index%rows
            
            return (col * columns) + row
        }
        else {
            return index
        }
        
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3 // prev, this, next month pages
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows * columns // row * columns grid
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HJCalendarViewCell.identifier, for: indexPath) as! HJCalendarViewCell

        let calendar = calendarArray[indexPath.section]
        let cellIndex = collectionViewIndexTransform(index: indexPath.row)
        let day = (cellIndex + 1) - calendar.weekOfFirstDay

        if day > 0 && day <= calendar.numberOfDay {
            
            // 날짜 표시 텍스트
            cell.setCellType(.DateCell)
            cell.mainLabel.text = "\(day)"

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
            
            
            let dataComponents = DateComponents(year: calendar.year, month: calendar.month, day: day)
            
            cell.subLabel.text = calendarDataSource?.calendarView?(self, indexPath: indexPath, dateComponents: dataComponents)
            cell.subLabel.textColor = subTextColor
            
        }
        else {
            cell.setCellType(.BlankCell)
        }

        return cell
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let calendar = calendarArray[indexPath.section]
        let cellIndex = collectionViewIndexTransform(index: indexPath.row)
        let day = (cellIndex + 1) - calendar.weekOfFirstDay
        
        if day > 0 && day <= calendar.numberOfDay {
            
            let dateComponents = DateComponents(year: calendar.year, month: calendar.month, day: day)

            calendarDelegate?.didSelectDay?(self, indexPath: indexPath, dateComponents: dateComponents)
            
        }
        else {
            calendarDelegate?.didSelectDay?(self, indexPath: indexPath, dateComponents: nil)
        }
        
    }
    
}
