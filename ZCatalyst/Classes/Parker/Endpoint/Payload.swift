//
//  HTTPTask.swift
//  NetworkLayer
//
//  Created by Rizwan Ahmed A.
//  Copyright © 2018 Rizwan Ahmed A. All rights reserved.
//

import Foundation

typealias HTTPHeaders    = [String:String]

typealias UserAgent   = [String:String]   

typealias OAuthHeaders   = [String:String]


public typealias ZSSOKitCompletionSuccessBlock = (_ accessToken:String) -> ()
public typealias ZSSOKitCompletionErrorBlock = (_ error : Error) -> ()

public protocol ZCatalystAuthProvider: AnyObject {
    func getOAuthToken(success : @escaping ZSSOKitCompletionSuccessBlock, failure : @escaping ZSSOKitCompletionErrorBlock )
}

protocol OAuthCompatible: ZCatalystAuthProvider
{
     func isUserLoggedin() -> (Bool)
     func initializeSSOForActionExtension()

}

enum OAuthEnabled
{
    case enabled(helper: OAuthCompatible)
    case disabled
}

struct Payload
{
    var bodyParameters: Parameters? = nil
    var urlParameters: Parameters? = nil
    var headers:HTTPHeaders? = nil
    var bodyData: Data? = nil
    
    init(bodyParameters: Parameters? = nil, urlParameters: Parameters? = nil, headers: HTTPHeaders? = nil, bodyData: Data? = nil)
    {
        self.bodyData = bodyData
        self.bodyParameters = bodyParameters
        self.headers = headers
        self.urlParameters = urlParameters
    }
    
    mutating func addBody(parameters: Parameters)
    {
        self.bodyParameters = parameters
    }
    
    mutating func addBodyData(data: Data)
    {
        self.bodyData = data
    }
    
    mutating func addURLParameters(parameters: Parameters)
    {
        self.urlParameters = parameters
    }
}
