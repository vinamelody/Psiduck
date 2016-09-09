//
//  PsiReading.swift
//  Psiduck
//
//  Created by Vina Melody on 8/9/16.
//  Copyright © 2016 Vina Rianti. All rights reserved.
//

import Foundation
import SwiftyJSON

class PsiReading {
    
    let regionName: String
    let longitude: Double
    let latitude: Double
    let psi_24hr: String
    let psi_3hr: String
    let pm10_24hr: String
    let pm10_sub_index: String
    let pm25_24hr: String
    let pm25_sub_index: String
    let so2_24hr: String
    let o3_sub_index: String
    let o3_8hr_max: String
    let no2_1hr_max: String
    let co_8hr_max: String
    let co_sub_index: String
    
    
    init(regionName: String, longitude: Double, latitude: Double, psi: JSON) {
        
        self.regionName = regionName
        self.longitude = longitude
        self.latitude = latitude
        
        self.psi_24hr = psi["readings"]["psi_twenty_four_hourly"][regionName].stringValue
        self.psi_3hr = psi["readings"]["psi_three_hourly"][regionName].stringValue
        self.pm10_24hr = psi["readings"]["pm10_twenty_four_hourly"][regionName].stringValue
        self.pm10_sub_index = psi["readings"]["pm10_sub_index"][regionName].stringValue
        self.pm25_24hr = psi["readings"]["pm25_twenty_four_hourly"][regionName].stringValue
        self.pm25_sub_index = psi["readings"]["pm25_sub_index"][regionName].stringValue
        self.so2_24hr = psi["readings"]["so2_twenty_four_hourly"][regionName].stringValue
        self.o3_sub_index = psi["readings"]["o3_sub_index"][regionName].stringValue
        self.o3_8hr_max = psi["readings"]["o3_eight_hour_max"][regionName].stringValue
        self.no2_1hr_max = psi["readings"]["no2_one_hour_max"][regionName].stringValue
        self.co_8hr_max = psi["readings"]["co_eight_hour_max"][regionName].stringValue
        self.co_sub_index = psi["readings"]["co_sub_index"][regionName].stringValue
        
    }
}