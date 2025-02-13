//
//  ZCatalystStratus.swift
//  ZCatalyst
//
//  Created by Gowtham B R on 12/02/25.
//

import Foundation

public class ZCatalystStratus {
    
    public static func getBucketInstance( name : String ) -> ZCatalystBucket
    {
        return ZCatalystBucket(name: name)
    }
}
