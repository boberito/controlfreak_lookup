//
//  main.swift
//  controlfreak_lookup
//
//  Created by Bob Gendler on 9/24/20.
//  Copyright © 2020 Bob Gendler. All rights reserved.
//

import Foundation


let arguments = CommandLine.arguments
var controlfreak = ControlLookup()

if arguments.count < 2 {
    print("The following arguments are required: control")
    exit(0)
}

if arguments[1] == "-h" {
    print("Enter an 800-53r4 control to see if it's description and if it's on a baseline")
    exit(0)
}

controlfreak.lookup(control: arguments[1])
