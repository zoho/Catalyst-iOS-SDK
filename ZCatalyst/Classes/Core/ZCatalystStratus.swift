//
//  ZCatalystStratus.swift
//  ZCatalyst
//
//  Created by gowtham-pt2177 on 12/03/24.
//

import Foundation

public class ZCatalystStratus {
    
    public static func getBucketInstance( name : String ) -> ZCatalystBucket
    {
        return ZCatalystBucket(name: name)
    }
}
