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
    
    //rev 4 lookup method
    func lookup(control: String, _ showAll: Bool) {
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
                            print(decodedControl.control.title)
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
                            
                            
                            if showAll {
                                print("------------------")
                                print(decodedControl.control.supplement.description)
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
    
    //rev 5 lookup method
    func lookup5(control: String, _ showAll: Bool = false) {
        var modifiedControl = ""
        let baseURL = "https://controlfreak5.risk-redux.io/controls/"
        if let controlNumber = Int(control.components(separatedBy: "-")[1].replacingOccurrences(of: " ", with: "")) {
            if controlNumber <= 9 {
                modifiedControl = control.components(separatedBy: "-")[0] + "-0" + String(controlNumber)
            } else {
                modifiedControl = control
            }
        } else if let controlNumber = Int(control.components(separatedBy: "-")[1].components(separatedBy: "(")[0].replacingOccurrences(of: " ", with: "")), let subcontrol = Int(control.components(separatedBy: "(")[1].replacingOccurrences(of: ")", with: "")) {
            if controlNumber <= 9 && subcontrol <= 9 {
                modifiedControl = control.components(separatedBy: "-")[0] + "-0" + String(controlNumber) + "(0" + String(subcontrol) + ")"
            } else if controlNumber < 9 && subcontrol <= 9 {
                modifiedControl = control.components(separatedBy: "-")[0] + "-" + String(controlNumber) + "(0" + String(subcontrol) + ")"
            } else if controlNumber <= 9 && subcontrol < 9 {
                modifiedControl = control.components(separatedBy: "-")[0] + "-" + String(controlNumber) + "(" + String(subcontrol) + ")"
            } else {
                modifiedControl = control
            }
        }
        
        let fullURL = baseURL + modifiedControl

        let headers = ["Accept": "application/json"]
//        print(fullURL)
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
//                        print(String(data: dataReturn!, encoding: String.Encoding.utf8))
                        if let decoded5Control = try? decoder.decode(controlDataFive.self, from: dataReturn!) {
                            print(decoded5Control.control.title)
                            var guidance: String?
                            for part in decoded5Control.control.parts {
                                if part.label == "item", let prepend = part.prepend, let prose = part.prose {
                                    print(prepend + " " + prose.replacingOccurrences(of: "\n                     ", with: ""))
                                }
                                if part.label == "statement", let prose = part.prose {
                                    print(prose.replacingOccurrences(of: "\n                     ", with: ""))
                                }
                                if part.label == "guidance" {
                                    guidance = part.prose
                                }
                            }
                            for params in decoded5Control.control.parameters {
                                if let label = params.label, let number = params.number {
                                    print(number + "\t" + label)
                                }
                                if let number = params.number, let alternatives = params.alternatives {
                                    print(number + "\t" + alternatives.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: ", ", with: "\n\t\t").replacingOccurrences(of: "  ", with: "").replacingOccurrences(of: "\\n", with:"" ))
                                }

                            }
                            print()
                            print("------------")
                            if decoded5Control.control.is_low{
                                print("Low Baseline")
                            }
                            if decoded5Control.control.is_moderate{
                                print("Moderate Baseline")
                            }
                            if decoded5Control.control.is_high{
                                print("High Baseline")
                            }
                            if decoded5Control.control.is_privacy{
                                print("Privacy Baseline")
                            }
                            if !decoded5Control.control.is_low && !decoded5Control.control.is_moderate && !decoded5Control.control.is_high && !decoded5Control.control.is_privacy {
                                print("Not on any Baseline")
                            }
                            if showAll {
                                print("------------")
                                if let guidance = guidance {
                                    print()
                                    print(guidance)
                                }
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
