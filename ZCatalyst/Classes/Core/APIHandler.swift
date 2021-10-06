//
//  APIHandler.swift
//  Catalyst
//
//  Created by Umashri R on 13/08/20.
//

import Foundation

protocol ZCatalystEntity : Decodable
{
    
}

struct APIHandler
{
    var networkClient: NetworkRequestable = Parker()
    
    func download( file fileId : Int64, in folderId : Int64, fileRefId : String, fileDownloadDelegate : ZCatalystFileDownloadDelegate )
    {
        let api = FileStorageAPI.downloadFile( folderId : String( folderId ), fileId : String( fileId ) )
        networkClient.download( url : api, fileRefId : fileRefId, fileDownloadDelegate : fileDownloadDelegate )
    }
    
    func download( file fileId : Int64, in folderId : Int64, completion : @escaping (Result< ( Data, URL ),ZCatalystError>) -> Void )
    {
        let api = FileStorageAPI.downloadFile( folderId : String( folderId ), fileId : String( fileId ) )
        networkClient.download( url : api) { ( result ) in
            switch result
            {
            case .success( let url ) :
                do
                {
                    let data = try Data( contentsOf : url )
                    completion( .success( ( data, url ) ) )
                }
                catch{
                    completion( .error( typeCastToZCatalystError( error ) ) )
                    ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                }
            case .error( let error ) :
                completion( .error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func getFolders( completion : @escaping ( Result< [ ZCatalystFolder ], ZCatalystError > ) -> Void )
    {
        let api = FolderAPI.fetchAll
        networkClient.request( api, session : URLSession.shared ) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< [ ZCatalystFolder ], ZCatalystError > = self.parse( data : data )
                completion( jsonResult )
            case .error( let error ):
                completion( .error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func getFolder( folderId : Int64, completion : @escaping ( Result< ZCatalystFolder, ZCatalystError > ) -> Void )
    {
        let api = FolderAPI.fetch( folder : String( folderId ) )
        networkClient.request( api, session : URLSession.shared ) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< ZCatalystFolder, ZCatalystError > = self.parse( data : data )
                completion( jsonResult )
            case .error( let error ):
                completion( .error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func getFiles( folderId : Int64, completion : @escaping ( Result< [ ZCatalystFile ], ZCatalystError > ) -> Void )
    {
        let api = FileStorageAPI.fetchAll( folderId : folderId )
        networkClient.request( api, session : URLSession.shared ) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< [ ZCatalystFile ], ZCatalystError > = self.parse( data : data )
                completion( jsonResult )
            case .error( let error ):
                completion( .error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func getFile( folderId : Int64, fileId : Int64, completion : @escaping ( Result< ZCatalystFile, ZCatalystError > ) -> Void )
    {
        let api = FileStorageAPI.fetch( folderId : String( folderId ), fileId : String( fileId ) )
        networkClient.request( api, session : URLSession.shared ) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< ZCatalystFile, ZCatalystError > = self.parse( data : data )
                completion( jsonResult )
            case .error( let error ):
                completion( .error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func upload( filePath : URL, folder : Int64, completion: @escaping (Result<ZCatalystFile, ZCatalystError>) -> Void )
    {
        let api = FileStorageAPI.uploadFile(folderId: String("\(folder)"))
        networkClient.upload( filePath : filePath, fileName : nil, fileData : nil, url : api) { (result) in
            switch result
            {
            case .success(let data):
                let jsonResult : Result< ZCatalystFile, ZCatalystError > = self.parse( data : data )
                completion( jsonResult )
            case .error(let routerError):
                completion( .error( typeCastToZCatalystError( routerError ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( routerError )" )
            }
        }
    }
    
    func upload( fileName : String, fileData : Data, folder : Int64, completion: @escaping (Result<ZCatalystFile, ZCatalystError>) -> Void )
    {
        let api = FileStorageAPI.uploadFile(folderId: String("\(folder)"))
        networkClient.upload( filePath : nil, fileName : fileName, fileData : fileData, url : api) { (result) in
            switch result
            {
            case .success(let data):
                let jsonResult : Result< ZCatalystFile, ZCatalystError > = self.parse( data : data )
                completion( jsonResult )
            case .error(let routerError):
                completion( .error( typeCastToZCatalystError( routerError ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( routerError )" )
            }
        }
    }
    
    func upload( fileRefId : String, filePath : URL, folder : Int64, fileUploadDelegate : ZCatalystFileUploadDelegate )
    {
        let api = FileStorageAPI.uploadFile(folderId: String("\(folder)"))
        networkClient.upload( fileRefId : fileRefId, filePath : filePath, fileName : nil, fileData : nil, url : api, fileUploadDelegate : fileUploadDelegate)
    }
    
    func upload( fileRefId : String, fileName : String, fileData : Data, folder : Int64, fileUploadDelegate : ZCatalystFileUploadDelegate )
    {
        let api = FileStorageAPI.uploadFile(folderId: String("\(folder)"))
        networkClient.upload( fileRefId : fileRefId, filePath : nil, fileName : fileName, fileData : fileData, url : api, fileUploadDelegate : fileUploadDelegate )
    }
    
    func executeFunction( name : String, parameters params : [ String : Any ]?, body : [ String : Any ]?, requestMethod : HTTPMethod, completion : @escaping( Result< String, ZCatalystError > ) -> Void )
    {
        let api = FunctionsAPI.execute( id : name, requestMethod : requestMethod, parameters : params, body : body )
        networkClient.request(api, session: URLSession.shared) { (result) in
            switch result
            {
            case .success(let data):
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String:Any]
                    guard let jsonValue = json else
                    {
                        completion( .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) ) )
                        return
                    }
                    if jsonValue[ "status" ] as? String == "failure"
                    {
                        let result : Result< ZCatalystFunctionResult, ZCatalystError > = Serializer.parse( data : data )
                        switch result {
                        case .success( let funcResult ) :
                            guard let output = funcResult.output[ "output" ] as? String else
                            {
                                ZCatalystLogger.logError( message : "Error Occurred : \( ErrorCode.jsonException ) : \( ErrorMessage.responseParseError ), Details : -" )
                                completion( .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) ) )
                                return
                            }
                            completion( .success( output ) )
                        case .error( let error ) :
                            completion( .error( error ) )
                            ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                        }
                    }
                    else
                    {
                        guard let output = jsonValue[ "output" ] as? String else
                        {
                            ZCatalystLogger.logError( message : "Error Occurred : \( ErrorCode.jsonException ) : \( ErrorMessage.responseParseError ), Details : -" )
                            completion( .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) ) )
                            return
                        }
                        completion( .success( output ) )
                    }
                }
                catch
                {
                    completion( .error( typeCastToZCatalystError( error ) ) )
                    ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                }
            case .error(let error):
                completion( .error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func getCurrentUser( completion : @escaping ( Result< ZCatalystUser,ZCatalystError > ) -> Void )
    {
        let api = UserAPI.getCurrentUser
        networkClient.request(api, session : URLSession.shared ) { (result) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< ZCatalystUser, ZCatalystError > = self.parse( data : data )
                completion( jsonResult )
            case .error( let error ):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func signUp(user: ZCatalystUser, completion: @escaping (Result<( ZCatalystUser, Int64 ), ZCatalystError >) -> Void)
    {
        let api = AuthAPI.signup(user: user)
        networkClient.request(api, session : URLSession.shared) { (result) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< ZCatalystUser, ZCatalystError > = self.parse( data : data )
                switch jsonResult
                {
                case .success( let user ) :
                    completion( .success( ( user, user.zaaId ) ) )
                case .error( let error ) :
                    completion( .error( error ) )
                    ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                }
            case .error( let error ):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func createRow(_ row : ZCatalystRow, tableId : String, completion : @escaping( Result< ZCatalystRow, ZCatalystError > ) -> Void )
    {
        guard let payload = row.payloadData else {
            ZCatalystLogger.logError( message : "Error Occurred : \( ErrorCode.invalidData ) : \( ErrorMessage.invalidDataMsg ), Details : -" )
            completion( .error( .processingError( code : ErrorCode.invalidData, message : ErrorMessage.invalidDataMsg, details : nil ) ) )
            return
        }
        let api = RowAPI.insert( json : payload, table : tableId )
        networkClient.request( api, session : URLSession.shared) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< [ ZCatalystRow ], ZCatalystError > = self.parse( data : data )
                switch jsonResult
                {
                case .success( let rows ) :
                    rows[ 0 ].tableIdentifier = tableId
                    completion( .success( rows[ 0 ] ) )
                case .error( let error ) :
                    completion( .error( error ) )
                    ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                }
            case .error( let error ):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func updateRow(_ row : ZCatalystRow, tableId : String, completion: @escaping(Result<ZCatalystRow, ZCatalystError>) -> Void)
    {
        guard let payload = row.payloadData else {
            ZCatalystLogger.logError( message : "Error Occurred : \( ErrorCode.invalidData ) : \( ErrorMessage.invalidDataMsg ), Details : -" )
            completion( .error( .processingError( code : ErrorCode.invalidData, message : ErrorMessage.invalidDataMsg, details : nil ) ) )
            return
        }
        let api = RowAPI.update( json : payload, table : tableId )
        networkClient.request( api, session : URLSession.shared) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< [ ZCatalystRow ], ZCatalystError > = self.parse( data : data )
                switch jsonResult
                {
                case .success( let rows ) :
                    rows[ 0 ].tableIdentifier = tableId
                    completion( .success( rows[ 0 ] ) )
                case .error( let error ) :
                    completion( .error( error ) )
                    ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                }
            case .error( let error ):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func deleteRow( id : Int64, tableId : String, completion: @escaping( ZCatalystError? ) -> Void)
    {
        let api = RowAPI.delete(row: id, table: tableId)
        networkClient.request( api, session : URLSession.shared) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< ZCatalystRow, ZCatalystError > = self.parse( data : data )
                switch jsonResult
                {
                case .success( _ ) :
                    completion( nil )
                case .error( let error ) :
                    completion( error )
                    ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                }
            case .error( let error ):
                completion( typeCastToZCatalystError( error ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func search( searchOptions : ZCatalystSearchOptions, _ completion : @escaping( Result< [ String : Any ], ZCatalystError > )-> Void )
    {
        let api = searchOptions.buildAPI()
        networkClient.request(api, session: URLSession.shared) { (result) in
            switch result
            {
            case .success(let data):
                let result: Result<ZCatalystSearchResponse, ZCatalystError> = Serializer.parse(data: data)
                switch result
                {
                case .success( let response ) :
                    completion( .success( response.output ) )
                case .error( let error ) :
                    completion( .error( error ) )
                    ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                }
            case .error(let error):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func getTables( completion : @escaping ( Result< [ ZCatalystTable ], ZCatalystError > ) -> Void )
    {
        let api = TableAPI.fetchAll
        networkClient.request( api, session : URLSession.shared ) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< [ ZCatalystTable ], ZCatalystError > = self.parse( data : data )
                completion( jsonResult )
            case .error( let error ):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func getTable( name : String, completion : @escaping ( Result< ZCatalystTable, ZCatalystError > ) -> Void )
    {
        let api = TableAPI.fetch( table : name )
        networkClient.request( api, session : URLSession.shared ) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< ZCatalystTable, ZCatalystError > = self.parse( data : data )
                completion( jsonResult )
            case .error( let error ):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func getColumns( table : String, completion : @escaping ( Result< [ ZCatalystColumn ], ZCatalystError > ) -> Void )
    {
        let api = ColumAPI.fetchAll( table : table )
        networkClient.request( api, session : URLSession.shared ) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< [ ZCatalystColumn ], ZCatalystError > = self.parse( data : data )
                completion( jsonResult )
            case .error( let error ):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func getColumn( table : String, column : Int64, completion : @escaping ( Result< ZCatalystColumn, ZCatalystError > ) -> Void )
    {
        let api = ColumAPI.fetch( table : table, column : column )
        networkClient.request( api, session : URLSession.shared ) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< ZCatalystColumn, ZCatalystError > = self.parse( data : data )
                completion( jsonResult )
            case .error( let error ):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func create(_ rows: [ ZCatalystRow ], tableId : String, completion: @escaping(Result<[ZCatalystRow], ZCatalystError>) -> Void)
    {
        guard let payload = ZCatalystTable.bulkInsert(rows: rows) else {
            completion( .error( .processingError( code : ErrorCode.invalidData, message : ErrorMessage.invalidDataMsg, details : nil ) ) )
            return
        }
        let api = RowAPI.insert( json : payload, table : tableId )
        networkClient.request( api, session : URLSession.shared) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< [ ZCatalystRow ], ZCatalystError > = self.parse( data : data )
                switch jsonResult
                {
                case .success( let rows ) :
                    for row in rows
                    {
                        row.tableIdentifier = tableId
                    }
                    completion( .success( rows ) )
                case .error( let error ) :
                    completion( .error( error ) )
                    ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                }
            case .error( let error ):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func update(_ rows: [ ZCatalystRow ], tableId : String, completion: @escaping(Result<[ZCatalystRow], ZCatalystError>) -> Void)
    {
        guard let payload = ZCatalystTable.bulkInsert(rows: rows) else {
            ZCatalystLogger.logError( message : "Error Occurred : \( ErrorCode.invalidData ) : \( ErrorMessage.invalidDataMsg ), Details : -" )
            completion( .error( .processingError( code : ErrorCode.invalidData, message : ErrorMessage.invalidDataMsg, details : nil ) ) )
            return
        }
        let api = RowAPI.update( json : payload, table : tableId )
        networkClient.request( api, session : URLSession.shared) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< [ ZCatalystRow ], ZCatalystError > = self.parse( data : data )
                switch jsonResult
                {
                case .success( let rows ) :
                    for row in rows
                    {
                        row.tableIdentifier = tableId
                    }
                    completion( .success( rows ) )
                case .error( let error ) :
                    completion( .error( error ) )
                    ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                }
            case .error( let error ):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func fetchRows(table : String, completion: @escaping (Result<[ZCatalystRow], ZCatalystError>) -> Void)
    {
        let api = RowAPI.fetchAll(table: table)
        networkClient.request( api, session : URLSession.shared) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< [ ZCatalystRow ], ZCatalystError > = self.parse( data : data )
                switch jsonResult
                {
                case .success( let rows ) :
                    for row in rows
                    {
                        row.tableIdentifier = table
                    }
                    completion( .success( rows ) )
                case .error( let error ) :
                    completion( .error( error ) )
                    ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                }
            case .error( let error ):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func fetchRow(table : String, row : Int64, completion: @escaping (Result<ZCatalystRow, ZCatalystError>) -> Void)
    {
        let api = RowAPI.fetch(table: table, row : row)
        networkClient.request( api, session : URLSession.shared) { ( result ) in
            switch result
            {
            case .success( let data ) :
                let jsonResult : Result< ZCatalystRow, ZCatalystError > = self.parse( data : data )
                switch jsonResult
                {
                case .success( let row ) :
                    row.tableIdentifier = table
                    completion( .success( row ) )
                case .error( let error ) :
                    completion( .error( error ) )
                    ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                }
            case .error( let error ):
                completion( Result.error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func executeZCQL(query: String, completion: @escaping (Result<[ [ String : Any ] ], ZCatalystError>) -> Void)
    {
        
        let api = QueryAPI.execute(query: query)
        networkClient.request(api, session: URLSession.shared) { (result) in
            switch result
            {
            case .success(let data):
                let result: Result<Any, ZCatalystError> = Serializer.precheckJSON(data: data)
                switch result
                {
                case .success(let obj):
                    guard let json = obj as? Array< Dictionary< String, Any > > else {
                        ZCatalystLogger.logError( message : "Error Occurred : \( ErrorCode.jsonException ) : \( ErrorMessage.responseParseError ), Details : -" )
                        completion( .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) ) )
                        return
                    }
                    completion( .success( json ) )
                case .error(let error):
                    completion( .error( typeCastToZCatalystError( error ) ) )
                    ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                }
            case .error(let error):
                completion( .error( typeCastToZCatalystError( error ) ) )
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            }
        }
    }
    
    func registerNotification( token : String, appID : String, testDevice : Bool )
    {
        let payload = pushNotificationPayload(token: token, testDevice: testDevice)
        let api = PushNotificationAPI.register(paramets: payload, appID: appID)
        networkClient.request(api, session: URLSession.shared) { (result) in
            self.handlePushResult(result) { (success) in
                if success
                {
                    UserDefaults.standard.set(token, forKey: Constants.apnsTokenKey.string)
                }
            }
        }
    }
    
    func deregisterNotification( token : String, appID : String, testDevice : Bool )
    {
        let payload = pushNotificationPayload(token: token,testDevice: testDevice)
        let api = PushNotificationAPI.deregister(parameters: payload, appID: appID)
        networkClient.request(api, session: URLSession.shared) { (result) in
            self.handlePushResult(result){ success in
                if success
                {
                    UserDefaults.standard.removeObject(forKey: Constants.apnsTokenKey.string)
                    UserDefaults.standard.removeObject(forKey: Constants.apnsInstallationKey.string)
                }
                
            }
        }
    }
    
    fileprivate func pushNotificationPayload(token: String, testDevice isTestDevice: Bool) -> [String: Any]
    {
        let os_version = UIDevice.current.systemVersion
        let bundleID = Bundle.main.bundleIdentifier
        var payload:[String: Any] {
            return ["device_token":token,
                    "os_version":os_version,
                    "app_bundle_id":bundleID ?? "",
                    "test_device":isTestDevice]
        }
        return payload
    }
    
    fileprivate func handlePushResult(_ result: Result<Data, ZCatalystError>, completion: (Bool) -> ()) {
        switch result
        {
        case .success(let data):
            let jsonResult:Result<Any,ZCatalystError> = Serializer.precheckJSON(data: data)
            switch jsonResult
            {
            case .success(let json):
                guard let jsonObj = json as? [String: Any],
                    let installationId = jsonObj["installation_id"] as? String else
                {
                    completion(false)
                    return
                }
                
                UserDefaults.standard.set(installationId, forKey: Constants.apnsInstallationKey.string)
                completion(true)
            case .error(_):
                completion(false)
            }
        case .error(_):
            completion(false)
        }
    }
    
    func parse< T : ZCatalystEntity >( data : Data ) -> Result< T, ZCatalystError >
    {
        let result : Result< Any, ZCatalystError > = Serializer.precheckJSON( data : data )
        switch result
        {
        case .success( let json ) :
            do
            {
                guard let json = json as? [ String : Any ] else
                {
                    ZCatalystLogger.logError( message : "Error Occurred : \( ErrorCode.jsonException ) : \( ErrorMessage.responseParseError ), Details : -" )
                    return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
                }
                if T.self == ZCatalystUser.self
                {
                    if let userDetails = json[ "user_details" ] as? [ String : Any ]
                    {
                        let jsonData = try JSONSerialization.data( withJSONObject: userDetails, options : [] )
                        let decoder = JSONDecoder()
                        let obj = try decoder.decode( T.self, from : jsonData )
                        return .success( obj )
                    }
                    let jsonData = try JSONSerialization.data( withJSONObject: json, options : [] )
                    let decoder = JSONDecoder()
                    let obj = try decoder.decode( T.self, from : jsonData )
                    return .success( obj )
                }
                let jsonData = try JSONSerialization.data( withJSONObject: json, options : [] )
                let decoder = JSONDecoder()
                let obj = try decoder.decode( T.self, from : jsonData )
                if let row = obj as? ZCatalystRow
                {
                    row.data = json
                }
                return .success( obj )
            }
            catch
            {
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                return .error( typeCastToZCatalystError( error ) )
            }
        case .error( let error ) :
            ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            return .error( typeCastToZCatalystError( error ) )
        }
    }
    
    fileprivate func parse< T : ZCatalystEntity >( data : Data ) -> Result< [ T ], ZCatalystError >
    {
        let result : Result< Any, ZCatalystError > = Serializer.precheckJSON( data : data )
        switch result
        {
        case .success( let json ) :
            do
            {
                guard let jsonArr = json as? [ [ String : Any ] ] else
                {
                    ZCatalystLogger.logError( message : "Error Occurred : \( ErrorCode.jsonException ) : \( ErrorMessage.responseParseError ), Details : -" )
                    return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
                }
                let jsonData = try JSONSerialization.data( withJSONObject: jsonArr, options : [] )
                let decoder = JSONDecoder()
                let obj = try decoder.decode( [ T ].self, from : jsonData )
                if let rows = obj as? [ ZCatalystRow ]
                {
                    for index in 0..<rows.count
                    {
                        rows[ index ].data = jsonArr[ index ]
                    }
                }
                return .success( obj )
            }
            catch
            {
                ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
                return .error( typeCastToZCatalystError( error ) )
            }
        case .error( let error ) :
            ZCatalystLogger.logError( message : "Error Occurred : \( error )" )
            return .error( typeCastToZCatalystError( error ) )
        }
    }
}

extension FileStorageAPI: APIEndPointConvertable
{
    var baseURL: URL {
        return  ServerURL.url()
    }
    
    var path: String {
        switch self
        {
        case .fetchAll( let folderId ) :
            return "folder/\( folderId )/file"
        case .fetch( let folderId, let fileId ) :
            return "folder/\( folderId )/file/\( fileId )"
        case .uploadFile(let folderID):
            return "folder/\(folderID)/file"
        case .downloadFile(let folderId, let fileId):
            return "/folder/\(folderId)/file/\(fileId)/download"
        case .deleteFile:
            return ""
        }
    }
    
    var httpMethod: HTTPMethod
    {
        switch self
        {
        case .fetchAll( _ ) :
            return .get
        case .fetch( _, _ ) :
            return .get
        case .uploadFile(_):
            return .post
        case .downloadFile(_,_):
            return .get
        case .deleteFile:
            return .delete
        }
    }
    
    var OAuthEnabled: OAuthEnabled {
            return .enabled(helper: OAuth())
    }
    
    var payload: Payload? {
        return nil
    }
    
    var headers: HTTPHeaders?
    {
        return ServerURL.portalHeader()
    }
}

extension FolderAPI : APIEndPointConvertable
{
    var baseURL : URL {
        return ServerURL.url()
    }
    
    var path : String {
        switch self
        {
        case .fetch( let folder ) :
            return "folder/\( folder )"
        case .fetchAll :
            return "folder"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self
        {
            case .fetch( _ ), .fetchAll :
                return HTTPMethod.get
        }
    }
    
    var OAuthEnabled: OAuthEnabled {
        return .enabled( helper : OAuth() )
    }
    
    var payload: Payload? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        return ServerURL.portalHeader()
    }
}


extension FunctionsAPI: APIEndPointConvertable
{
    var baseURL: URL {
        return ServerURL.url()
    }
    
    var path: String {
        switch self
        {
        case .execute( let id, _, _, _ ) :
            return "function/\(id)/execute"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self
        {
        case .execute( _, let requestMethod, _, _ ) :
            return requestMethod
        }
    }
    
    var OAuthEnabled: OAuthEnabled {
        return .enabled(helper: OAuth())
    }
    
    var payload: Payload? {
        switch self
        {
        case .execute( _ , _, let params, let body):
            return Payload(bodyParameters: body, urlParameters: params, headers: nil, bodyData: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return ServerURL.portalHeader()
        
    }
}

extension PushNotificationAPI: APIEndPointConvertable
{
    var baseURL: URL {
        return ServerURL.url()
    }
    
    var path: String {
        switch self
        {
        case .deregister(_,let appID):
            return "/push-notification/\(appID)/unregister" //TODO: Documentation says appID, not sure what it is. So have put app.name for now.
        case .register(_,let appID):
            return "/push-notification/\(appID)/register"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var OAuthEnabled: OAuthEnabled {
        return .enabled(helper: OAuth())
    }
    
    var payload: Payload? {
        switch self {
        case .deregister(let params,_),  .register(let params,_):
            return Payload(bodyParameters: params, urlParameters: nil, headers: nil, bodyData:  nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return ServerURL.portalHeader()
    }
}

extension RowAPI: APIEndPointConvertable
{
    var baseURL: URL {
        return ServerURL.url()
    }
    
    var path: String {
        switch self {
        case .fetchAll(let table), .update( _ , let table), .insert(_,let table):
            return "/table/\(table)/row"
        case .delete(let row, let table), .fetch(let table, let row):
            return "/table/\(table)/row/\(row)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self{
        case .fetchAll(_), .fetch(_, _):
            return .get
        case .update(_, _):
            return .put
        case .delete(_,_):
            return .delete
        case .insert(_,_):
            return .post
        }
    }
    
    var OAuthEnabled: OAuthEnabled {
         return .enabled(helper: OAuth())
    }
    
    var payload: Payload? {
        switch self
        {
            
        case .fetchAll(_), .fetch(_, _), .delete(_,_):
            return nil
        case .update(let jsonData, _), .insert(let jsonData, _):
            return Payload(bodyParameters: nil, urlParameters: nil, headers: nil, bodyData: jsonData)
        }
    }
    
    var headers: HTTPHeaders? {
        return ServerURL.portalHeader()
    }
}

extension SearchAPI: APIEndPointConvertable
{
    var baseURL: URL {
        return ServerURL.url()
    }
    
    var path: String
    {
        return "search"
    }
    
    var httpMethod: HTTPMethod
    {
        return .post
    }
    
    var OAuthEnabled: OAuthEnabled
    {
        return .enabled(helper: OAuth())
    }
    
    var payload: Payload? {
        return PayloadFactory.generateSearch(api: self)
    }
    
    var headers: HTTPHeaders?
    {
        return ServerURL.portalHeader()
    }
}

extension TableAPI : APIEndPointConvertable
{
    var baseURL : URL {
        return ServerURL.url()
    }
    
    var path : String {
        switch self
        {
        case .fetch( let table ) :
            return "table/\( table )"
        case .fetchAll :
            return "table"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self
        {
            case .fetch( _ ), .fetchAll :
                return HTTPMethod.get
        }
    }
    
    var OAuthEnabled: OAuthEnabled {
        return .enabled( helper : OAuth() )
    }
    
    var payload: Payload? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        return ServerURL.portalHeader()
    }
}

extension ColumAPI : APIEndPointConvertable
{
    var baseURL: URL {
        return ServerURL.url()
    }
    
    var path: String {
        switch self
        {
        case .fetch( let table, let column ) :
            return "table/\( table )/column/\( column )"
        case .fetchAll( let table ) :
            return "table/\( table )/column"
        }
    }
    
    var httpMethod: HTTPMethod {
        return HTTPMethod.get
    }
    
    var OAuthEnabled: OAuthEnabled {
        return .enabled( helper : OAuth() )
    }
    
    var payload: Payload? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        return ServerURL.portalHeader()
    }
}

extension QueryAPI: APIEndPointConvertable
{
    var baseURL: URL {
        return ServerURL.url()
    }
    
    var path: String {
        return "/query"
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var OAuthEnabled: OAuthEnabled {
        return .enabled(helper: OAuth())
    }
    
    var payload: Payload? {
        switch self{
        case .execute(let query):
            return Payload(bodyParameters: ["query":query], urlParameters: nil, headers: nil, bodyData: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return ServerURL.portalHeader()
    }
}

extension AuthAPI: APIEndPointConvertable
{
    var baseURL: URL {
        return ServerURL.url()
    }
    
    var path: String {
        return "/project-user/signup"
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var OAuthEnabled: OAuthEnabled {
        return .disabled
    }
    
    var payload: Payload? {
        switch self{
        case .signup(let user):
            return Payload(bodyParameters: user.payload, urlParameters: nil, headers: nil, bodyData: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return ServerURL.portalHeader()
    }
    
    
}

extension UserAPI : APIEndPointConvertable
{
    var baseURL: URL {
        return ServerURL.url()
    }
    
    var path: String {
        return "/project-user/current"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var OAuthEnabled: OAuthEnabled {
        return .enabled(helper: OAuth())
    }
    
    var payload: Payload? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        return ServerURL.portalHeader()
    }
}
