//
//  GenerateRequest.swift
//  
//
//  Created by Robert Latta on 6/30/17.
//  Copyright © 2017 Robert Latta. All rights reserved.
//

import Foundation

/**
 - parameters:
 - url: the url where request is going
 - params: the post data parameters to be sent in the request
 I made it a class to be reused since I have to make many web requests and dont want to have to rewrite the code for each one
 */
public class GenerateRequest
{
    class func createRequest(url : String, params : Dictionary <String, AnyObject>?) -> NSMutableURLRequest
    {

        let theRequest : NSMutableURLRequest = NSMutableURLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 90)
        theRequest.httpMethod = "POST"

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
