//
//  Router.swift
//  FitBitIntegration
//
//  Created by Ellina Kuznecova on 31.08.16.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import Foundation

enum Router {
    static let BaseURL = "https://api.fitbit.com/1"
    static var OAuthToken: String? {
        do {
            let realm = try Realm()
            return realm.objects(User).first?.fitbitToken
        }
        catch {
            return nil
        }
    }
}

protocol RouterProtocol: URLRequestConvertible {
    var settings: RTRequestSettings {get}
    var path: String {get}
    var parameters: [String : AnyObject]? {get}
}

extension RouterProtocol {
    
    func defaultURLRequest () -> NSMutableURLRequest {
        
        let URL = NSURL(string: Router.BaseURL)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(self.path))
        mutableURLRequest.HTTPMethod = self.settings.method.rawValue
        
        if let token = Router.OAuthToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return self.settings.encoding.encode(mutableURLRequest, parameters: parameters).0
    }
    
    var URLRequest: NSMutableURLRequest {
        return self.defaultURLRequest()
    }
    
    func request () -> Alamofire.Request {
        return Alamofire.request(self.URLRequest).validate()
    }
}

struct RTRequestSettings {
    let method: Alamofire.Method
    let encoding: ParameterEncoding
    
    init (method: Alamofire.Method, encoding: ParameterEncoding? = nil) {
        self.method = method
        self.encoding = encoding ?? method.encoding
    }
}

extension Alamofire.Method {
    var encoding : ParameterEncoding {
        switch self {
        case .GET                   : return .URL
        case .POST, .PUT, .PATCH    : return .JSON
        default                     : return .URL
        }
    }
}
