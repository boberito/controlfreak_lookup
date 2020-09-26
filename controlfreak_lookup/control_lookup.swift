//
//  control_lookup.swift
//  controlfreak_lookup
//
//  Created by Bob Gendler on 9/24/20.
//  Copyright © 2020 Bob Gendler. All rights reserved.
//

import Foundation

#if os(Linux)
import FoundationNetworking
#endif

class ControlLookup {
    func lookup(control: String) {
        
        let baseURL = "https://controlfreak.risk-redux.io/controls/"
        var fullURL = baseURL + control
        
        fullURL = fullURL.replacingOccurrences(of: "(", with: " (")
        fullURL = fullURL.replacingOccurrences(of: "  (", with: " (")
        fullURL = fullURL.replacingOccurrences(of: " ", with: "%20")
        let headers = ["Accept": "application/json"]
        
        var request = URLRequest(url: URL(string: fullURL)!)

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {data,response,error in
            let httpResponse = response as? HTTPURLResponse
            let dataReturn = data
            
            if (error != nil) {
                DispatchQueue.main.async {
                    print("An Error Occured")
                }
            } else {
                do {
                    switch httpResponse!.statusCode {
                    case 200:
                        let decoder = JSONDecoder()
                        
                        if let decodedControl = try? decoder.decode(controlData.self, from: dataReturn!) {
                            let items = decodedControl.control.statements
                            for item in items{
                                print(item.number + ": " + item.description)
                                
                            }
                            print("------------------")
                            if decodedControl.control.is_baseline_impact_low{
                                print("Low Baseline")
                            }
                            if decodedControl.control.is_baseline_impact_moderate{
                                print("Moderate Baseline")
                            }
                            if decodedControl.control.is_baseline_impact_high{
                                print("High Baseline")
                            }
                            if !decodedControl.control.is_baseline_impact_low && !decodedControl.control.is_baseline_impact_moderate && !decodedControl.control.is_baseline_impact_high {
                                print("Not on any Baseline")
                            }
                        }
                        
                        dispatchGroup.leave()
                        
                    case 500:
                        print("Control Not Found")
                        dispatchGroup.leave()
                    default:
                        print("Error with URL or Server")
                        dispatchGroup.leave()
                    }
                } 
                
            }
        }
        task.resume()
        dispatchGroup.wait()
    }
}
