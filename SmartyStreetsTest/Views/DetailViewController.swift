//
//  DetailViewController.swift
//  SmartyStreetsTest
//
//  Created by Robert Latta on 7/22/19.
//  Copyright © 2019 rl. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailViewController: UIViewController
{
    var smartyStreetAddress : SmartyStreetResult?
    
    @IBOutlet var detailText : UITextView!
    
    @IBOutlet var mapView : MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var location : CLLocation!
        if(smartyStreetAddress != nil)
        {
            if(smartyStreetAddress!.metadata!.latitude != nil && smartyStreetAddress!.metadata!.longitude != nil)
            {
                location = CLLocation(latitude: smartyStreetAddress!.metadata!.latitude!, longitude: smartyStreetAddress!.metadata!.longitude!)
                centerMapOnLocation(location: location)
            }
            else
            {
                let alert = UIAlertController.init(title: "Attention!", message: "There is no Coordinate data with this address to display on the map", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                //location = CLLocation(latitude: 21.282778, longitude: -157.829444)
            }
        }
        else
        {
            let alert = UIAlertController.init(title: "Attention!", message: "There is no Data To Display", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        FillInInformation()
    }
    
    
    //for brevity I only display minimal information due to only storing some of the fields in the database.
    //could be expanded if I expand the number of fields of data I store in the database
    func FillInInformation()
    {
        let boldAttribute = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        
        let infoText : NSMutableAttributedString = NSMutableAttributedString(string: "Address : ", attributes: boldAttribute)
        infoText.append(NSAttributedString(string: String(format: "%@, %@", smartyStreetAddress!.delivery_line_1 ?? "", smartyStreetAddress!.last_line ?? "")))
        infoText.append(NSMutableAttributedString(string: "\n"))
        infoText.append(NSMutableAttributedString(string: "More Details : ", attributes: boldAttribute))
        infoText.append(NSMutableAttributedString(string: smartyStreetAddress!.metadata?.county_name ?? ""))
        
        detailText.attributedText = infoText
    }

    
    func centerMapOnLocation(location : CLLocation)
    {
        let regionRadius : CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }
}
