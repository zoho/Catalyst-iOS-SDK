//
//  Parker.swift
//  NetworkLayer
//
//  Created by Giridhar on 10/05/19.
//  Copyright © 2019 Rizwan Ahmed A. All rights reserved.
//

import Foundation

internal protocol NetworkRequestable
{
    @discardableResult
    func request(_ route: APIEndPointConvertable, session:URLSession, completion: @escaping (Result<Data, ZCatalystError>) -> Void) -> URLSessionTask?
    
    @discardableResult
    func requestDataResponse(_ route: APIEndPointConvertable, session:URLSession, completion: @escaping (Result<( Data, HTTPURLResponse ), ZCatalystError>) -> Void) -> URLSessionTask?
    
    func requestWithID(_ route: APIEndPointConvertable, session:URLSession, completion: @escaping (Result<Data, ZCatalystError>) -> Void) -> String
    
    func cancelRequest(id: String)
    
    func upload( fileRefId : String, filePath : URL?, fileName : String?, fileData : Data?, url : APIEndPointConvertable, fileUploadDelegate : ZCatalystFileUploadDelegate )
    
    func upload( filePath : URL?, fileName : String?, fileData : Data?, url : APIEndPointConvertable, completion: @escaping (Result<Data,ZCatalystError>) -> Void )
    
    func download( url : APIEndPointConvertable, completion : @escaping ( Result< URL, ZCatalystError > ) -> Void )
    
    func download( url : APIEndPointConvertable, fileRefId : String, fileDownloadDelegate : ZCatalystFileDownloadDelegate )
    
    func upload( bucketName: String, filePath : String?, fileName : String?, data : Data?, shouldCompress: Bool, completion : @escaping ( ZCatalystError? ) -> Void )
    
    func download( bucketName: String, fileName: String, versionId : String?, fromCache: Bool, completion : @escaping ( Result< URL, ZCatalystError > ) -> Void )
    
    func upload( bucketName: String, fileRefId: String, filePath : String?, fileName : String?, data : Data?, shouldCompress: Bool, fileUploadDelegate : ZCatalystFileUploadDelegate )
    
    func download( bucketName: String, fileName: String, fileRefId: String, versionId : String?, fromCache: Bool, fileDownloadDelegate : ZCatalystFileDownloadDelegate )
}

struct Parker: NetworkRequestable
{
    let router: Router
    init()
    {
        router = Router()
    }
    
    @discardableResult
    func requestWithID(_ route: APIEndPointConvertable, session:URLSession, completion: @escaping (Result<Data, ZCatalystError>) -> Void) -> String
    {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = ZCatalystApp.shared.appConfig.requestTimeOut
        let session = URLSession( configuration : configuration )
        return router.request(route, session: session, completion: completion)
    }
    
    func cancelRequest(id: String)
    {
        let task:URLSessionTask? = router.tasks[id]
        guard let aTask = task else
        {
            print("No task found")
            return
        }
        aTask.cancel()
        print("Cancelled")
    }
    
    @discardableResult
    func requestDataResponse(_ route: APIEndPointConvertable, session: URLSession, completion: @escaping (Result<(Data, HTTPURLResponse), ZCatalystError>) -> Void) -> URLSessionTask? {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = ZCatalystApp.shared.appConfig.requestTimeOut
        let session = URLSession( configuration : configuration )
        return Router.request(route, session: session, completion: completion)
    }
    
    @discardableResult
    func request(_ route: APIEndPointConvertable, session: URLSession = URLSession.shared, completion: @escaping (Result<Data, ZCatalystError>) -> Void) -> URLSessionTask? {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = ZCatalystApp.shared.appConfig.requestTimeOut
        let session = URLSession( configuration : configuration )
        return Router.requestData(route, session: session, completion: completion)
    }
    
    func upload( fileRefId : String, filePath : URL?, fileName : String?, fileData : Data?, url : APIEndPointConvertable, fileUploadDelegate : ZCatalystFileUploadDelegate )
    {
        router.upload(url, fileRefId : fileRefId, filePath : filePath, fileName : fileName, fileData : fileData, fileUploadDelegate : fileUploadDelegate)
    }
    
    func upload( filePath : URL?, fileName : String?, fileData : Data?, url : APIEndPointConvertable, completion : @escaping ( Result< Data, ZCatalystError > ) -> Void )
    {
        router.upload( url, filePath : filePath, fileName : fileName, fileData : fileData) { ( result ) in
            switch result
            {
            case .success(let ( data, _ )) :
                completion( .success( data ) )
            case .error(let error) :
                completion( .error( error ) )
            }
        }
    }
    
    func upload( bucketName: String, filePath : String?, fileName : String?, data : Data?, shouldCompress: Bool = false, completion : @escaping ( ZCatalystError? ) -> Void )
    {
        router.uploadObject(bucketName: bucketName, filePath: filePath, fileName: fileName, fileData: data, shouldCompress: shouldCompress, completion: completion)
    }
    
    func upload(bucketName: String, fileRefId: String, filePath: String?, fileName: String?, data: Data?, shouldCompress: Bool = false, fileUploadDelegate: ZCatalystFileUploadDelegate) {
        router.uploadObject(bucketName: bucketName, fileRefId: fileRefId, filePath: filePath, fileName: fileName, fileData: data, shouldCompress: shouldCompress, fileUploadDelegate : fileUploadDelegate)
    }
    
    func download( bucketName : String, fileName : String, versionId : String? = nil, fromCache: Bool, completion : @escaping ( Result< URL, ZCatalystError > ) -> Void )
    {
        router.downloadObject( bucketName: bucketName, fileName : fileName, versionId: versionId, fromCache: fromCache, completion : completion )
    }
    
    func download(bucketName: String, fileName: String, fileRefId: String, versionId: String?, fromCache: Bool, fileDownloadDelegate: ZCatalystFileDownloadDelegate) {
        router.downloadObject( bucketName: bucketName, fileName: fileName, fileRefId: fileRefId, versionId: versionId, fromCache: fromCache, fileDownloadDelegate: fileDownloadDelegate )
    }
    
    func download( url : APIEndPointConvertable, completion : @escaping ( Result< URL, ZCatalystError > ) -> Void )
    {
        router.download( url) { ( result ) in
            completion( result )
        }
    }
    
    func download( url : APIEndPointConvertable, fileRefId : String, fileDownloadDelegate : ZCatalystFileDownloadDelegate )
    {
        router.download( url, fileRefId : fileRefId, fileDownloadDelegate : fileDownloadDelegate )
    }
}
