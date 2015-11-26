//
//  DiaryAnimator.swift
//  Diary
//
//  Created by kevinzhow on 15/2/18.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import UIKit

class DiaryAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var operation:UINavigationControllerOperation!
    
    var newSize: CGSize?
    
    // 转场时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    // 转场的参数变化
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 获取转场舞台
        let containerView = transitionContext.containerView()
        
        // 获取从那个场景开始转
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromVC!.view
        
        // 获取要转去那个场景
        let toVC   = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toVC!.view
        
        // 设置新场景透明度
        toView.alpha = 0.0
        
        // UINavigationControllerOperation.Pop 用来判断是转入还是转出
        if operation ==  UINavigationControllerOperation.Pop {
            // 如果是返回旧场景，那么设置要转入的场景初始缩放为原始大小
            toView.transform = CGAffineTransformMakeScale(1.0,1.0)
            if let newSize = newSize {
                toView.frame = CGRect(x: toView.frame.origin.x, y: toView.frame.origin.y, width: newSize.width, height: newSize.height)
            }
        }else{
            // 如果是转到新场景，设置新场景初始缩放为0.3
            toView.transform = CGAffineTransformMakeScale(0.3,0.3);
        }

        // 在舞台上插入场景
        containerView?.insertSubview(toView, aboveSubview: fromView)

        // 插入一个UIView.animateWithDuration来实现最终动画
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
                if (self.operation ==  UINavigationControllerOperation.Pop) {
                    //  放大要转出的场景
                    fromView.transform = CGAffineTransformMakeScale(3.3,3.3)

                }else{
                    // 设置新场景为原始的大小
                    toView.transform = CGAffineTransformMakeScale(1.0,1.0);
                }

                toView.alpha = 1.0

            }, completion: { finished in
                 // 通知NavigationController已经转场完成
                 transitionContext.completeTransition(true)
        })
        
    }
    
}
