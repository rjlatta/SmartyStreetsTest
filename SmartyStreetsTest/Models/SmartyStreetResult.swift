//
//  SmartyStreetResult.swift
//  SmartyStreetsTest
//
//  Created by Robert Latta on 7/22/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation

/**
 - parameters:
 - input_index: the order the address was submitted with others
 - candidate_index: an input index can match multiple valid addresses. Ties candidates to input index
 - delivery_line_1: includes primary number, street name, street predirection, street postdirection etc..
 - delivery_line_2: Usually empty but contains mailbox numbers as example
 - last_line: City, State, Zipcode
 - components: object mapping all address components seperated
 - metadata: object containing county, latitude and longitude
 */
class SmartyStreetResult : Decodable
{
    var input_index : Int?
    
    var candidate_index : Int?
    
    var delivery_line_1 : String?
    
    var delivery_line_2 : String?
    
    var last_line : String?
    
    var components : SmartyStreetsCompnent?
    
    var metadata : SmartyStreetMetaData?
    
    init()
    {
        components = SmartyStreetsCompnent()
        
        metadata = SmartyStreetMetaData()
    }
}
