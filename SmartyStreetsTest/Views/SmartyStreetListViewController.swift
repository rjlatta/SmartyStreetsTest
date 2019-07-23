//
//  SmartyStreetLookupViewController.swift
//  SmartyStreetsTest
//
//  Created by Robert Latta on 7/21/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation
import UIKit



class SmartyStreetListViewController: UITableViewController
{
    /**
     - parameters:
     - addressLookUps: Array of validated addresses
     - detailsToPass: Object to pass to detail view when selected in table
     - manager: instance of database manager so class can interact with database
     - tableExists: Bool for checkng if the table has been created
     - updateNeeded: Says if data needs to be written to Database
     */
    var addressLookUps : [SmartyStreetResult] = []
    
    var detailsToPass : SmartyStreetResult?
    
    var manager : DatabaseManager?
    
    var tableExists : Bool = false
    
    var updateNeeded : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 44
        
        
        navigationController?.navigationBar.isHidden = false
        //BarButton to run a new smarty Street Lookup.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItem.Style.plain, target: self, action: #selector(smartyStreetPopup))
        //Button to manually write to database
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Update", style: UIBarButtonItem.Style.plain, target: self, action: #selector(writeToDataBase))
        manager = DatabaseManager()
        
        createDataBaseTable()
        loadAddressData()
    }
    //Thought a popup would be cleaner than shifting to a new view
    @objc func smartyStreetPopup()
    {
        //shows a popup where user can enter an address to look up
        let popup = UIAlertController.init(title: "Enter Address", message: nil, preferredStyle: .alert)
        popup.addTextField(configurationHandler: nil)
        
        let submitAddressAction = UIAlertAction(title: "Submit", style: .default, handler: {[unowned popup] _ in
            if(popup.textFields![0].text != nil && popup.textFields![0].text!.count > 0)
            {
                self.runLookUp(address: popup.textFields![0].text)
            }
        })
        
        popup.addAction(submitAddressAction)
        
        present(popup, animated: true, completion: nil)
    }
    
    /**
     - parameters:
     - address: entered address by user from popup
     - task: class that runs the lookup
     */
    func runLookUp(address : String?)
    {
        //Address lookup task declaration
        let task = SmartyStreetLookupTask()
        /**
         - parameters:
         - results: Array of SmartyStreetResults or nil
         */
        task.lookUp(address: address!, completionHandler: {results,error in
            if(error != nil)
            {
                print(error!)
                
            }
            else
            {
                if(results != nil && results!.count != 0)
                {
                    for returnedAddress in results!
                    {
                        self.addressLookUps.append(returnedAddress)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    
                    }
                }
                else
                {
                    let alert = UIAlertController.init(title: "Attention!", message: "The entered address was invalid", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressLookUps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AddressListTableCell = tableView.dequeueReusableCell(withIdentifier: "listTableCell", for: indexPath) as! AddressListTableCell
        let info = addressLookUps[indexPath.row]
        let boldAttribute = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        
        let infoText : NSMutableAttributedString = NSMutableAttributedString(string: "Address : ", attributes: boldAttribute)
        infoText.append(NSAttributedString(string: String(format: "%@, %@", info.delivery_line_1 ?? "", info.last_line ?? "")))
        cell.informationTextView.attributedText = infoText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailsToPass = addressLookUps[indexPath.row]
        self.performSegue(withIdentifier: "toAddressDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController
        {
            if(detailsToPass != nil)
            {
                destination.smartyStreetAddress = detailsToPass!
            }
        }
    }
    
    func openDataBaseConnection() -> OpaquePointer?
    {
        
        return manager!.OpenDatabaseConnection(databaseName: "addressdatabase.sqlite") ?? nil
    }
    
    func createDataBaseTable()
    {
        let databaseConnection = openDataBaseConnection()
        if(databaseConnection != nil)
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
        
            tableExists = manager!.CreateTable(connection: databaseConnection!, tableCreationString: createTableString)
            closeDataBaseConnection(databasePointer: databaseConnection!)
        }
        
    }
    
    

    func loadAddressData()
    {
        let databaseConnection = openDataBaseConnection()
        if(databaseConnection != nil)
        {
            addressLookUps = manager!.queryDataBase(connection: databaseConnection!)
            
            updateNeeded = true
            tableView.reloadData()
            closeDataBaseConnection(databasePointer: databaseConnection!)
        }
        
    }
    // made it clear the database after loading data so that I could better manage the id as I write the objects into the database
    // since I read the auto increment is very slow
    @objc func writeToDataBase()
    {
        let databaseConnection = openDataBaseConnection()
        manager!.deleteAllData(connection: databaseConnection!)
        if(databaseConnection != nil)
        {
            var count = 1
            for writeAddress in addressLookUps
            {
                manager!.insertRow(connection: databaseConnection!, id: Int32(count), addressOne: writeAddress.delivery_line_1!, addressTwo: writeAddress.last_line!, county: writeAddress.metadata!.county_name!, latitude: String(writeAddress.metadata!.latitude!), longitude: String(writeAddress.metadata!.longitude!))
            
                count += 1
            }
        
            updateNeeded = false
            closeDataBaseConnection(databasePointer: databaseConnection!)
        }
    }
    
    func closeDataBaseConnection(databasePointer : OpaquePointer)
    {
        if(manager != nil)
        {
            manager!.closeDatabaseConnection(connection: databasePointer)
        }
    }

    
    deinit {
        

    }
}
