//
//  ConfigStore.swift
//  JobsAdmin
//
//  Created by Giridhar on 09/05/19.
//  Copyright © 2019 Giridhar. All rights reserved.
//

import Foundation

public struct ZCatalystAppConfiguration : Decodable
{
    public internal( set ) var clientId : String
    public internal( set ) var clientSecret : String
    public internal( set ) var accountsURL : String = "https://accounts.zohoportal.com"
    public internal( set ) var portalId : String
    public var oAuthScopes : Array< String > = ["ZOHOCLOUD.functionapi.ALL","ZOHOCLOUD.serviceorg.ALL","ZOHOCLOUD.clientportal.ALL","ZOHOCATALYST.tables.rows.ALL","ZOHOCATALYST.queue.data.READ","ZOHOCATALYST.cache.READ","ZOHOCATALYST.queue.data.CREATE","ZOHOCATALYST.queue.READ","ZOHOCATALYST.tables.READ","ZOHOCATALYST.cache.CREATE","ZOHOCATALYST.tables.columns.READ","ZOHOCATALYST.files.READ","ZOHOCATALYST.files.CREATE","ZOHOCATALYST.projects.users.READ","ZOHOCATALYST.cache.DELETE","ZOHOCATALYST.folders.ALL","ZOHOCATALYST.zcql.CREATE","ZOHOCATALYST.graphql.READ","ZOHOCATALYST.email.CREATE","ZOHOCATALYST.segments.READ","ZOHOCATALYST.cron.ALL","ZOHOCATALYST.search.READ","ZOHOCATALYST.functions.execute","ZOHOCATALYST.functions.READ","ZOHOCATALYST.mlkit.READ","ZOHOCATALYST.folders.ALL","ZOHOCATALYST.notifications.web","ZOHOCATALYST.notifications.mobile","ZOHOCATALYST.functions.CREATE","ZOHOCATALYST.zia.automl.model.ALL","ZOHOCATALYST.zia.automl.model.predict","ZOHOCATALYST.zia.automl.dataset.CREATE","ZOHOCATALYST.zia.automl.dataset.READ","ZOHOCATALYST.zia.automl.dataset.UPDATE","ZOHOCATALYST.zia.timeseries.ALL","ZOHOCATALYST.zia.timeseries.analysis.READ","ZOHOCATALYST.zia.barcodescanning.READ","ZOHOCATALYST.circuits.execute","ZOHOCATALYST.circuits.execution.READ","ZOHOCATALYST.circuits.execution.DELETE"]
    public internal( set ) var redirectURLScheme : String
    var apiBaseURL : String = "https://api.catalyst.zoho.com"
    public internal( set ) var serverTLD : ServerTLD
    {
        didSet
        {
            self.apiBaseURL = "https://api.catalyst.zoho.\( serverTLD )"
        }
    }
    var apiVersion : String = "v1"
    public internal( set ) var projectId : String
    public internal( set ) var environment : ZCatalystEnvironment
    
    public init( clientId : String, clientSecret : String, redirectURLScheme : String, portalId : String, projectId : String, serverTLD : ServerTLD = .com, environment : ZCatalystEnvironment = .production ) throws
    {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.portalId = portalId
        self.serverTLD = serverTLD
        self.redirectURLScheme = redirectURLScheme
        self.projectId = projectId
        self.environment = environment
        try self.validate()
    }
    
    enum CodingKeys : String, CodingKey
    {
        case clientId = "ClientID"
        case clientSecret = "ClientSecretID"
        case portalId = "PortalID"
        case redirectURLScheme = "RedirectURLScheme"
        case projectId = "ProjectID"
        case oAuthScopes = "OAuthScopes"
        case apiBaseURL = "ApiBaseURL"
        case apiVersion = "ApiVersion"
        case accountsURL = "AccountsURL"
    }
    
    public init( from decoder : Decoder ) throws
    {
        let container = try decoder.container( keyedBy : CodingKeys.self )
        self.clientId = try container.decode( String.self, forKey : .clientId )
        self.clientSecret = try container.decode( String.self, forKey : .clientSecret )
        self.portalId = try container.decode( String.self, forKey : .portalId )
        self.redirectURLScheme = try container.decode( String.self, forKey : .redirectURLScheme )
        self.projectId = try container.decode( String.self, forKey : .projectId )
        self.oAuthScopes = try container.decode( [ String ].self, forKey : .oAuthScopes )
        self.serverTLD = .com
        self.apiBaseURL = try container.decode( String.self, forKey : .apiBaseURL )
        self.apiVersion = try container.decode( String.self, forKey : .apiVersion )
        self.accountsURL = try container.decode( String.self, forKey : .accountsURL )
        self.environment = .production
        try validate()
    }
    
    private func validate() throws
    {
        var emptyProperties : [ String ] = [ String ]()
        if clientId.isEmpty
        {
            emptyProperties.append( "clientId" )
        }
        if clientSecret.isEmpty
        {
            emptyProperties.append( "clientSecret" )
        }
        if accountsURL.isEmpty
        {
            emptyProperties.append( "accountsURL" )
        }
        if portalId.isEmpty
        {
            emptyProperties.append( "portalId" )
        }
        if oAuthScopes.isEmpty
        {
            emptyProperties.append( "oAuthScopes" )
        }
        if redirectURLScheme.isEmpty
        {
            emptyProperties.append( "redirectURLScheme" )
        }
        if apiBaseURL.isEmpty
        {
            emptyProperties.append( "apiBaseURL" )
        }
        if apiVersion.isEmpty
        {
            emptyProperties.append( "apiVersion" )
        }
        if projectId.isEmpty
        {
            emptyProperties.append( "projectId" )
        }
        if !emptyProperties.isEmpty
        {
            throw ZCatalystError.inValidError( code : ErrorCode.initializationError, message : "Mandatory not found --> \( emptyProperties.joined( separator : "," ) )", details : nil )
        }
    }
}
