//
//  NetworkManager.swift
//  Catalyst
//
//  Created by Giridhar on 20/05/19.
//

import Foundation

struct ServerURL
{
    static func url(projectID: String) -> URL
    {
        let serverURL: String = ZCatalystApp.shared.appConfig.apiBaseURL + "/baas/" + ZCatalystApp.shared.appConfig.apiVersion
        var url = URL(string: serverURL)!
        url.appendPathComponent("project/\(projectID)")
        return url
    }
    
    static func url() -> URL
    {
        let projectID = ZCatalystApp.shared.appConfig.projectId
        return self.url(projectID: projectID)
    }
    
    static func stratusURL( bucketName: String, fileName: String, queryParams : [ String : String ] , fromCache: Bool) -> URL?
    {
        let environment = ( ZCatalystApp.shared.appConfig.environment == .development ) ? "-development" : ""
        guard let serverURL: URL = ZCRMURLBuilder(path: "/" + fileName, host: bucketName + environment + (fromCache ? ZCatalystApp.shared.appConfig.nimbusDomainSuffix : ZCatalystApp.shared.appConfig.stratusDomainSuffix), queryItems: queryParams.map{ URLQueryItem(name: $0.key, value: $0.value ) }).url else
        {
            return nil
        }
        return serverURL
    }
    
    static var portalHeaderName = "PROJECT_ID"
    
    static func portalHeader() -> HTTPHeaders
    {
        let portalID = ZCatalystApp.shared.appConfig.portalId
        return [self.portalHeaderName: portalID]
    }
    static var userAgent : String = "User-Agent"
    
    static func getUserAgent() -> UserAgent
    {
        let userAgent = ZCatalystApp.shared.appConfig.userAgent
        return [ self.userAgent : userAgent ]
    }
    
}

enum AuthAPI
{
    case signup( user : ZCatalystUser )
}

enum UserAPI
{
    case getCurrentUser
}

enum TimeZoneAPI
{
    case getTimeZone
}

enum FileStorageAPI
{
    case fetchAll( folderId : Int64 )
    case fetch( folderId : String, fileId : String )
    case uploadFile(folderId: String)
    case downloadFile(folderId: String, fileId: String)
    case deleteFile(folderId: String, fileId: String)
}

enum FolderAPI
{
    case fetchAll
    case fetch( folder : String )
}

enum StratusAPI
{
    case getObjects( parameters: Parameters? )
    case getObject( parameters: Parameters? )
    case uploadObject( String,  headers: HTTPHeaders?)
    case downloadObject( String )
    case deleteObject( String )
    case deleteObjects( params: Parameters?, body : Parameters? )
    case deletePath( parameters: Parameters? )
}

enum FunctionsAPI
{
    case execute(id: String, requestMethod: HTTPMethod, parameters: Parameters?, body: Parameters?)
}

enum QueryAPI
{
    case execute(query: String)
}

enum RowAPI
{
    case fetchAll(table: String, nextPageToken : String?, perPage : String?)
    case fetch( table : String, row : Int64 )
    case update(json: Data, table: String)
    case delete(row: Int64, table: String)
    case insert(json: Data, table: String)
}

enum ColumAPI
{
    case fetch( table : String, column : Int64 )
    case fetchAll( table : String )
}

enum PushNotificationAPI
{
    case register(paramets: Parameters?,appID: String)
    case deregister(parameters: Parameters?,appID:String)
}

enum SearchAPI
{
    case search( text : String,
                searchColoumn :Parameters,
                selectTableColoumn : Parameters?,
                order : Parameters?,
                startIndex : Int?,
                endIndex : Int? )
    
}
