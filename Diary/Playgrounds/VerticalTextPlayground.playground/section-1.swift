// Playground - noun: a place where people can play

import UIKit

func sizeHeightWithText(labelText: NSString, fontSize: CGFloat, textAttributes: [String : AnyObject]) -> CGRect {
    
    return labelText.boundingRectWithSize(CGSizeMake(fontSize, 480), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textAttributes, context: nil)
}

extension UILabel {
    
    convenience init(fontname:String ,labelText:String, fontSize : CGFloat){
        let font = UIFont(name: fontname, size: fontSize) as UIFont!
        
        let textAttributes: [String : AnyObject] = [NSFontAttributeName: font]
        let labelSize = sizeHeightWithText(labelText, fontSize: fontSize ,textAttributes: textAttributes)
        
        self.init(frame: labelSize)
        
        self.attributedText = NSAttributedString(string: labelText, attributes: textAttributes)

        self.lineBreakMode = NSLineBreakMode.ByCharWrapping
        self.numberOfLines = 0
    }
    
}

var newLabel = UILabel()
newLabel.text = "HeyLabel"
newLabel.sizeToFit()
newLabel

var label = UILabel(fontname: "Avenir", labelText:"一闪一闪亮晶晶", fontSize: 16.0)

label.backgroundColor = UIColor.grayColor()
label.textColor = UIColor.whiteColor()

label

let poem = [["lei":"sd"]]
poem
