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
    var OAuthEnabled: OAuthEnabled {get} // Add this and move OAuth out of Payload.
//    var OAuth: OAuthEnabled {get set}
    var payload : Payload? {get}
    var headers : HTTPHeaders? {get}
    
    func request() -> URLRequest
    
}


extension APIEndPointConvertable
{
//    var payload: TempPayload {
//        get {
//
//        }
//        set {
//
//        }
//    }
    func request() -> URLRequest
    {
        let requestBuilder = URLRequestBuilder()
        return try! requestBuilder.makeRequest(from: self)
        
        
        //        requestBuilder.buildRequest(from: self, success: { (urlRequest) in
//            Logger.logNetworkCalls(request: urlRequest!)
//
//        }) { (error) in
//            print(error.debugDescription)
//        }
    }
}

