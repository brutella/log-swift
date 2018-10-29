import XCTest

import LoggerTests

var tests = [XCTestCaseEntry]()
tests += LoggerTests.allTests()
XCTMain(tests)