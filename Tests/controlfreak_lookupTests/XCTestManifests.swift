import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(controlfreak_lookupTests.allTests),
    ]
}
#endif
