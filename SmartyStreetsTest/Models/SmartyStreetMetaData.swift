//
//  SmartyStreetMetaData.swift
//  SmartyStreetsTest
//
//  Created by Robert Latta on 7/22/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation

/**
 - parameters:
 - county_name: county location is in
 - latitude: location latitude
 - longitude: location longitude
 */
class SmartyStreetMetaData : Decodable
{
    var county_name : String?
    
    var latitude : Double?
    
    var longitude : Double?
}
