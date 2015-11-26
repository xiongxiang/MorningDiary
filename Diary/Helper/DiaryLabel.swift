//
//  DiaryLabel.swift
//  Diary
//
//  Created by kevinzhow on 15/3/4.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import UIKit
import pop

func sizeHeightWithText(labelText: NSString,
    fontSize: CGFloat,
    textAttributes: [String : AnyObject]) -> CGRect {
        
        return labelText.boundingRectWithSize(
            CGSizeMake(fontSize, 480),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: textAttributes, context: nil)
}

class NumberPaser {
    
    func convertNumber(number:Int) -> String? {
        
        if (number == 0){
            return "零"
        }else{
            return nil
        }
    }
    
}

class DiaryLabel: UILabel {
    
    var textAttributes: [String : AnyObject]!
    
    var labelSize: CGRect?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(fontname:String,
        labelText:String,
        fontSize : CGFloat,
        lineHeight: CGFloat){
            
            self.init(frame: CGRectZero)
            
            self.userInteractionEnabled = true
            
            let font = UIFont(name: fontname,
                size: fontSize) as UIFont!
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineHeight
            
            textAttributes = [NSFontAttributeName: font,
                NSParagraphStyleAttributeName: paragraphStyle]
            
            labelSize = sizeHeightWithText(labelText, fontSize: fontSize ,textAttributes: textAttributes)
            
            self.attributedText = NSAttributedString(
                string: labelText,
                attributes: textAttributes)
            
            self.lineBreakMode = NSLineBreakMode.ByCharWrapping
            
            self.numberOfLines = 0
    }
    
    func config(fontname:String,
        labelText:String,
        fontSize : CGFloat,
        lineHeight: CGFloat){
            
            self.userInteractionEnabled = true
            
            let font = UIFont(name: fontname,
                size: fontSize) as UIFont!
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineHeight
            
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
            paragraphStyle.paragraphSpacing = 0
            
            paragraphStyle.paragraphSpacingBefore = 0
        
            textAttributes = [NSFontAttributeName: font,
                NSParagraphStyleAttributeName: paragraphStyle]
            
            labelSize = sizeHeightWithText(labelText, fontSize: fontSize ,textAttributes: textAttributes)
            
            self.attributedText = NSAttributedString(
                string: labelText,
                attributes: textAttributes)
            
            self.numberOfLines = 0
    }
    
    func updateText(labelText: String) {

        self.attributedText = NSAttributedString(
            string: labelText,
            attributes: textAttributes)
    }
    
    func updateLabelColor(color: UIColor) {
        
        textAttributes[NSForegroundColorAttributeName] = color
        
        self.attributedText = NSAttributedString(
            string: self.attributedText!.string,
            attributes: textAttributes)
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        anim.springBounciness = 10
        anim.springSpeed = 15
        anim.fromValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        anim.toValue = NSValue(CGPoint: CGPointMake(0.9, 0.9))
        self.layer.pop_addAnimation(anim, forKey: "PopScale")
        super.touchesBegan(touches as Set<UITouch>, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        anim.springBounciness = 10
        anim.springSpeed = 15
        anim.fromValue = NSValue(CGPoint: CGPointMake(0.9, 0.9))
        anim.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        self.layer.pop_addAnimation(anim, forKey: "PopScaleback")
        super.touchesEnded(touches as Set<UITouch>, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        anim.springBounciness = 10
        anim.springSpeed = 15
        anim.fromValue = NSValue(CGPoint: CGPointMake(0.9, 0.9))
        anim.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        self.layer.pop_addAnimation(anim, forKey: "PopScaleback")
        super.touchesCancelled(touches, withEvent: event)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
