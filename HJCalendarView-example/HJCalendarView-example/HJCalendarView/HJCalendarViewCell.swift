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
    static let identifier = "HJCalendarViewCell"
    
    var dateComponents: DateComponents? = nil
    
    var mainLabel = UILabel()
    var subLabel = UILabel()
    
    static var selectedBackgroundColor = UIColor(white: 0.05, alpha: 0.1)
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        
        // Set selectedBackgroundView
        //
        selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView?.backgroundColor = HJCalendarViewCell.selectedBackgroundColor
        if frame.width > frame.height {
            selectedBackgroundView?.layer.cornerRadius = frame.height / 5.0
        }
        else {
            selectedBackgroundView?.layer.cornerRadius = frame.width / 5.0
        }
        
        
        
        // Create labels
        //
        mainLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height/2))
        mainLabel.center = CGPoint(x:frame.width/2 , y: frame.height*2/5)
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont.systemFont(ofSize: frame.height*0.45)
        addSubview(mainLabel)
        
        subLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height*3/4))
        subLabel.center = CGPoint(x:frame.width/2 , y: frame.height*0.77)
        subLabel.textAlignment = .center
        subLabel.font = UIFont.systemFont(ofSize: frame.height*0.23)
        addSubview(subLabel)
        
    }
    
    
    
    public func setCellType(_ type: HJCalendarViewCellType) {
        
        mainLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height/2)
        
        subLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height*3/4)
        subLabel.center = CGPoint(x:frame.width/2 , y: frame.height*0.77)
        subLabel.font = UIFont.systemFont(ofSize: frame.height*0.23)
        
        switch type {
            
        case .DayHeaderCell:
            mainLabel.center = CGPoint(x:frame.width/2 , y: frame.height/2)
            mainLabel.font = UIFont.systemFont(ofSize: frame.height/4)
            mainLabel.isHidden = false
            subLabel.isHidden = true
            selectedBackgroundView?.backgroundColor = UIColor.clear
            dateComponents = nil
            
        case .DateCell:
            mainLabel.center = CGPoint(x:frame.width/2 , y: frame.height*2/5)
            mainLabel.font = UIFont.systemFont(ofSize: frame.height*0.45)
            mainLabel.isHidden = false
            subLabel.isHidden = false
            selectedBackgroundView?.backgroundColor = HJCalendarViewCell.selectedBackgroundColor
            
        case .BlankCell:
            mainLabel.isHidden = true
            subLabel.isHidden = true
            selectedBackgroundView?.backgroundColor = UIColor.clear
            dateComponents = nil
            
        }
        
    }

    
}
