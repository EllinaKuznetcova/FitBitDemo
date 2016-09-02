//
//  Steps.swift
//  FitBitIntegration
//
//  Created by Ellina Kuznecova on 01.09.16.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import Foundation
import ObjectMapper

class Steps: Object, Mappable {
    dynamic var startDate: NSDate = NSDate(){
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    dynamic var endDate: NSDate = NSDate().fs_tomorrow {
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    dynamic var count: Int = 0
    
    dynamic var compoundKey: String = ""
    
    override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    required convenience init?(_ map: ObjectMapper.Map) {
        self.init()
    }
    
    private func compoundKeyValue() -> String {
        return "\(startDate)-\(endDate)"
    }
}

extension Steps {
    func mapping(map: ObjectMapper.Map) {
        let json = map.JSONDictionary
        
        if let intCount = (json["value"] as? NSNumber)?.integerValue {
            self.count = intCount
        }
        else if let stringCount = Int(json["value"] as! String) {
            self.count = stringCount
        }
        
        let dateValue = json["dateTime"] as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let date = dateFormatter.dateFromString(dateValue)!
        
        if let timeValue = json["time"] as? String {
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            timeFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
            let time = timeFormatter.dateFromString(timeValue)!
            
            self.startDate = self.dateFrom(date, time: time)
            
            let timeInterval:NSTimeInterval = self.startDate.timeIntervalSinceReferenceDate + FSTimePeriod.Minute.rawValue * NSTimeInterval(15)
            self.endDate = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        }
        else {
            self.startDate = date
            self.endDate = date.fs_tomorrow
        }
    }
    
    
    
    func dateFrom(date: NSDate, time: NSDate) -> NSDate {
        
        let dateComponents = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        
        let timeComponents = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: time)
        
        let dateTimeComponents = NSDateComponents()
        dateTimeComponents.year = dateComponents.year
        dateTimeComponents.month = dateComponents.month
        dateTimeComponents.day = dateComponents.day
        dateTimeComponents.hour = timeComponents.hour
        dateTimeComponents.minute = timeComponents.minute
        dateTimeComponents.second = timeComponents.second
        
        return NSCalendar.currentCalendar().dateFromComponents(dateTimeComponents)!
    }
}