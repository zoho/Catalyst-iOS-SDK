//
//  User.swift
//  Catalyst
//
//  Created by Umashri R on 21/07/20.
//

public class ZCatalystUser : ZCatalystUserDelegate
{
    public internal( set ) var zaaId : Int64 = 0
    public internal( set ) var status : String = String()
    public internal( set ) var createdTime : String = String()
    public internal( set ) var modifiedTime : String = String()
    public internal( set ) var invitedTime : String = String()
    public internal( set ) var role : ZCatalystUserRole = ZCatalystUserRole()
    
    override internal init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container( keyedBy : CodingKeys.self )
        self.zaaId = try container.decode( Int64.self, forKey : .zaaId )
        self.status = try container.decode( String.self, forKey : .status )
        self.createdTime = try container.decode( String.self, forKey : .createdTime )
        self.modifiedTime = try container.decode( String.self, forKey : .modifiedTime )
        self.invitedTime = try container.decode( String.self, forKey : .invitedTime )
        self.role = try container.decode( ZCatalystUserRole.self, forKey : .role )
        try super.init( from : decoder )
    }
    
    var payload: Parameters{
        let userdict = ["first_name":self.firstName,
                        "last_name":self.lastName,
                        "email_id":self.email]
        
        return ["platform_type":"ios",
                "redirect_url": ZCatalystApp.shared.appConfig.redirectURLScheme,
                "zaid":ZCatalystApp.shared.appConfig.portalId,
                "user_details":userdict]
    }
    
    enum CodingKeys : String, CodingKey
    {
        case zaaId = "zaaid"
        case status = "status"
        case createdTime = "created_time"
        case modifiedTime = "modified_time"
        case invitedTime = "invited_time"
        case role = "role_details"
    }
}

public struct ZCatalystUserRole : Decodable
{
    public internal( set ) var id : Int64 = 0
    public internal( set ) var name : String = String()
    
    public enum CodingKeys : String, CodingKey
    {
        case id = "role_id"
        case name = "role_name"
    }
}
