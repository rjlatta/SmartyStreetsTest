//
//  SmartyStreetLookupTask.swift
//  SmartyStreetsTest
//
//  Created by Robert Latta on 7/22/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation


class SmartyStreetLookupTask
{
    /**
     - parameters:
     - privateId: Id assigned by smarty streets to validate a valid call
     - privateToken: Token also assigned by smarty streets to validate valid call
     I like splitting tasks off into their own class to reduce code bloat in the view classes
     */
    //Free account, Limited to 250 per month. 28 used lookups as of this commit
    private let privateId = "8af87e40-e280-f3f5-7277-ad9bee3c7f38"
    private let privateToken = "7hdf4VtH55dnn2ont09A"
    
    
    func lookUp(address : String, completionHandler: @escaping (_ result : [SmartyStreetResult]?, _ error : Error?) -> Void)
    {
        var parameters = [String:AnyObject]()
        parameters["street"] = address as AnyObject
        parameters["candidates"] = 10 as AnyObject
        let request = GenerateRequest.createRequest(url: "https://us-street.api.smartystreets.com/street-address?auth-id=\(privateId)&auth-token=\(privateToken)", params: parameters)
        
        let connection = WebServiceConnector()
        connection.getData(request, responseType: [SmartyStreetResult](), completionHandler: {results,error in
            if(error != nil)
            {
                completionHandler(nil, error)
            }
            else
            {
                completionHandler(results, nil)
            }
            
        })
        
    }
}
