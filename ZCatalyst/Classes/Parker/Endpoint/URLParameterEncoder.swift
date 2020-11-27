//
//  URLParameterEncoding.swift
//  NetworkLayer
//
//  Created by Rizwan Ahmed A.
//  Copyright © 2018 Rizwan Ahmed A. All rights reserved.
//

import Foundation

struct URLParameterEncoder : ParameterEncoder{

// 044-22672902
    
    
    static func encode(urlRequest: inout URLRequest, jsonBody body: Data?, withParameters parameters: Parameters) throws {
        
        do{
            guard let url = urlRequest.url else{
                throw NetworkErrors.missingURL
            }
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty{
                
                urlComponents.queryItems = [URLQueryItem]()
                
                for (key,value) in parameters {
                    let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                    urlComponents.queryItems?.append(queryItem)
                }
                urlRequest.url = urlComponents.url

            }
            
            
            //TODO: Fix this
            if (urlRequest.value(forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)") == nil){
                urlRequest.setValue("\(HeaderValueTypes.applicationJSON.rawValue)\(HeaderValueTypes.utf8Charset.rawValue)", forHTTPHeaderField: "\(HeaderKeyTypes.contentType.rawValue)")
            }
        }catch{
            throw NetworkErrors.encodingFailed
        }
    }
    
//    public static func encode(parameters: Parameters) -> String
//    {
//        for (key,value) in parameters
//        {
//            let queryItem = URLQueryItem(name: key, value:"\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
//        
//        }
//    }
    
    
}
