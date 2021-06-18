//
//  EndPointProtocol.swift
//  NetworkLayer
//
//  Created by Rizwan Ahmed A.
//  Copyright © 2018 Rizwan Ahmed A. All rights reserved.
//

import Foundation

protocol APIEndPointConvertable {
    var baseURL : URL {get}
    var path : String {get}
    var httpMethod : HTTPMethod {get}
    var OAuthEnabled: OAuthEnabled {get}
    var payload : Payload? {get}
    var headers : HTTPHeaders? {get}
    
    func request() -> URLRequest
    
}


extension APIEndPointConvertable
{
    func request() -> URLRequest
    {
        let requestBuilder = URLRequestBuilder()
        return try! requestBuilder.makeRequest(from: self)
    }
}

