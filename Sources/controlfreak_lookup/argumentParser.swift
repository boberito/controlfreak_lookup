

import Foundation
import ArgumentParser


var controlfreak = ControlLookup()

enum Revision: String, ExpressibleByArgument {
    case r4, r5
}

struct Args: ParsableCommand {
    
    @Argument(help: ArgumentHelp("NIST 800-53 Revision, r4 or r5", valueName: "r4 or r5")) var rev: Revision
    @Argument(help: "800-53 control") var control:String
    @Flag var showAll = false
    
    func run() throws {
        switch rev {
        case .r4:
            controlfreak.lookup(control: control.uppercased(), showAll)
        case .r5:
            controlfreak.lookup5(control: control.uppercased(), showAll)
        }
    }
}
