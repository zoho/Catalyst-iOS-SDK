//
//  PayloadFactory.swift
//  Catalyst
//
//  Created by Giridhar on 23/05/19.
//

import Foundation


struct PayloadFactory
{ 
    static func generateSearch(api: SearchAPI) -> Payload
    {
        switch api
        {
        case .search(let text, let coloumn, let select,let order, let start, let end):
            print("")
            var bodyJSON : [ String : Any ] = [ "search" :text,
                                           "search_table_columns" : coloumn,
                                           "start" : start,
                                           "end" : end ]
            if let s = select
            {
                bodyJSON["select_table_columns"] = s
            }
            if let o = order
            {
                bodyJSON["order_by"] = o
            }
            
            return Payload(bodyParameters: bodyJSON, urlParameters: nil, headers: nil, bodyData: nil)
        }
    }
}

