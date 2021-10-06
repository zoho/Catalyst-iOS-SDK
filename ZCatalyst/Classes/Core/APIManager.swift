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
    
    static var portal_header_name = "PROJECT_ID"
    
    static func portalHeader() -> HTTPHeaders
    {
        let portalID = ZCatalystApp.shared.appConfig.portalId
        return [self.portal_header_name: portalID]
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

enum FileStorageAPI
{
    case fetchAll( folderId : Int64 )
    case fetch( folderId : String, fileId : String )
    case uploadFile(folderId: String)
    case downloadFile(folderId: String, fileId: String)
    case deleteFile
}

enum FolderAPI
{
    case fetchAll
    case fetch( folder : String )
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
    case fetchAll(table: String)
    case fetch( table : String, row : Int64 )
    case update(json: Data, table: String)
    case delete(row: Int64, table: String)
    case insert(json: Data, table: String)
}

enum TableAPI
{
    case fetch( table : String )
    case fetchAll
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
                search_coloumn :Parameters,
                select_table_coloumn : Parameters?,
                order : Parameters?,
                startIndex : Int?,
                endIndex : Int? )
    
}
