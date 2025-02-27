//
//  ZCatalystBucket.swift
//  ZCatalyst
//
//  Created by Gowtham B R on 12/02/25.
//

import Foundation

public class ZCatalystBucket {
    public internal( set ) var name : String
    
    init(name: String) {
        self.name = name
    }
    
    public func upload( filePath : String, fileName : String? = nil, shouldCompress: Bool = false, completion : @escaping ( ZCatalystError? ) -> Void ) {
        APIHandler().uploadObject( bucketName : name, filePath : filePath, fileName : fileName, data: nil, shouldCompress: shouldCompress, completion : completion )
    }
    
    public func upload( fileName : String, data : Data, shouldCompress: Bool = false, completion : @escaping ( ZCatalystError? ) -> Void ) {
        APIHandler().uploadObject( bucketName : name, filePath : nil, fileName : fileName, data: data, shouldCompress: shouldCompress, completion : completion )
    }
    
    public func upload( fileRefId : String, filePath : String, fileName : String? = nil, shouldCompress: Bool = false, fileUploadDelegate : ZCatalystFileUploadDelegate ) {
        APIHandler().uploadObject( bucketName : name, fileRefId : fileRefId, filePath : filePath, fileName : fileName, data: nil, shouldCompress: shouldCompress, fileUploadDelegate: fileUploadDelegate )
    }
    
    public func upload( fileRefId : String, fileName : String, data : Data, shouldCompress: Bool = false, fileUploadDelegate : ZCatalystFileUploadDelegate ) {
        APIHandler().uploadObject( bucketName : name, fileRefId : fileRefId, filePath : nil, fileName : fileName, data: data, shouldCompress: shouldCompress, fileUploadDelegate: fileUploadDelegate )
    }
    
    private func getObjects( withParams : ZCatalystQuery.ObjectParams? = nil, completion : @escaping ( CatalystResult.DataURLResponse< [ ZCatalystObject ], ResponseInfo > ) -> Void )
    {
        APIHandler().getObjects( bucketName : name, queryParams: withParams, completion : completion )
    }
    
    private func getObject( objectKey : String, versionId : String? = nil, completion : @escaping ( Result< ZCatalystObject, ZCatalystError > ) -> Void )
    {
        APIHandler().getObject( bucketName : name, objectKey : objectKey, versionId : versionId, completion : completion )
    }
    
    private func deleteObjects( _ objects : [ ZCatalystObject ], completion : @escaping ( ZCatalystError? ) -> Void )
    {
        APIHandler().deleteObjects( bucketName : name, objects: objects, completion : completion  )
    }
    
    private func deletePath( _ path : String, completion : @escaping ( ZCatalystError? ) -> Void )
    {
        APIHandler().deletePath( path, bucketName : name, completion : completion )
    }
}
