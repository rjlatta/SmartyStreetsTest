//
//  GenerateRequest.swift
//  Key Risk
//
//  Created by Robert Latta on 6/30/17.
//  Copyright © 2017 Robert Latta. All rights reserved.
//

import Foundation

public class GenerateRequest
{
    class func createRequest(url : String, params : Dictionary <String, AnyObject>?) -> NSMutableURLRequest
    {

        let theRequest : NSMutableURLRequest = NSMutableURLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 90)
        theRequest.httpMethod = "POST"
        //let encodedHeader : String = "Basic " + Authorization.createSignature()
        //theRequest.setValue(encodedHeader, forHTTPHeaderField: "Authorization")
        //theRequest.setValue("TMI001", forHTTPHeaderField: "X-VIIAD-API-ENVIRONMENT")
        let contentType : String = "application/json"
        theRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        if params != nil
        {
            do
            {
                let requestData = try JSONSerialization.data(withJSONObject: [params!], options: JSONSerialization.WritingOptions(rawValue: 0))
                theRequest.httpBody = requestData
                
            }
            catch
            {
                
            }
        }
        
        return theRequest
    }
}
