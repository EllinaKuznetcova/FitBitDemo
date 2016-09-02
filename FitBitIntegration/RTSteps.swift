//
//  RTAuth.swift
//  FitBitIntegration
//
//  Created by Ellina Kuznecova on 31.08.16.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import Foundation
import ObjectMapper

extension Router {
    enum Steps{
        case GetToday
    }
}

extension Router.Steps: RouterProtocol {
    var settings: RTRequestSettings {
        return RTRequestSettings(method: .GET)
    }
    
    var path: String {
        switch self {
        case .GetToday: return "/user/-/activities/steps/date/2016-09-01/1d/15min.json"
        }
    }
    
    var parameters: [String : AnyObject]? {
        return nil
    }
}

class RTStepsResponse: Mappable  {
    var stepsPerDay: Steps?
    var stepsIntraday: [Steps] = []
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        guard let stepsPerDayJsonValue = (map.JSONDictionary["activities-steps"] as? [[String : AnyObject]])?.first else {return}
        let stepsPerDayJson = ["activities-steps": stepsPerDayJsonValue]
        let stepsPerDayMap = Map(mappingType: map.mappingType, JSONDictionary: stepsPerDayJson)
        
        self.stepsPerDay <- stepsPerDayMap["activities-steps"]
        
        guard let dayString = (map.JSONDictionary["activities-steps"] as? [[String : AnyObject]])?.first?["dateTime"] else {return}
        guard var stepsIntradayJsonArray = (map.JSONDictionary["activities-steps-intraday"] as? [String: AnyObject])?["dataset"] as? [[String : AnyObject]] else {return}
        
        for i in 0..<stepsIntradayJsonArray.count {
            stepsIntradayJsonArray[i]["dateTime"] = dayString
        }
        let stepsIntradayJson = ["activities-steps-intraday": stepsIntradayJsonArray]
        let intaradayMap = Map(mappingType: map.mappingType, JSONDictionary: stepsIntradayJson)
        
        self.stepsIntraday <- intaradayMap["activities-steps-intraday"]
    }
}
