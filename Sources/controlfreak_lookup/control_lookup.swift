//
//  control_lookup.swift
//  controlfreak_lookup
//
//  Created by Bob Gendler on 9/24/20.
//  Copyright © 2020 Bob Gendler. All rights reserved.
//

import Foundation

// #if os(Linux)
// import FoundationNetworking
// #endif
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


class ControlLookup {

    
    //rev 5 lookup method
    func lookup5(control: String, _ showAll: Bool = false) {
        var modifiedControl = ""
        let baseURL = "https://controlfreak.risk-redux.io/controls/"
        modifiedControl = control.replacingOccurrences(of: " ", with: ""    )
        
        
        let family = modifiedControl.components(separatedBy: "-")[0]
        if modifiedControl.contains("("){
            var base = modifiedControl.components(separatedBy: "(")[0].components(separatedBy: "-")[1]
            var enhancement = modifiedControl.components(separatedBy: "(")[1].components(separatedBy:")")[0]
            if base.count <= 2 {
                base = "0\(base)"
            }
            modifiedControl = "\(family)-\(base)"
            if enhancement != "" {
                if enhancement.count < 2 {
                    enhancement = "0\(enhancement)"
                }
            modifiedControl = "\(family)-\(base)(\(enhancement))"
            }
        }
        
        
        let fullURL = baseURL + modifiedControl
        print(fullURL)
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
