//
//  SmartyStreetsComponent.swift
//  SmartyStreetsTest
//
//  Created by Robert Latta on 7/22/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation

/**
 - parameters:
 - primary_number: house, PO box or building number
 - street_name: name of street
 - street_predirection: Directional info before street name
 - street_postdirection: Directional info after street name
 - street_suffix: Abbreviated value describing the street (St, Ave,Blvd, etc)
 - secondary_number: apartment or suite number
 - secondary_designator: describes location within a complex/building
 - extra_secondary_number: descriptive info about location of building within a campus
 - extra_secondary_designator: description of the location type within a campus
 - city_name: USPS prefered city name for this address
 - default_city_name: default city name for this zip code
 - state_abbreviation: two letter state abbreviation
 - zipcode: 5 digit zip code
 */
class SmartyStreetsCompnent : Decodable
{
    var primary_number : String?
    
    var street_name : String?
    
    var street_predirection : String?
    
    var street_postdirection : String?
    
    var street_suffix : String?
    
    var secondary_number : String?
    
    var secondary_designator : String?
    
    var extra_secondary_number : String?
    
    var extra_secondary_designator : String?
    
    var city_name : String?
    
    var default_city_name : String?
    
    var state_abbreviation : String?
    
    var zipcode : String?
    

}
