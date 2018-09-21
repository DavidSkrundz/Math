//
//  HexStringTests.swift
//  MathTests
//

import XCTest
import Math

final class HexStringTests: XCTestCase {
	func testSingleByte() {
		XCTAssertEqual([0].hexString, "00")
		XCTAssertEqual([1].hexString, "01")
		XCTAssertEqual([20].hexString, "14")
		XCTAssertEqual([80].hexString, "50")
		XCTAssertEqual([160].hexString, "a0")
		XCTAssertEqual([200].hexString, "c8")
		XCTAssertEqual([255].hexString, "ff")
	}
	
	func testMultipleBytes() {
		XCTAssertEqual([0,1,20,80,160,200,255].hexString, "00011450a0c8ff")
	}
}

extension HexStringTests: TestCase {
	static var allTests = [
		("testSingleByte", testSingleByte),
		("testMultipleBytes", testMultipleBytes),
	]
}
