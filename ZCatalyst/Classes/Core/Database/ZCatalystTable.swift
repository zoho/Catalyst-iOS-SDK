//
//  ZCTable.swift
//  Catalyst
//
//  Created by Umashri R on 14/07/20.
//
import Foundation

public class ZCatalystTable : ZCatalystEntity
{
    public internal( set ) var name : String = String()
    public internal( set ) var id : Int64 = 0
    public internal( set ) var modifiedTime : String = String()
    public internal( set ) var modifiedBy : ZCatalystUserDelegate = ZCatalystUserDelegate()
    
    init( id : Int64 )
    {
        self.id = id
    }
    
    init( name : String )
    {
        self.name = name
    }
    
    init()
    {
    }
    
    enum CodingKeys : String, CodingKey
    {
        case id = "table_id"
        case name = "table_name"
        case modifiedTime = "modified_time"
        case modifiedBy = "modified_by"
        case columns = "column_details"
    }
    
    public required init( from decoder : Decoder ) throws
    {
        let container = try decoder.container( keyedBy : CodingKeys.self )
        self.id = try container.decode( Int64.self, forKey : .id )
        self.name = try container.decode( String.self, forKey : .name )
        self.modifiedTime = try container.decode( String.self, forKey : .modifiedTime )
        self.modifiedBy = try container.decode( ZCatalystUserDelegate.self, forKey : .modifiedBy )
    }
    
    static func bulkInsert(rows: [ZCatalystRow]) -> Data?
    {
        var allData = [ [ String : Any? ] ]()
        for row in rows
        {
            row.upsertJSON.updateValue( row.id, forKey : ZCatalystRow.CodingKeys.id.rawValue )
            allData.append( row.upsertJSON )
        }
        guard let data = try? JSONSerialization.data(withJSONObject: allData, options: []) else {return nil}
        return data
    }
    
    public func newRow() -> ZCatalystRow
    {
        if self.id != 0
        {
            return ZCatalystRow( tableIdentifier : String( self.id ) )
        }
        else
        {
            return ZCatalystRow( tableIdentifier : self.name )
        }
    }
    
    public func getColumns( completion : @escaping ( Result< [ ZCatalystColumn ], ZCatalystError > ) -> Void )
    {
        if self.id != 0
        {
            APIHandler().getColumns( table : String( self.id ), completion : completion )
        }
        else
        {
            APIHandler().getColumns( table : name, completion : completion )
        }
    }
    
    public func getColumn( id : Int64, completion : @escaping ( Result< ZCatalystColumn, ZCatalystError > ) -> Void )
    {
        if self.id != 0
        {
            APIHandler().getColumn( table : String( self.id ), column : id, completion : completion )
        }
        else
        {
            APIHandler().getColumn( table : self.name, column : id, completion : completion )
        }
    }
    
    public func create(_ rows: [ ZCatalystRow ], completion: @escaping(Result<[ZCatalystRow], ZCatalystError>) -> Void)
    {
        if self.id != 0
        {
            APIHandler().create( rows, tableId : String( self.id ), completion : completion )
        }
        else
        {
            APIHandler().create( rows, tableId : self.name, completion : completion )
        }
    }
    
    public func update(_ rows: [ ZCatalystRow ], completion: @escaping(Result<[ZCatalystRow], ZCatalystError>) -> Void)
    {
        if self.id != 0
        {
            APIHandler().update( rows, tableId : String( self.id ), completion : completion )
        }
        else
        {
            APIHandler().update( rows, tableId : self.name, completion : completion )
        }
    }
    
    //MARK: Public Methods to access database
    /// Fetches all rows from a specified table from the catalyst database
    /// - Parameter table: Name of the table from when rows have to be fetched
    /// - Parameter completion: Asyncronously returns the fetched rows or a Database Error
    public func getRows(completion: @escaping (Result<[ZCatalystRow], ZCatalystError>) -> Void)
    {
        if self.id != 0
        {
            APIHandler().fetchRows( table : String( self.id ), completion : completion )
        }
        else
        {
            APIHandler().fetchRows( table : self.name, completion : completion )
        }
    }
    
    public func getRow(id : Int64, completion: @escaping (Result<ZCatalystRow, ZCatalystError>) -> Void)
    {
        if self.id != 0
        {
            APIHandler().fetchRow( table : String( self.id ), row : id, completion : completion )
        }
        else
        {
            APIHandler().fetchRow( table : self.name, row : id, completion : completion )
        }
    }
    
    public func deleteRow( id : Int64, completion : @escaping( ZCatalystError? ) -> Void )
    {
        if self.id != 0
        {
            APIHandler().deleteRow( id : id, tableId : String( self.id ), completion : completion )
        }
        else
        {
            APIHandler().deleteRow( id : id, tableId : self.name, completion : completion )
        }
    }
}

