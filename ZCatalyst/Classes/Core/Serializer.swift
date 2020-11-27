//
//  Serializer.swift
//  Catalyst
//
//  Created by Giridhar on 23/05/19.
//

import Foundation

struct Serializer
{
    static func parse<T:Codable>(data: Data) -> Result<T,ZCatalystError>
    {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String:Any]
            
            guard let status = json?["status"] as? String else
            {
                return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
            }
            if status == "success"
            {
                guard let body = json?["data"] else
                {
                    return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
                }
                
                let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [])
                
                guard let jData = jsonData else
                {
                    return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
                }
                
                //--------------------------Code repeat - Use function below till here
                
                let decoder = JSONDecoder()
                do
                {
                    let object = try decoder.decode(T.self, from: jData)
                    return Result.success(object)
                }
                catch
                {
                    return .error( typeCastToZCatalystError( error ) )
                }
            }
        }
        catch {
            return .error( typeCastToZCatalystError( error ) )
        }
        
        return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
    }
    
    static func precheckJSON(data: Data) -> Result<Data,ZCatalystError>
    {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String:Any]
            
            guard let status = json?["status"] as? String else
            {
                return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
            }
            if status == "success"
            {
                guard let body = json?["data"] else
                {
                    return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
                }
                
                let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [])
                
                guard let jData = jsonData else
                {
                    return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
                }
                return Result.success(jData)
        
            }
        }
        catch {
            return .error( typeCastToZCatalystError( error ) )
        }
        return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
    }
    
    
    static func precheckJSON(data: Data) -> Result<Any,ZCatalystError>
    {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String:Any]
            
            guard let status = json?["status"] as? String else
            {
                return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
            }
            if status == "success"
            {
                guard let body = json?["data"] else
                {
                    return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
                }
                
            
                return Result.success(body)
            }
            else
            {
                if status == "failure"
                {
                    guard let error = json?["data"] as? [ String : Any ], let code = error[ "error_code" ] as? String, let message = error[ "message" ] as? String else {
                        return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
                    }
                    
                    return .error( .processingError( code : code, message : message, details : nil ) )
                }
            }
        }
        catch {
            return .error( typeCastToZCatalystError( error ) )
        }
        return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
    }
    
    static func parse<T:ZCatalystResponse>(data: Data) -> Result<T,ZCatalystError>
    {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String:Any]
            
            guard let status = json?["status"] as? String else
            {
                return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
            }
            if status == "success"
            {
                guard let body = json?["data"] as? [String: Any] else
                {
                    return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
                }
            //--------------------------Code repeat - Use function above till here
                
                let response = T.init(output: body)
                
                return Result.success(response)
            }
            else
            {
                if status == "failure"
                {
                    guard let error = json?["data"] as? [ String : Any ], let code = error[ "error_code" ] as? String, let message = error[ "message" ] as? String else {
                        return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
                    }
                    
                    return .error( .processingError( code : code, message : message, details : nil ) )
                }
            }
        }
        catch{
            return .error( typeCastToZCatalystError( error ) )
        }
           return .error( .processingError( code : ErrorCode.jsonException, message : ErrorMessage.responseParseError, details : nil ) )
    }
}

