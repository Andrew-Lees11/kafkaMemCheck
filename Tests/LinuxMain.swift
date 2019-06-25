import XCTest

import kafkaMedLeakTests

var tests = [XCTestCaseEntry]()
tests += kafkaMedLeakTests.allTests()
XCTMain(tests)
