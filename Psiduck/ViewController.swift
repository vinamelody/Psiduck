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

class ViewController: UIViewController {
    
    let apiKey = "veTSJLZLu6LhRrNYUFYbQutADtHkBKvr"
    let apiUrl = "https://api.data.gov.sg/v1/environment/psi"

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        map.delegate = self
        getPsiReading()
    }

    func getPsiReading() {
        
        let headers = ["api-key": apiKey]
        
        Alamofire.request(.GET, apiUrl, headers: headers, parameters: nil).responseJSON { (response) in
            
            switch response.result {
            case .Success(let data):
                //print(data)
                
                let json = SwiftyJSON.JSON(data)
                
                let regions = json["region_metadata"]
                let readings = json["items"][0]
                
                for (key, location):(String, JSON) in regions {
                    if (key != "0") {
                        //print(key)
                        self.createMarker(location["name"].stringValue, latitude: location["label_location"]["latitude"].doubleValue, longitude: location["label_location"]["longitude"].doubleValue, readings: readings)
//                        print(location["name"])
//                        print(location["label_location"]["latitude"])
//                        print(location["label_location"]["longitude"])
//                        print(readings["readings"]["psi_three_hourly"][location["name"].stringValue])
                    }
                }
                
                
                
                //print(readings["readings"]["psi_three_hourly"]["central"])
                
            case .Failure(let error):
                print(error)
            }
            
            
        }
    }
    
    func createMarker(regionName: String, latitude: Double, longitude: Double, readings: JSON ) {
        
        print("region: " + regionName)
        let psi_24hr = readings["readings"]["psi_twenty_four_hourly"][regionName].stringValue
        let psi_3hr = readings["readings"]["psi_three_hourly"][regionName].stringValue
        let pm10_24hr = readings["readings"]["pm10_twenty_four_hourly"][regionName].stringValue
        let pm10_sub_index = readings["readings"]["pm10_sub_index"][regionName].stringValue
        let pm25_24hr = readings["readings"]["pm25_twenty_four_hourly"][regionName].stringValue
        let pm25_sub_index = readings["readings"]["pm25_sub_index"][regionName].stringValue
        let so2_24hr = readings["readings"]["so2_twenty_four_hourly"][regionName].stringValue
        let o3_sub_index = readings["readings"]["o3_sub_index"][regionName].stringValue
        let o3_8hr_max = readings["readings"]["o3_eight_hour_max"][regionName].stringValue
        let no2_1hr_max = readings["readings"]["no2_one_hour_max"][regionName].stringValue
        let co_8hr_max = readings["readings"]["co_eight_hour_max"][regionName].stringValue
        let co_sub_index = readings["readings"]["co_sub_index"][regionName].stringValue
    
        
        let readingContent = "PSI Readings:\n" + "24hr: " + psi_24hr + "\n3hr: " + psi_3hr + "\nPM10 24hr: " + pm10_24hr + "\nPM10 Sub Index: " + pm10_sub_index + "\nPM2.5 24hr: " + pm25_24hr + "\nPM2.5 Sub Index: " + pm25_sub_index + "\nSO2 24hr: " + so2_24hr + "\nO3 8hr: " + o3_8hr_max + "\nO3 Sub Index: " + o3_sub_index + "\nNO2 1hr: " + no2_1hr_max + "\nCO 8hr: " + co_8hr_max + "\nCO Sub Index: " + co_sub_index
        
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = regionName.capitalizedString
        annotation.subtitle = readingContent
            
        
        self.map.addAnnotation(annotation)
        
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
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

