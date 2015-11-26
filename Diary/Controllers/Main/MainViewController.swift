//
//  MainViewController.swift
//  Diary
//
//  Created by zhowkevin on 15/10/5.
//  Copyright © 2015年 kevinzhow. All rights reserved.
//

import UIKit
import CoreData


let DiaryNavTransactionAnimator = DiaryTransactionAnimator()
let HomeYearCollectionViewCellIdentifier = "HomeYearCollectionViewCell"
let DiaryCollectionViewCellIdentifier = "DiaryCollectionViewCell"

class MainViewController: DiaryBaseViewController {
    
    enum InterfaceType: Int {
        case Home
        case Year
        case Month
    }

    @IBOutlet weak var titleLabel: DiaryLabel!
    
    @IBOutlet weak var composeButton: UIButton!
    
    @IBOutlet weak var subLabel: DiaryLabel!
    
    var interfaceType: InterfaceType?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var diarys = [NSManagedObject]()
    
    var fetchedResultsController : NSFetchedResultsController!
    
    var yearsCount: Int = 1
    
    var sectionsCount: Int = 0
    
    var year:Int = 0
    
    var month:Int = 1
    
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var subLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var subLabelCenter: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.delegate = DiaryNavTransactionAnimator
        
        if let interfaceType = interfaceType {
            print(interfaceType)
        } else {
            interfaceType = .Home
        }
        
        //Set Up CollectionView Layout
        let yearLayout = DiaryLayout()
        
        collectionView.setCollectionViewLayout(yearLayout, animated: false)
        
        collectionView.registerNib(UINib(nibName: "DiaryAutoLayoutCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DiaryCollectionViewCellIdentifier)
        
        prepareFetch()
        
        setupUI()
        
        let mDoubleUpRecognizer = UITapGestureRecognizer(target: self, action: "popBack")
        
        mDoubleUpRecognizer.numberOfTapsRequired = 2
        
        self.collectionView.addGestureRecognizer(mDoubleUpRecognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadCollectionView", name: "DiaryChangeFont", object: nil)
        resetCollectionView()
        view.layoutIfNeeded()
    
        // Do any additional setup after loading the view.
    }
    
    func resetCollectionView() {
        
        if portrait {
            collectionView.contentInset = calInsets(true, forSize: CGSize(width: view.frame.size.width, height: view.frame.size.height))
        } else {
            collectionView.contentInset = calInsets(false, forSize:  CGSize(width: view.frame.size.width, height: view.frame.size.height))
        }
        
        if let layout = collectionView.collectionViewLayout as? DiaryLayout {
            layout.collectionViewLeftInsetsForLayout = collectionView.contentInset.left
        }
        
        // Reset CollectionView Offset
        collectionView.contentOffset = CGPoint(x: -collectionView.contentInset.left, y: 0)
        
        collectionView.reloadData()
        
        view.layoutIfNeeded()
    }
    
    func reloadCollectionView() {

        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
    }
    
    func popBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func newCompose() {
        
        let composeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DiaryComposeViewController") as! DiaryComposeViewController
        
        self.presentViewController(composeViewController, animated: true, completion: nil)
        
    }
    
    func setupUI() {
        composeButton.customButtonWith(text: "撰",  fontSize: 14.0,  width: 40.0,  normalImageName: "Oval", highlightedImageName: "Oval_pressed")
        composeButton.addTarget(self, action: "newCompose", forControlEvents: UIControlEvents.TouchUpInside)
        
        titleLabel.config("TpldKhangXiDictTrial", labelText: "二零一五年", fontSize: 20.0, lineHeight: 5.0)
        subLabel.config(defaultFont, labelText: "\(numberToChineseWithUnit(month))月", fontSize: 16.0, lineHeight: 5.0)
        subLabel.updateLabelColor(DiaryRed)
        
        if let titleLabelSize = titleLabel.labelSize {
            titleLabelHeight.constant = titleLabelSize.height
            print(titleLabelSize.height)
        }
        
        if let subLabelSize = subLabel.labelSize {
            subLabelHeight.constant = subLabelSize.height + 1
            if portrait {
                subLabelCenter.constant = -15
            }else {
                subLabelCenter.constant = 50
            }
        }
        
        if let interfaceType = interfaceType {
            
            switch interfaceType {
            case .Home:
                titleLabel.hidden = true
                subLabel.hidden = true
                composeButton.hidden = true
                
            case .Year:
                subLabel.hidden = true
            default:
                break
            }

        }

    }


}
