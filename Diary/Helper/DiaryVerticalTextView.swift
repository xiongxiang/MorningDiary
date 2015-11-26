//
//  DiaryVerticalTextView.swift
//  Diary
//
//  Created by kevinzhow on 15/3/6.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import UIKit
import CoreText

class DiaryVerticalTextView: UIView {
    var titleSizeRate: CGFloat!
    var titleForTextSpace: CGFloat!
    
    var text: NSString = ""
    var titleText: NSString = ""
    
    var fontSize: CGFloat = 20.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var lineSpace: CGFloat = 10.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var letterSpace: CGFloat = 8.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var fontName: NSString = defaultFont {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        
        let attrString = NSMutableAttributedString()
        
        if (self.titleText.length > 0) {
            let fontSize = 27.0 as CGFloat
            let titleFont = CTFontCreateWithName(fontName, fontSize, nil)
            let titleAttrDict = getAttributedStringSourceWithString(self.titleText as String, font: titleFont)
            
            let titleAttrString = NSMutableAttributedString(string: (self.titleText as String), attributes: titleAttrDict)
            
            attrString.appendAttributedString(titleAttrString)
            titleForTextSpace = 0
        }
        
        
        if (self.text.length > 0) {
            let font = CTFontCreateWithName(self.fontName, self.fontSize, nil)
            let textAttrDict = getAttributedStringSourceWithString(self.text as String, font:font)
            let textAttrString  = NSMutableAttributedString(string: (self.text as String), attributes: textAttrDict)
            attrString.appendAttributedString(textAttrString)
        }
        
        
        let framesetter = CTFramesetterCreateWithAttributedString(attrString)
        
        let path = CGPathCreateMutable()
        let pathSize = rect.size
        
        print("draw text size \(rect.size)")
        
        let reversingDiff = 0.0 as CGFloat
        
        CGPathAddRect(path, nil, CGRectMake(-reversingDiff, reversingDiff, pathSize.width, pathSize.height))
        
        var fitRange = CFRangeMake(0, 0)
        
        CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(pathSize.width, pathSize.height), &fitRange)
        

        let frameDict: NSDictionary = [
            String(kCTFrameProgressionAttributeName): NSNumber(unsignedInt: CTFrameProgression.RightToLeft.rawValue)
        ]
        
        let frame = CTFramesetterCreateFrame(framesetter, fitRange, path, frameDict)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)
        
        CGContextSetTextMatrix(context, CGAffineTransformIdentity)
        CGContextTranslateCTM(context, 0, pathSize.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        
        CTFrameDraw(frame, context!)
        
//        let factRange = CTFrameGetVisibleStringRange(frame)
        
        CGContextRestoreGState(context)
        
    }
    
    
    func getAttributedStringSourceWithString(stringRef:CFString, font:CTFont) -> [String: AnyObject]
    {


        let glyphInfo = CTGlyphInfoCreateWithCharacterIdentifier(CGFontIndex.min, CTCharacterCollection.AdobeCNS1, stringRef as CFString)

        var alignment = CTTextAlignment.Justified
        var lineBreakMode = CTLineBreakMode.ByWordWrapping
        var lineSpace = self.lineSpace
        var paragraphSpace = titleForTextSpace
    
        
        let alignmentSet = CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.Alignment, valueSize: Int(sizeof(CTTextAlignment)), value: &alignment)
        
        let LineBreakModeSet = CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.LineBreakMode, valueSize: Int(sizeof(CTLineBreakMode)), value: &lineBreakMode)
        
        let ParagraphSpacingSet = CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.ParagraphSpacing, valueSize: Int(sizeof(CGFloat)), value: &paragraphSpace)
        
        let MinimumLineSpacingSet = CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.MinimumLineSpacing, valueSize: Int(sizeof(CGFloat)), value: &lineSpace)
        
        let MaximumLineSpacingSet = CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.MaximumLineSpacing, valueSize: Int(sizeof(CGFloat)), value: &lineSpace)
        
        let paragraphStypeSettings = [alignmentSet, LineBreakModeSet, ParagraphSpacingSet, MinimumLineSpacingSet, MaximumLineSpacingSet]
        
        let paragraphStyle = CTParagraphStyleCreate(paragraphStypeSettings, Int(paragraphStypeSettings.count));
    

        let attrDict: [String: AnyObject] = [
            String(kCTFontAttributeName)           : font,
            String(kCTGlyphInfoAttributeName)      : glyphInfo,
            String(kCTParagraphStyleAttributeName) : paragraphStyle,
            String(kCTKernAttributeName)		   : self.letterSpace,
            String(kCTLigatureAttributeName)       : true,
            String(kCTVerticalFormsAttributeName)  : true
        ]
    
    
        return attrDict
    }
    
    func linesSizeWithString(aString:String, font:UIFont!) -> CGSize{
        let font = CTFontCreateWithName(font.fontName, font.pointSize, nil)
        let textAttrDict = getAttributedStringSourceWithString(aString, font:font)
        let textAttrString  = NSMutableAttributedString(string: aString, attributes: textAttrDict)
        
        let framesetter = CTFramesetterCreateWithAttributedString(textAttrString)
        let constraints = CGSizeMake(self.bounds.size.height, CGFloat.max)
        let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, constraints, nil)
        return size
    }
    
    func linesSizeWithTextString(aString: String) -> CGSize {
        let aFont = UIFont(name: fontName as String, size: fontSize)
        return linesSizeWithString(aString, font: aFont)
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
