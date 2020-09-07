//
//  HJCalendarViewCell.swift
//  HJCalendarView-example
//
//  Created by JaehyeonPark on 2018. 6. 29..
//  Copyright © 2018년 JaehyeonPark. All rights reserved.
//

import UIKit


enum HJCalendarViewCellType {
    
    case DateCell
    case BlankCell
    
}


class HJCalendarViewCell: UICollectionViewCell {
    
    static let identifier = "HJCalendarViewCell"
    static var selectedBackgroundColor = UIColor(white: 0.05, alpha: 0.1)

    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layout()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
    }
    
    
    private func layout() {
        
        // Set selectedBackgroundView
        //
        selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView?.backgroundColor = HJCalendarViewCell.selectedBackgroundColor

        addSubview(mainLabel)
        NSLayoutConstraint.activate([
            mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        addSubview(subLabel)
        NSLayoutConstraint.activate([
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor),
            subLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let length = min(frame.width, frame.height)
        
        selectedBackgroundView?.layer.cornerRadius = length / 5.0
        
        mainLabel.font = .systemFont(ofSize: length / 3, weight: .medium)
        subLabel.font = .systemFont(ofSize: length / 5, weight: .regular)
    }
    
    
    public func setCellType(_ type: HJCalendarViewCellType) {
        
        switch type {
            
        case .DateCell:
            mainLabel.isHidden = false
            subLabel.isHidden = false
            selectedBackgroundView?.backgroundColor = HJCalendarViewCell.selectedBackgroundColor
            
        case .BlankCell:
            mainLabel.isHidden = true
            subLabel.isHidden = true
            selectedBackgroundView?.backgroundColor = UIColor.clear
            
        }
        
    }

    
}
