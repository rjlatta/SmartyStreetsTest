//
//  DataParser.swift
//  Health Ticket V3
//
//  Created by Robert Latta on 8/30/16.
//  Copyright © 2016 Robert Latta. All rights reserved.
//

import Foundation
import UIKit

/**
 - parameters:
 - T: Generic where object type is passed in to parse JSON data into the passed in object to be returned
 */
class DataParser : NSObject
{
    class func parseDataToObjectArray<T : Decodable>(data : Data, classObject : T.Type) -> T?
    {
        //Creates an instance of the passed in Generic
        var dataResults : T?

        //tries to parse the JSON into the corresponding object passed into class
        do
        {
            let decoder = JSONDecoder()

            //let dataresults3 = String(data: data, encoding: .utf8)
            
            dataResults = try decoder.decode(T.self, from: data)
            
        }
        catch let error
        {
            print(error)
            return nil
        }
        
        return dataResults!
    }
    
}
