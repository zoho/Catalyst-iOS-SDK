//
//  Logger.swift
//  NetworkLayer
//
//  Created by Rizwan Ahmed A on 22/07/18.
//  Copyright © 2018 Rizwan Ahmed A. All rights reserved.
//

import Foundation

class Logger {
    static func logNetworkCalls(request : URLRequest){
        #if DEBUG
        
//        print("\n ******************** OUTGOING REQUEST ******************** \n")
//        defer {print("\n ******************** END ********************")}
//        
//        let urlString = request.url?.absoluteString ?? ""
//        let urlComponents = URLComponents(string: urlString)
//        
//        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "" )" : ""
//        
//        let urlPath = "\(urlComponents?.path ?? "")"
//        
//        let query = "\(urlComponents?.query ?? "")"
//        
//        let host = "\(urlComponents?.host ?? "")"
//        
//        var loggedOutput = " REQUEST URL :\(urlString) \n HTTP METHOD : \(method) \n URL PATH: \(urlPath) \n QUERY PARAMS : \(query) \n HOST : \(host) \n "
//        
//        for (key,value) in request.allHTTPHeaderFields ?? [:]{
//            loggedOutput += "\(key) : \(value) \n"
//        }
//        
//        if let body = request.httpBody{
//            loggedOutput += " \(String(data: body, encoding: .utf8) ?? "") "
//        }
//        print(loggedOutput)
        
        #endif
        
        
    }
}
