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
    
    var mainLabel = UILabel()
    var subLabel = UILabel()
    
    var date:Date? = nil
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        
        // Set selectedBackgroundView
        //
        selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView?.backgroundColor = UIColor(white: 0.05, alpha: 0.2)
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
        mainLabel.font = UIFont.systemFont(ofSize: frame.height/2)
        addSubview(mainLabel)
        
        subLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height*3/4))
        subLabel.center = CGPoint(x:frame.width/2 , y: frame.height*3/4)
        subLabel.textAlignment = .center
        //subLabel.text = "34"
        subLabel.font = UIFont.systemFont(ofSize: frame.height/5)
        addSubview(subLabel)
        
    }
    
    
    
    func setCellType(_ type:HJCalendarViewCellType) {
        
        switch type {
            
        case .DayHeaderCell:
            mainLabel.center = CGPoint(x:frame.width/2 , y: frame.height/2)
            mainLabel.font = UIFont.systemFont(ofSize: frame.height/4)
            mainLabel.isHidden = false
            subLabel.isHidden = true
            selectedBackgroundView?.backgroundColor = UIColor.clear
            date = nil
            
        case .DateCell:
            mainLabel.center = CGPoint(x:frame.width/2 , y: frame.height*2/5)
            mainLabel.font = UIFont.systemFont(ofSize: frame.height/2)
            mainLabel.isHidden = false
            subLabel.isHidden = false
            selectedBackgroundView?.backgroundColor = UIColor(white: 0.05, alpha: 0.2)
            
        case .BlankCell:
            mainLabel.isHidden = true
            subLabel.isHidden = true
            selectedBackgroundView?.backgroundColor = UIColor.clear
            date = nil
            
        }
        
    }

    
}
