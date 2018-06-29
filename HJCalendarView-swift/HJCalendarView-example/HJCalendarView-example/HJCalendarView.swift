//
//  HJCalendarView.swift
//  HJCalendarView-example
//
//  Created by JaehyeonPark on 2018. 6. 28..
//  Copyright © 2018년 JaehyeonPark. All rights reserved.
//

import UIKit


class HJCalendarViewCell: UICollectionViewCell {
    
    
}




class HJCalendarView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        self.collectionViewLayout = layout

        self.register(HJCalendarViewCell.self, forCellWithReuseIdentifier: "HJCalendarViewCell")
        
        delegate = self
        dataSource = self
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 10, height: 10)
        
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 49
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HJCalendarViewCell", for: indexPath)
        cell.backgroundColor = UIColor.black
        
        return cell
        
    }
    

}
