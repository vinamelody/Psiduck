//
//  ViewController.swift
//  Psiduck
//
//  Created by Vina Melody on 7/9/16.
//  Copyright © 2016 Vina Rianti. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import CoreLocation
import SwiftyJSON

public class ViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var btnRefresh: UIButton!
    public var annotations = [MKPointAnnotation]()
    var labelTimestamp: String!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        map.delegate = self
        self.mainAction()
        
    }
    
    // MARK: Main Action (callable)
    
    public func mainAction() {
        
        self.getPsiReadingFromNea { (json) in
            
            guard json != nil else {
                
                // something error with retrieving data, error should be displayed, do nothing
                let alert = UIAlertController(title: "Error", message: "Something is error" + "\nHit Refresh button again when you're connected to the Internet.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            
            // Decoding the json will be followed by creating marker on the map
            self.decodePsiJson(json!)
            self.addAnnotationToMap()
            
            // Add the last updated data on button Refresh
            self.updateBtnRefreshLabel()
            // Fetching data completed, hide the loading indicator
            LoadingOverlay.shared.hideOverlayView()
            
        }
    }

    // MARK: Button Refresh Action
    
    @IBAction func btnRefreshTapped(sender: UIButton) {
        
        self.annotations.removeAll()
        self.mainAction()
        
    }
    
    func updateBtnRefreshLabel() {
        
        let labelBtn: String = "Refresh\n(Last updated data on " + self.labelTimestamp + ")"
        
        let btnText = NSMutableAttributedString(string: labelBtn)
        btnText.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(15), range: NSMakeRange(0,7))
        btnText.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(10), range: NSMakeRange(8,labelBtn.characters.count-8 ))
        self.btnRefresh.titleLabel?.textAlignment = NSTextAlignment.Center
        self.btnRefresh.setAttributedTitle(btnText, forState: .Normal)
    }

    
    // MARK: Get PSI Reading from NEA, decode it and create markers
    
    public func getPsiReadingFromNea(completion: (JSON? -> ())) {
        
        let apiKey = "veTSJLZLu6LhRrNYUFYbQutADtHkBKvr"
        let apiUrl = "https://api.data.gov.sg/v1/environment/psi"
        let headers = ["api-key": apiKey]
        
        
        Alamofire.request(.GET, apiUrl, headers: headers, parameters: nil).responseJSON { (response) in
            
            LoadingOverlay.shared.showOverlay(self.view)
            
            switch response.result {
            case .Success(let data):
                
                let json = SwiftyJSON.JSON(data)
                
                completion(json)
                
            case .Failure(let error):
        
                let alert = UIAlertController(title: "Error", message: error.localizedDescription + "\nHit Refresh button again when you're connected to the Internet.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                print(error)
                
            }
        }
    }
    
    func decodePsiJson(json: JSON) {
        
        let regions = json["region_metadata"]
        let psi = json["items"][0]
        
        var timestamp: String = ""
        timestamp = json["items"][0]["update_timestamp"].stringValue
        
        self.labelTimestamp = self.prettifyDate(timestamp)
        
        for (key, location):(String, JSON) in regions {
            // key 0 is national
            if (key != "0") {
                let reading = PsiReading(regionName: location["name"].stringValue,
                                         longitude: location["label_location"]["longitude"].doubleValue,
                                         latitude: location["label_location"]["latitude"].doubleValue,
                                         psi: psi)
                self.createMarker(reading)
            }
        }

    }
    
    
    func createMarker(psi: PsiReading ) {
        
        let readingContent =
            "PSI Readings:\n\n" + "24hr: " + psi.psi_24hr +
            "\n3hr: " + psi.psi_3hr +
            "\nPM10 24hr: " + psi.pm10_24hr +
            "\nPM10 Sub Index: " + psi.pm10_sub_index +
            "\nPM2.5 24hr: " + psi.pm25_24hr +
            "\nPM2.5 Sub Index: " + psi.pm25_sub_index +
            "\nSO2 24hr: " + psi.so2_24hr +
            "\nO3 8hr: " + psi.o3_8hr_max +
            "\nO3 Sub Index: " + psi.o3_sub_index +
            "\nNO2 1hr: " + psi.no2_1hr_max +
            "\nCO 8hr: " + psi.co_8hr_max +
            "\nCO Sub Index: " + psi.co_sub_index
        
        let location = CLLocationCoordinate2DMake(psi.latitude, psi.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = psi.regionName.capitalizedString
        annotation.subtitle = readingContent
            
        self.annotations.append(annotation)
        
    }
    
    func addAnnotationToMap() {
        
        for annotation in self.annotations {
            self.map.addAnnotation(annotation)
        }
    }
    
    
    // MARK: Helper function to produce human readable date string
    
    func prettifyDate(timeString: String) -> String {
        
        // The format from NEA is "2016-09-08T17:00:00+08:00"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssSSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC+8")
        
        guard let newTime = dateFormatter.dateFromString(timeString) else {
            return timeString
        }
        
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"

        let newTimeString = dateFormatter.stringFromDate(newTime)
        
        return newTimeString
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    public func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
        }
        else {
            pinView!.annotation = annotation
        }
        
        let subtitleView = UILabel()
        subtitleView.font = subtitleView.font.fontWithSize(12)
        subtitleView.numberOfLines = 0
        subtitleView.text = annotation.subtitle!
        pinView!.detailCalloutAccessoryView = subtitleView
        
        return pinView
    }

}

