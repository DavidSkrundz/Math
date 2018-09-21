//
//  ByteMerginTests.swift
//  MathTests
//

import XCTest
import Math

final class ByteMergingTests: XCTestCase {
	func testMerge8To16() {
		let source1: [Int8] = [-128, 0]
		let result1_l: [Int16] = [128]
		let result1_b: [Int16] = [-32768]
		XCTAssertEqual(source1.asLittleEndian(), result1_l)
		XCTAssertEqual(source1.asBigEndian(), result1_b)
		
		let source2: [UInt8] = [167, 61]
		let result2_l: [Int16] = [15783]
		let result2_b: [Int16] = [-22723]
		XCTAssertEqual(source2.asLittleEndian(), result2_l)
		XCTAssertEqual(source2.asBigEndian(), result2_b)
	}
	
	func testMerge8To32() {
		let source1: [Int8] = [-40, 3, 42, 102]
		let result1_l: [UInt32] = [1714029528]
		let result1_b: [Int32] = [-670881178]
		XCTAssertEqual(source1.asLittleEndian(), result1_l)
		XCTAssertEqual(source1.asBigEndian(), result1_b)
		
		let source2: [UInt8] = [216, 3, 42, 102]
		let result2_l: [UInt32] = [1714029528]
		let result2_b: [UInt32] = [3624086118]
		XCTAssertEqual(source2.asLittleEndian(), result2_l)
		XCTAssertEqual(source2.asBigEndian(), result2_b)
	}
	
	func testMerge16To32() {
		let source1: [Int16] = [-3104, -8956]
		let result1_l: [UInt32] = [3708089312]
		let result1_b: [Int32] = [-203367164]
		XCTAssertEqual(source1.asLittleEndian(), result1_l)
		XCTAssertEqual(source1.asBigEndian(), result1_b)
		
		let source2: [UInt16] = [62432, 56580]
		let result2_l: [UInt32] = [3708089312]
		let result2_b: [UInt32] = [4091600132]
		XCTAssertEqual(source2.asLittleEndian(), result2_l)
		XCTAssertEqual(source2.asBigEndian(), result2_b)
	}
	
	func testMerge8To64() {
		let source1: [Int8] = [104, -109, -106, 117, -125, 72, 86, 118]
		let result1_l: [UInt64] = [8527082673923330920]
		let result1_b: [Int64] = [7535532032978867830]
		XCTAssertEqual(source1.asLittleEndian(), result1_l)
		XCTAssertEqual(source1.asBigEndian(), result1_b)
		
		let source2: [UInt8] = [104, 147, 150, 117, 131, 72, 86, 118]
		let result2_l: [UInt64] = [8527082673923330920]
		let result2_b: [UInt64] = [7535532032978867830]
		XCTAssertEqual(source2.asLittleEndian(), result2_l)
		XCTAssertEqual(source2.asBigEndian(), result2_b)
	}
	
	func testMerge8To16Padding() {
		let source1: [Int8] = [104]
		let result1_l: [Int16] = [104]
		let result1_b: [Int16] = [26624]
		XCTAssertEqual(source1.asLittleEndian(), result1_l)
		XCTAssertEqual(source1.asBigEndian(), result1_b)
		
		let source2: [UInt8] = [104]
		let result2_l: [Int16] = [104]
		let result2_b: [Int16] = [26624]
		XCTAssertEqual(source2.asLittleEndian(), result2_l)
		XCTAssertEqual(source2.asBigEndian(), result2_b)
	}
}

extension ByteMergingTests: TestCase {
	static var allTests = [
		("testMerge8To16", testMerge8To16),
		("testMerge8To32", testMerge8To32),
		("testMerge16To32", testMerge16To32),
		("testMerge8To64", testMerge8To64),
		("testMerge8To16Padding", testMerge8To16Padding),
	]
}
