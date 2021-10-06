//
//  Database.swift
//  Catalyst
//
//  Created by Giridhar on 29/05/19.
//

import Foundation



/// The Database type allows you to access the Zoho Catalyst Database
public struct ZCatalystDataStore
{
    //MARK: Initialization
    init()
    {
    }
    
    public func getTableInstance( id : Int64 ) -> ZCatalystTable
    {
        return ZCatalystTable( id : id )
    }
    
    public func getTableInstance( name : String ) -> ZCatalystTable
    {
        return ZCatalystTable( name : name )
    }
    
    public func getTables( completion : @escaping ( Result< [ ZCatalystTable ], ZCatalystError > ) -> Void )
    {
        APIHandler().getTables( completion : completion )
    }
    
    public func getTable( name : String, completion : @escaping ( Result< ZCatalystTable, ZCatalystError > ) -> Void )
    {
        APIHandler().getTable( name : name, completion : completion )
    }
    
    public func getTable( id : Int64, completion : @escaping ( Result< ZCatalystTable, ZCatalystError > ) -> Void )
    {
        APIHandler().getTable( name : String( id ), completion : completion )
    }
    
    public func execute( query : ZCatalystSelectQuery, completion: @escaping (Result<[ [ String : Any ] ], ZCatalystError>) -> Void)
    {
        APIHandler().executeZCQL( query : query.query, completion : completion )
    }
}
