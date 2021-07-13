//
//  CatalystApp.swift
//  Catalyst
//
//  Created by Giridhar on 17/05/19.
//

import Foundation
//import ZAnalytics


internal enum Constants: String
{
    case defaultName = "__CatalystDefaultApp"
    case appConfigName = "AppConfiguration"
    case environmentName = "DefaultDevelopmentEnv"
    case apnsTokenKey = "__catalyst__pushnotification__key"
    case apnsInstallationKey = "__catalyst__installation__key"
    
    var string: String {
        return self.rawValue
    }
}

public enum ZCatalystAccountType
{
    case production
    case development
}

public enum ServerTLD : String
{
    case eu = "eu"
    case `in` = "in"
    case com = "com"
    case cn = "com.cn"
    case au = "com.au"
    
    init?( serverTLD : String )
    {
        switch serverTLD
        {
        case "eu" :
            self.init( rawValue : "eu" )
        case "in" :
            self.init( rawValue : "in" )
        case "com" :
            self.init( rawValue : "com" )
        case "cn" :
            self.init( rawValue : "com.cn" )
        case "au" :
            self.init( rawValue : "com.au" )
        default :
            self.init( rawValue : "com" )
        }
    }
}


/// The Catalyst class lets you initialize an application/project
public class ZCatalystApp
{
    public internal( set ) var appConfig : ZCatalystAppConfiguration!
    
    static var sessionCompletionHandlers : [ String : () -> () ] = [ String : () -> () ]()
    public static var fileUploadURLSessionConfiguration : URLSessionConfiguration = .default
    public static var fileDownloadURLSessionConfiguration : URLSessionConfiguration = .default
    public static let shared = ZCatalystApp()
    
    private init()
    {
    }
    
    public func initSDK( window : UIWindow, appConfiguration : ZCatalystAppConfiguration )
    {
        ZCatalystApp.shared.appConfig = appConfiguration
        ZCatalystAuthHandler.initIAMLogin( with : window, config : appConfiguration )
    }
    
    public func initSDK( window : UIWindow, environment : ZCatalystAccountType ) throws
    {
        var plistName = "AppConfiguration"
        if environment == .production
        {
            plistName += "Production"
        }
        else
        {
            plistName += "Development"
        }
        guard let appConfigPlist = Bundle.main.path( forResource : plistName, ofType : "plist" ), let appConfig = NSDictionary( contentsOfFile : appConfigPlist ) as? [String : Any] else
        {
            ZCatalystLogger.logError( message : "Error Occurred : \( ErrorCode.initializationError ) : \(plistName).plist is not found, Details : -" )
            throw ZCatalystError.sdkError(code: ErrorCode.initializationError, message: "\(plistName).plist is not found.", details: nil)
        }
        let configData = try JSONSerialization.data( withJSONObject: appConfig, options : [] )
        let decoder = JSONDecoder()
        let appConfiguration = try decoder.decode( ZCatalystAppConfiguration.self, from : configData )
        ZCatalystApp.shared.appConfig = appConfiguration
        ZCatalystApp.shared.appConfig.environment = environment
        ZCatalystAuthHandler.initIAMLogin( with : window, config : appConfiguration )
    }
    
    public func getCurrentUser( completion: @escaping ( Result< ZCatalystUser,ZCatalystError > ) -> Void )
    {
        APIHandler().getCurrentUser( completion : completion )
    }
    
    public func signUp(user: ZCatalystUser, completion: @escaping (Result<( ZCatalystUser, Int64 ), ZCatalystError >) -> Void)
    {
        APIHandler().signUp( user : user, completion : completion )
    }
    
    public func handleLoginRedirection( _ url : URL, sourceApplication : String?, annotation : Any )
    {
        ZCatalystAuthHandler.handleRedirectURL( url, sourceApplication : sourceApplication, annotation : annotation )
    }
    
    public func showLogin( completion : @escaping ( Error? ) -> Void )
    {
        if ZCatalystApp.shared.isUserSignedIn()
        {
            completion( nil )
        }
        else
        {
            ZCatalystAuthHandler.presentLogin( completion : completion )
        }
    }
    
    public func logout( completion : @escaping ( Error? ) -> Void )
    {
        ZCatalystAuthHandler.logout( completion : completion )
    }
    
    public func isUserSignedIn() -> Bool
    {
        return ZCatalystAuthHandler.isUserSignedIn()
    }
    
    public func getFileStoreInstance() -> ZCatalystFileStore
    {
        return ZCatalystFileStore()
    }
    
    public func getFunctionInstance( id : Int64 ) -> ZCatalystFunction
    {
        return ZCatalystFunction( identifier : String( id ) )
    }
    
    public func getFunctionInstance( name : String ) -> ZCatalystFunction
    {
        return ZCatalystFunction( identifier : name )
    }
    
    public func getDataStoreInstance() -> ZCatalystDataStore
    {
        return ZCatalystDataStore()
    }
    
    public func newUser( lastName : String, email : String ) -> ZCatalystUser
    {
        let user = ZCatalystUser()
        user.lastName = lastName
        user.email = email
        return user
    }
    
    public func search( searchOptions : ZCatalystSearchOptions, completion : @escaping( Result< [ String : Any ], ZCatalystError > ) -> Void )
    {
        APIHandler().search( searchOptions : searchOptions, completion )
    }
    
    /**
     To resume the URLSession delegate method calls when the app transition from background to foreground
     
     NSURLSession delegate methods won't get invoked in some devices when app resumes from background. We have to resume atleast one task in that URLSession to resume the delgate method calls.
     */
    public func notifyApplicationEnterForeground()
    {
        Router.fileUploadURLSessionWithDelegates.getTasksWithCompletionHandler() { _, uploadTasks, _ in
            uploadTasks.first?.resume()
        }
        Router.fileDownloadURLSessionWithDelegates.getTasksWithCompletionHandler() { _, _, downloadTasks in
            downloadTasks.first?.resume()
        }
    }
    
    public func notifyBackgroundSessionEvent(_ identifier : String, _ completionHandler : @escaping () -> Void)
    {
        ZCatalystApp.sessionCompletionHandlers.updateValue( completionHandler, forKey: identifier)
    }
}
