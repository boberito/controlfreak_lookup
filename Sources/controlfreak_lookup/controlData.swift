//
//  controlData.swift
//  controlfreak_lookup
//
//  Created by Bob Gendler on 9/24/20.
//  Copyright © 2020 Bob Gendler. All rights reserved.
//


import Foundation

struct controlData: Decodable {
    let control: ControlInfo
    
    struct ControlInfo: Decodable {
        let family_name: String
        let number: String
        let title: String
        let is_baseline_impact_low: Bool
        let is_baseline_impact_moderate: Bool
        let is_baseline_impact_high: Bool
        
        let statements: [Statements]
        struct Statements: Decodable {
            let number: String
            let description: String
        }
    }
}
