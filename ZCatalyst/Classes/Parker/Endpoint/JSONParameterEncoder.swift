//
//  JSONParameterEncoder.swift
//  NetworkLayer
//
//  Created by Rizwan Ahmed A.
//  Copyright © 2018 Rizwan Ahmed A. All rights reserved.
//

import Foundation

struct JSONParameterEncoder : ParameterEncoder {

    
    static func encode(urlRequest: inout URLRequest, jsonBody body: Data?, withParameters parameters: Parameters) {
        if let dataBody = body {
            urlRequest.httpBody = dataBody
            
        }
        
        if urlRequest.value(forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)") == nil {
            urlRequest.setValue("\(HeaderValueTypes.applicationJSON.rawValue)", forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)")
        }
    }
    
    static func encode(urlRequest: inout URLRequest, jsonBody body: Parameters?) throws {
        do {
            guard let aBody = body else  {
                throw NetworkErrors.encodingFailed
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: aBody, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            
            if urlRequest.value(forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)") == nil {
                urlRequest.setValue("\(HeaderValueTypes.applicationJSON.rawValue)", forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)")
            }
            
        }
        catch{
            throw NetworkErrors.encodingFailed
        }
    }
    
   
   
    
}
