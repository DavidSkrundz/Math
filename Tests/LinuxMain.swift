//
//  LinuxMain.swift
//  Math
//

import XCTest
@testable import MathTests

XCTMain([
	testCase(ByteTests.allTests.shuffled()),
	testCase(ModTests.allTests.shuffled()),
	testCase(RotationTests.allTests.shuffled()),
	testCase(HexStringTests.allTests.shuffled()),
	testCase(ByteMergingTests.allTests.shuffled()),
	testCase(BitPackingTests.allTests.shuffled()),
	testCase(FiniteFieldIntegerTests.allTests.shuffled()),
	testCase(BigIntTests.allTests.shuffled()),
])
