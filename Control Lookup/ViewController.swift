//
//  ViewController.swift
//  Control Lookup
//
//  Created by Bob Gendler on 11/11/20.
//

import Cocoa
import CoreSpotlight
import os

class ViewController: NSViewController {

    var listOfControls = [controlList]()
    
    
    override func viewDidAppear() {
        print(listOfControls.count)
        
        for (index, control) in listOfControls.enumerated() {
                let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            attributeSet.title = control.control.title
            attributeSet.contentDescription = control.control.label
            

                let item = CSSearchableItem(uniqueIdentifier: "\(index)", domainIdentifier: "com.controlfreak_lookup", attributeSet: attributeSet)
                CSSearchableIndex.default().indexSearchableItems([item]) { error in
                    if let error = error {
                        print("Indexing error: \(error.localizedDescription)")
                    } else {
                        if let label = control.control.label {
                            NSLog("\(control.control.title) and \(label) Search item successfully indexed!")
                        }
                        
                    }
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let fileURL = Bundle.main.url(forResource: "800-53r5", withExtension: "json") {
            if let fileContents = try? Data(contentsOf: fileURL) {
                let decoder = JSONDecoder()
                if let decodedList = try? decoder.decode([controlList].self, from: fileContents) {
                    listOfControls.append(contentsOf: decodedList)
                } else {
                    print("failed json")
                }
            } else {
                print("failed file read")
            }
        } else {
            print("didnt find file")
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

