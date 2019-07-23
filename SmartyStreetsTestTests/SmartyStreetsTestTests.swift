//
//  SmartyStreetsTestTests.swift
//  SmartyStreetsTestTests
//
//  Created by Robert Latta on 7/21/19.
//  Copyright © 2019 rl. All rights reserved.
//

import XCTest
@testable import SmartyStreetsTest

class SmartyStreetsTestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testWebcall()
    {
        let task = SmartyStreetLookupTask()

        task.lookUp(address: "1 Infinite Loop Cupertino, CA 95014", completionHandler: {results,error in
            assert(error != nil, "There was an error")
            assert(results != nil, "An address was found")
            
        })
    }
    
    func testDatabaseOpen()
    {
        let manager = DatabaseManager()
        let databasePointer = manager.OpenDatabaseConnection(databaseName: "addressdatabase.sqlite")
        assert(databasePointer != nil, "Database opened successfully")
    }
    
    func testTableCreation()
    {
        let createTableString = """
            CREATE TABLE Addresses(
            Id INT PRIMARY KEY NOT NULL,
            delivery_line CHAR(255),
            last_line CHAR(255),
            county CHAR(255),
            latitude CHAR(255),
            longitude CHAR(255));
            """
        let manager = DatabaseManager()
        let databasePointer = manager.OpenDatabaseConnection(databaseName: "addressdatabase.sqlite")
        let tableExists = manager.CreateTable(connection: databasePointer!, tableCreationString: createTableString)
        assert(tableExists, "Table exists")
    }

}
