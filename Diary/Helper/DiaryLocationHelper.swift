//
//  DiaryLocationHelper.swift
//  Diary
//
//  Created by kevinzhow on 15/3/7.
//  Copyright (c) 2015年 kevinzhow. All rights reserved.
//

import CoreLocation

class DiaryLocationHelper: NSObject, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()
    var currentLocation:CLLocation?
    var address:String?
    var geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // 设置位移通知最小间隔
        locationManager.pausesLocationUpdatesAutomatically = true // 当用户不再移动是自动暂停
        locationManager.headingFilter = kCLHeadingFilterNone // 用户朝向变化角度最小间隔
        locationManager.requestWhenInUseAuthorization() // 请求用户授权当App需要获取位置的时候。
        debugPrint("Location Right")
        if (CLLocationManager.locationServicesEnabled()){
            // 如果用户已经授权，那么开始获取位置
            locationManager.startUpdatingLocation()
        }
    }
    
    // 每当用户位置更新的时候，本方法就会被调用
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        // 通过reverseGeocodeLocation查询用户位置的描述
        geocoder.reverseGeocodeLocation(newLocation, completionHandler: { (placemarks, error) in
            
            if let error = error {
                debugPrint("reverse geodcode fail: \(error.localizedDescription)")
            }
            // placemark里面包含了位置的国家，省份，地区等信息
            if let pm = placemarks {
                if pm.count > 0 {
                    
                    let placemark = pm.first
                    
                    self.address = placemark?.locality
                    // 将位置信息通过通知发送出去
                    NSNotificationCenter.defaultCenter().postNotificationName("DiaryLocationUpdated", object: self.address)
                }
            }
            
        })
    }
}

