//
//  AlamofireHelpers.swift
//  FitBitIntegration
//
//  Created by Ellina Kuznecova on 31.08.16.
//  Copyright © 2016 Ellina Kuznetcova. All rights reserved.
//

import Foundation

extension Request {
    
    func responseObject<T: Mappable>(completionHandler: Response<T, RTError> -> Void) -> Self {
        
        let responseSerializer = ResponseSerializer<T, RTError> { request, response, data, error in
            guard error == nil else { return .Failure(RTError(request: .Unknown(error: error)))}
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                
                guard let json = value as? [String : AnyObject] else {
                    return .Failure(RTError(serialize: .WrongType))
                }
                
                guard var object = T(JSON: json) else {return .Failure(RTError(serialize: .RequeriedFieldMissing))}
                
                object = Mapper<T>().map(json, toObject: object)
                
                return .Success(object)
                
            case .Failure(_):
                return .Failure(RTError(serialize: .JSONSerializingFailed))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
