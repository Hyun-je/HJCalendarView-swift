//
//  HJCalendarViewCell.swift
//  HJCalendarView-example
//
//  Created by JaehyeonPark on 2018. 6. 29..
//  Copyright © 2018년 JaehyeonPark. All rights reserved.
//

import UIKit


enum HJCalendarViewCellType {
    
    case DayHeaderCell
    case DateCell
    case BlankCell
    
}


class HJCalendarViewCell: UICollectionViewCell {
    
    var indexPath = IndexPath(row: 0, section: 0)
    
    var mainLabel = UILabel()
    var countLabel = UILabel()
    
    var date:Date? = nil
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundView = UIView(frame: frame)
        
        if frame.width > frame.height {
            backgroundView?.layer.cornerRadius = frame.height / 4.0
        }
        else {
            backgroundView?.layer.cornerRadius = frame.width / 4.0
        }
        backgroundView?.backgroundColor = UIColor.lightGray
        backgroundView?.isHidden = true
        
        mainLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height/2))
        mainLabel.center = CGPoint(x:frame.width/2 , y: frame.height/3)
        mainLabel.textAlignment = .center
        mainLabel.text = ""
        mainLabel.font = UIFont.systemFont(ofSize: frame.height/2)
        addSubview(mainLabel)
        
        countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height*3/4))
        countLabel.center = CGPoint(x:frame.width/2 , y: frame.height*3/4)
        countLabel.textAlignment = .center
        countLabel.text = ""
        countLabel.font = UIFont.systemFont(ofSize: frame.height/5)
        addSubview(countLabel)
        
    }
    
    
    
    func setCellType(_ type:HJCalendarViewCellType) {
        
        switch type {
            
        case .DayHeaderCell:
            mainLabel.center = CGPoint(x:frame.width/2 , y: frame.height/2)
            mainLabel.font = UIFont.systemFont(ofSize: frame.height/4)
            mainLabel.isHidden = false
            countLabel.isHidden = true
            date = nil
            
        case .DateCell:
            mainLabel.center = CGPoint(x:frame.width/2 , y: frame.height/3)
            mainLabel.font = UIFont.systemFont(ofSize: frame.height/2)
            mainLabel.isHidden = false
            countLabel.isHidden = false
            
        case .BlankCell:
            mainLabel.isHidden = true
            countLabel.isHidden = true
            date = nil
            
        }
        
    }
    
    func setCountIcon(_ count:Int) {
        
        var countString = ""
        
        for i in 0..<count {
            countString += "•"
            if i >= 2 { break }
        }
        
        countLabel.text = countString
        
    }
    
    func setHighlighted(_ isHighlighted: Bool) {
        
        if isHighlighted {
            backgroundView?.isHidden = false
        }
        else {
            backgroundView?.isHidden = true
        }
        
    }
    
    
    
}
