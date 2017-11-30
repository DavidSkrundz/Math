//
//  LinuxMain.swift
//  Math
//

import XCTest
@testable import MathTests

XCTMain([
	testCase(ByteTests.allTests),
	testCase(ModTests.allTests),
	testCase(RotationTests.allTests),
	testCase(HexStringTests.allTests),
	testCase(ByteMergingTests.allTests),
	testCase(BitPackingTests.allTests),
])
