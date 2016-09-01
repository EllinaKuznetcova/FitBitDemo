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
    enum Auth {
    }
}

extension Router.Auth: RouterProtocol {
    var settings: RTRequestSettings {
        return RTRequestSettings(method: .POST)
    }
    
    var path: String {
//        switch self {
//        case .GetAuthPhoneCode(_): return "/auth_phone_codes"
//        case .Register:         return "/users"
//        case .SignIn:           return "/users/sign_in"
//        }
        return ""
    }
    
    var parameters: [String : AnyObject]? {
//        switch self {
//        case .GetAuthPhoneCode(let phone):  return ["phone_number": phone]
//        case .Register(let firstName, let lastname, let email, let phone, let authPhoneCode, let smsCode):
//            return ["first_name" : firstName,
//                    "last_name" : lastname,
//                    "email" : email,
//                    "phone_number" : phone,
//                    "auth_phone_code_id" : authPhoneCode,
//                    "sms_code": smsCode]
//        case .SignIn(let phone, let authPhoneCode, let smsCode):
//            return ["phone_number": phone,
//                    "auth_phone_code_id" : authPhoneCode,
//                    "sms_code" : smsCode]
//        }
        return nil
    }
}
