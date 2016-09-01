//
//  User.swift
//  FitBitIntegration
//
//  Created by Ellina Kuznecova on 01.09.16.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import Foundation

class User: Object {
    dynamic var id: Int = 0
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var email: String = ""
    
    var fitbitToken: String? {
        get {
            guard let ssToken = SAMKeychain.passwordForService(FSKeychainKey.APIToken, account: FSKeychainKey.AccountName) else {return self._fitbitToken}
            return ssToken
        }
        set(newToken) {
            if newToken == nil {
                self._fitbitToken = nil
                SAMKeychain.deletePasswordForService(FSKeychainKey.APIToken, account: FSKeychainKey.AccountName)
            } else {
                self._fitbitToken = newToken
                SAMKeychain.setPassword(newToken, forService: FSKeychainKey.APIToken, account: FSKeychainKey.AccountName)
            }
        }
    }
    var _fitbitToken: String?
    
    class func get() -> User? {
        do {
            let realm = try Realm()
            return realm.objects(User).first
        }
        catch {
            return nil
        }
    }
}