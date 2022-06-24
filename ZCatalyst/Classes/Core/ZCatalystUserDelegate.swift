//
//  UserDelegate.swift
//  Catalyst
//
//  Created by Umashri R on 21/07/20.
//

public class ZCatalystUserDelegate : ZCatalystEntity
{
    public internal( set ) var id : Int64 = 0
    public var email : String = String()
    public var firstName : String?
    public var lastName : String = String()
    public internal( set ) var zuId : Int64 = 0
    public internal( set ) var isConfirmed : Bool = false
    
    init() {
    }
    
    public required init( from decoder : Decoder ) throws
    {
        let container = try decoder.container( keyedBy : CodingKeys.self )
        self.id = try container.decode( Int64.self, forKey : .id )
        self.email = try container.decode( String.self, forKey : .email )
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decode( String.self, forKey : .lastName )
        self.zuId = try container.decode( Int64.self, forKey : .zuId )
        self.isConfirmed = try container.decode( Bool.self, forKey : .isConfirmed )
    }
    
    enum CodingKeys : String, CodingKey
    {
        case id = "user_id"
        case email = "email_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case zuId = "zuid"
        case isConfirmed = "is_confirmed"
    }
}
