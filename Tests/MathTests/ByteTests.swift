//
//  ByteTests.swift
//  MathTests
//

import XCTest
import Math

final class ByteTests: XCTestCase {
	func testLitteEndian() {
		XCTAssertEqual(Int8(-128).littleEndianBytes, [UInt8(128)])
		XCTAssertEqual(UInt8(34).littleEndianBytes, [UInt8(34)])
		XCTAssertEqual(Int16(-324).littleEndianBytes, [UInt8(188), UInt8(254)])
		XCTAssertEqual(UInt16(324).littleEndianBytes, [UInt8(68), UInt8(1)])
		let a: [UInt8] = [132, 8, 255, 255]
		XCTAssertEqual(Int32(-63356).littleEndianBytes, a)
		let b: [UInt8] = [124, 247, 0, 0]
		XCTAssertEqual(UInt32(63356).littleEndianBytes, b)
		let c: [UInt8] = [112, 49, 109, 39, 8, 77, 23, 168]
		XCTAssertEqual(Int64(-6334509653456768656).littleEndianBytes, c)
		let d: [UInt8] = [144, 206, 146, 216, 247, 178, 232, 87]
		XCTAssertEqual(UInt64(6334509653456768656).littleEndianBytes, d)
	}
	
	func testBigEndian() {
		XCTAssertEqual(Int8(-128).bigEndianBytes, [UInt8(128)])
		XCTAssertEqual(UInt8(34).bigEndianBytes, [UInt8(34)])
		XCTAssertEqual(Int16(-324).bigEndianBytes, [UInt8(254), UInt8(188)])
		XCTAssertEqual(UInt16(324).bigEndianBytes, [UInt8(1), UInt8(68)])
		let a: [UInt8] = [255, 255, 8, 132]
		XCTAssertEqual(Int32(-63356).bigEndianBytes, a)
		let b: [UInt8] = [0, 0, 247, 124]
		XCTAssertEqual(UInt32(63356).bigEndianBytes, b)
		let c: [UInt8] = [168, 23, 77, 8, 39, 109, 49, 112]
		XCTAssertEqual(Int64(-6334509653456768656).bigEndianBytes, c)
		let d: [UInt8] = [87, 232, 178, 247, 216, 146, 206, 144]
		XCTAssertEqual(UInt64(6334509653456768656).bigEndianBytes, d)
	}
}

extension ByteTests: TestCase {
	static var allTests = [
		("testLitteEndian", testLitteEndian),
		("testBigEndian", testBigEndian),
	]
}
