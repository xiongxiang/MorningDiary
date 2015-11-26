//
//  DiaryTransactionAnimator.swift
//  Diary
//
//  Created by zhowkevin on 15/10/5.
//  Copyright © 2015年 kevinzhow. All rights reserved.
//

import UIKit

class DiaryTransactionAnimator: NSObject, UINavigationControllerDelegate {
    
    let animator = DiaryAnimator()
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        animator.operation = operation
        return animator
    }
}
