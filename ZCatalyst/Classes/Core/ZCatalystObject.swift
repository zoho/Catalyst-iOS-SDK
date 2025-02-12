//
//  ZCatalystObject.swift
//  ZCatalyst
//
//  Created by Gowtham B R on 12/02/25.
//

import Foundation

public class ZCatalystObject : ZCatalystEntity
{
    public internal( set ) var bucketName : String = MockValue.string
    public internal( set ) var fileName : String
    public internal( set ) var size : Int64
    public internal( set ) var type : `Type`
    public internal( set ) var lastModifiedTime : String
    public internal( set ) var metaData : [ String : String ]
    public internal( set ) var contentType : String?
    public internal( set ) var versionId : String?
    
    enum CodingKeys : String, CodingKey
    {
        case fileName = "key"
        case size = "size"
        case objectType = "key_type"
        case contentType = "content_type"
        case versionId = "version_id"
        case lastModified = "last_modified"
        case metaData = "meta_data"
    }
    
    required public init( from decoder : Decoder ) throws
    {
        let container = try decoder.container( keyedBy : CodingKeys.self )
        self.fileName = try container.decode( String.self, forKey : .fileName )
        self.size = try container.decode( Int64.self, forKey : .size )
        self.type = try container.decodeIfPresent( `Type`.self, forKey: .objectType) ?? .file
        self.metaData = try container.decodeIfPresent( [ String : String ].self, forKey: .metaData) ?? [:]
        self.contentType = try container.decodeIfPresent( String.self, forKey: .contentType)
        self.versionId = try container.decodeIfPresent( String.self, forKey: .versionId)
        self.lastModifiedTime = try container.decode( String.self, forKey: .lastModified)
    }
    
    public enum `Type` : String, Decodable
    {
        case file = "file"
        case folder = "folder"
    }
    
    public func download(fromCache: Bool = false, completion : @escaping ( Result< URL, ZCatalystError > ) -> Void )
    {
        APIHandler().downloadObject( bucketName : bucketName, fileName : fileName, versionId: versionId, fromCache: fromCache, completion : completion )
    }
    
    public func download(fromCache: Bool = false, fileRefId : String, fileDownloadDelegate : ZCatalystFileDownloadDelegate )
    {
        APIHandler().downloadObject( bucketName : bucketName, fileName : fileName, fileRefId : fileRefId, versionId: versionId, fromCache: fromCache, fileDownloadDelegate: fileDownloadDelegate )
    }
    
    public func delete( completion : @escaping ( ZCatalystError? ) -> Void )
    {
        APIHandler().deleteObjects(bucketName: bucketName, objects: [ self ], completion: completion)
    }
    
}

