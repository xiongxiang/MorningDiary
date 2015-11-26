//
//  DiaryLayout.swift
//  Diary
//
//  Created by kevinzhow on 15/2/16.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import UIKit

class DiaryLayout: UICollectionViewFlowLayout {
    
    var collectionViewLeftInsetsForLayout = collectionViewLeftInsets
    
    override func prepareLayout() {
        super.prepareLayout()
        let itemSize = CGSizeMake(itemWidth, itemHeight)
        self.itemSize = itemSize
        self.minimumInteritemSpacing = 0.0
        self.minimumLineSpacing = itemSpacing
        self.scrollDirection = .Horizontal
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes = super.layoutAttributesForElementsInRect(rect)
        let contentOffset = collectionView!.contentOffset
        
        for (_, attributes) in layoutAttributes!.enumerate() {
            
            let center = attributes.center
            
            let cellPositinOnScreen = (center.x - itemWidth/2.0) - contentOffset.x 
            
            if cellPositinOnScreen >= (collectionViewLeftInsetsForLayout - itemWidth/2.0) && cellPositinOnScreen < (collectionViewLeftInsetsForLayout + collectionViewWidth ) {
                
                let centerPoint = (collectionViewWidth)/2.0
                
                let positonInVisibleArea = cellPositinOnScreen - collectionViewLeftInsetsForLayout
                
                let distanceToCenterPoint = positonInVisibleArea - centerPoint
                
                let visiableArea = centerPoint - itemWidth/3.0
                
                if fabs(distanceToCenterPoint) > visiableArea {
                    
                    let finalDistance = fabs(distanceToCenterPoint) - visiableArea
                    
                    var alpha:CGFloat = 0
                    
                    if distanceToCenterPoint < 0 {
                        let progress = CGFloat(finalDistance/((centerPoint - visiableArea)*2))
                        if progress <= 0.5 {
                            alpha = 1.0
                        } else {
                            alpha = (1.0 - progress)/0.5
                        }

                    }else {
                        alpha = 1.0 - CGFloat(finalDistance/(centerPoint - visiableArea))
                    }
                    
                    attributes.alpha = alpha
                    
                    
                }else {
                    attributes.alpha = 1
                }

                
            } else {
                attributes.alpha = 0
            }
            
            
        }
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
