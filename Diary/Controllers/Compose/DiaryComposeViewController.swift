//
//  DiaryComposeViewController.swift
//  Diary
//
//  Created by kevinzhow on 15/3/4.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import UIKit
import CoreData
import NCChineseConverter

let titleTextViewHeight:CGFloat = 30.0
let contentMargin:CGFloat = 20.0
let locationHelper: DiaryLocationHelper = DiaryLocationHelper()

class DiaryComposeViewController: DiaryBaseViewController{

    @IBOutlet weak var locationTextViewToBottom: NSLayoutConstraint!
    
    @IBOutlet var composeView: UITextView!
    
    @IBOutlet weak var locationTextView: UITextView!
    
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    var keyboardSize:CGSize = CGSizeMake(0, 0)
    
    var diaryKeyString: String?
    
    var diary:Diary?
    
    var changeText = false
    
    var changeTextCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        let textAttributes: [String : AnyObject]! = [NSFontAttributeName: DiaryFont, NSVerticalGlyphFormAttributeName: 1, NSParagraphStyleAttributeName: paragraphStyle, NSKernAttributeName: 3.0]

        composeView.typingAttributes = textAttributes
        composeView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        //Add LocationTextView
        locationTextView.font = UIFont(name: defaultFont, size: 16) as UIFont!

        locationTextView.alpha = 0.0
        locationTextView.bounces = false
        locationTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        //Add titleView

        titleTextView.font = DiaryFont
        titleTextView.bounces = false
        titleTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        if let diary = diary {
            composeView.text = diary.content
            self.composeView.contentOffset = CGPointMake(0, self.composeView.contentSize.height)
            locationTextView.text = diary.location
            locationTextView.alpha = 1.0
            if let title = diary.title {
                titleTextView.text = title
            }else{
                titleTextView.text = "\(numberToChineseWithUnit(NSCalendar.currentCalendar().component(NSCalendarUnit.Day, fromDate: diary.created_at))) 日"
            }
        }else{
            let date = NSDate()
            titleTextView.text = "\(numberToChineseWithUnit(NSCalendar.currentCalendar().component(NSCalendarUnit.Day, fromDate: date))) 日"
        }

        composeView.becomeFirstResponder()


        //Add finish button

        finishButton.customButtonWith(text: "完",  fontSize: 18.0,  width: 50.0,  normalImageName: "Oval", highlightedImageName: "Oval_pressed")

        finishButton.addTarget(self, action: "finishCompose:", forControlEvents: UIControlEvents.TouchUpInside)

        // keyboardDidShow后面添加了冒号，意思是指这个方法接收参数，级下面的notification: NSNotification
        // 这里的object可以填入想要传递的数据。
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name:UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateAddress", name: "DiaryLocationUpdated", object: nil)

        updateAddress()
        // Do any additional setup after loading the view.
    }

    func updateAddress() {

        if let address = locationHelper.address {

            debugPrint("Author at \(address)")

            if let _ = diary?.location {
                locationTextView.text = diary?.location
            }else {
                locationTextView.text = "于 \(address)"
            }

            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                { [weak self] in
                    self?.locationTextView.alpha = 1.0

                }, completion: nil)

            locationHelper.locationManager.stopUpdatingLocation()
        }

    }

    func finishCompose(button: UIButton) {

        self.composeView.endEditing(true)
        
        self.locationTextView.endEditing(true)

        if (composeView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 1){

            let translationtext = (composeView.text as NSString).chineseStringHK()
            
            if let managedContext = DiaryCoreData.sharedInstance.managedContext {
            
                if let diary = diary {

                    diary.content = translationtext
                    diary.location = locationTextView.text
                    diary.title = titleTextView.text
                    
                    if let DiaryID = diary.id {
                        
                        fetchCloudRecordWithID(DiaryID, complete: { (record) -> Void in
                            if let record = record {
                                updateRecord(diary, record: record)
                            }
                        })
                    }
                    
                }else{

                    let entity =  NSEntityDescription.entityForName("Diary", inManagedObjectContext: managedContext)

                    let newdiary = Diary(entity: entity!,
                        insertIntoManagedObjectContext:managedContext)
                    
                    newdiary.id = randomStringWithLength(32) as String
                    
                    newdiary.content = translationtext

                    if let address  = locationHelper.address {
                        newdiary.location = address
                    }

                    if let title = titleTextView.text {
                        newdiary.title = title
                    }
                    
                    newdiary.updateTimeWithDate(NSDate())
                    
                    saveNewRecord(newdiary)
                }

                do {
                    try managedContext.save()
                } catch let error as NSError {
                    debugPrint("Could not save \(error), \(error.userInfo)")
                }
            }

        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func updateTextViewSizeForKeyboardHeight(keyboardHeight: CGFloat) {

        let newKeyboardHeight = keyboardHeight

        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            { [weak self] in

                self?.locationTextViewToBottom.constant = newKeyboardHeight + 25.0
                
                self?.view.layoutIfNeeded()

            }, completion: nil)
    }

    func keyboardDidShow(notification: NSNotification) {
        // 这里的userInfo一般是系统消息， object则是你放入object里的对象，可以使用as方法转化成需要的类型
        if let rectValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            keyboardSize = rectValue.CGRectValue().size
            updateTextViewSizeForKeyboardHeight(keyboardSize.height)
        }
    }

    func keyboardDidHide(notification: NSNotification) {
        updateTextViewSizeForKeyboardHeight(0)
    }

}

