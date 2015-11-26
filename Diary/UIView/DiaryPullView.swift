//
//  DiaryPullView.swift
//  Diary
//
//  Created by kevinzhow on 15/4/25.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import UIKit

class DiaryPullView: UIView {

    var closeLabel:UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        self.alpha = 0.0
        self.layer.cornerRadius = self.frame.size.height/2.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.blackColor()
        
        closeLabel = DiaryLabel(fontname: defaultFont, labelText: "完", fontSize: 16.0,lineHeight: 5.0)
        closeLabel.textColor = UIColor.whiteColor()
        closeLabel.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0)
        if defaultFont == secondFont {
            closeLabel.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0 - 1.0)
        }
        closeLabel.alpha = 1
        self.addSubview(closeLabel)
    }
}
