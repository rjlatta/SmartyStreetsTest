//
//  WebServiceConnector.swift
//  NewWordSearch
//
//  Created by Robert Latta on 5/29/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation


/**
 - parameters:
 - T: Generic object that is determined by being passed into getData Function
 */
class WebServiceConnector
{
    func getData<T : Decodable>(_ request : NSURLRequest, responseType : T?, completionHandler: @escaping (_ result : T?, _ error : Error?) -> Void){
        
        let session = URLSession.shared
        
        session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            guard (error == nil) else
            {
                completionHandler(nil, error)
                return
            }
            
            guard let _ = data else
            {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Data does not exist"])
                completionHandler(nil, noDataError)
                return
            }
            
            if let results : T = DataParser.parseDataToObjectArray(data: data!, classObject: T.self)
            {
                completionHandler(results, nil)
            }
            else
            {
                let dataParseError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Failed to parse data"])
                completionHandler(nil, dataParseError)
            }
            
        }).resume()
    }
}
