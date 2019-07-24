//
//  DatabaseManager.swift
//  
//
//  Created by Robert Latta on 7/1/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation
import SQLite3

/**
 Seperate clas that hass all of the methods needed to interact with a sqlite database
 */
class DatabaseManager
{

    //returns a pointer to database. It is opaque becuase we can't see what is inside the connection
    func OpenDatabaseConnection(databaseName : String) -> OpaquePointer?
    {
        let databaseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(databaseName)
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(databaseURL.path, &db) == SQLITE_OK
        {
            print("Successfully opened connection to database at \(databaseURL.path)")
            return db
        }
        else
        {
            return nil
        }
    }
    
    func CreateTable(connection : OpaquePointer, tableCreationString : String) -> Bool
    {
        var createTableStatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(connection, tableCreationString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                //Table created
                sqlite3_finalize(createTableStatement)
                return true
            }
            else
            {
                //Table failed to be created
                sqlite3_finalize(createTableStatement)
                return false
            }
        }
        else
        {
            //Table exists already
            sqlite3_finalize(createTableStatement)
            return true
        }
    }
    //I only store the most important pieces of information for time. Full scale I would store every value in the object
    func insertRow(connection : OpaquePointer, id : Int32, addressOne : String, addressTwo : String, county : String, latitude : String, longitude : String)
    {

        let insertStatementString = "INSERT INTO Addresses (Id, delivery_line, last_line, county, latitude, longitude) VALUES (\(id), \'\(addressOne)\', \'\(addressTwo)\', \'\(county)\', \'\(latitude)\', \'\(longitude)\');"

        var insertStatement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(connection, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_int(insertStatement, 1, id)
            sqlite3_bind_text(insertStatement, 2, addressOne, -1, nil)
            sqlite3_bind_text(insertStatement, 3, addressTwo, -1, nil)
            sqlite3_bind_text(insertStatement, 4, county, -1, nil)
            sqlite3_bind_text(insertStatement, 5, latitude, -1, nil)
            sqlite3_bind_text(insertStatement, 6, longitude, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE
            {
                sqlite3_finalize(insertStatement)
                //Row inserted
            }
            else
            {
                sqlite3_finalize(insertStatement)
                //Failed to insert row
            }
        }
        else
        {
            
        }
    }
    
    func deleteRow(connection : OpaquePointer, row : Int) -> Bool
    {
        let deleteStatementString = "DELETE FROM Addresses WHERE Id = \(row)"
        var deleteStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(connection, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK
        {
            if(sqlite3_step(deleteStatement) == SQLITE_DONE)
            {
                sqlite3_finalize(deleteStatement)
                return true
            }
            else
            {
                sqlite3_finalize(deleteStatement)
                return false
            }
        }
        else{
            sqlite3_finalize(deleteStatement)
            return false
        }
    }
    
    func deleteAllData(connection : OpaquePointer)
    {
        let deleteStatementString = "DELETE FROM Addresses"
        var deleteStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(connection, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK
        {
            if(sqlite3_step(deleteStatement) == SQLITE_DONE)
            {
                
                
            }
            else
            {
                
              
            }
        }
        else{
            
           
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func queryDataBase(connection : OpaquePointer) -> [SmartyStreetResult]
    {
        var returnList : [SmartyStreetResult] = []
        let queryStatmentString = "SELECT * FROM Addresses"
        var queryStatment : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(connection, queryStatmentString, -1, &queryStatment, nil) == SQLITE_OK
        {
            while(sqlite3_step(queryStatment) == SQLITE_ROW)
            {
                let address : SmartyStreetResult = SmartyStreetResult()
                
                
                if let extractValueDeliveryLine = sqlite3_column_text(queryStatment, 1)
                {
                   address.delivery_line_1 = String(cString: extractValueDeliveryLine)
                }
                if let extractValueLastLine = sqlite3_column_text(queryStatment, 2)
                {
                    address.last_line = String(cString: extractValueLastLine)
                }
                if let extractValueCounty = sqlite3_column_text(queryStatment, 3)
                {
                    address.metadata?.county_name = String(cString: extractValueCounty)
                }
                if let extractValueLatitude = sqlite3_column_text(queryStatment, 4)
                {
                    address.metadata?.latitude = Double(String(cString: extractValueLatitude))
                }
                if let extractValueLongitude = sqlite3_column_text(queryStatment, 5)
                {
                   address.metadata?.longitude = Double(String(cString: extractValueLongitude))
                }
                 
                
                returnList.append(address)
            }
        }
        
        return returnList
    }
    func closeDatabaseConnection(connection : OpaquePointer)
    {
        sqlite3_close(connection)
    }
}
