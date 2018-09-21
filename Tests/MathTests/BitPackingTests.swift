//
//  BitPackingTests.swift
//  MathTests
//

import XCTest
import Math

final class BitPackingTests: XCTestCase {
	func testSingleByte8To2() {
		let source = [UInt8("11001001", radix: 2)!]
		let bigResult: [UInt8] = [3, 0, 2, 1]
		let littleResult: [UInt8] = [1, 2, 0, 3]
		XCTAssertEqual(source.asBigEndian(resultBits: 2), bigResult)
		XCTAssertEqual(bigResult.asBigEndian(sourceBits: 2), source)
		XCTAssertEqual(source.asLittleEndian(resultBits: 2), littleResult)
		XCTAssertEqual(littleResult.asLittleEndian(sourceBits: 2), source)
	}
	
	func testMultiByte8To3() {
		let source = [UInt8("10101011", radix: 2)!,
					  UInt8("00110001", radix: 2)!,
					  UInt8("11001100", radix: 2)!]
		let bigResult: [UInt8] = [5, 2, 6, 3, 0, 7, 1, 4]
		let littleResult: [UInt8] = [3, 5, 6, 0, 3, 0, 3, 6]
		XCTAssertEqual(source.asBigEndian(resultBits: 3), bigResult)
		XCTAssertEqual(bigResult.asBigEndian(sourceBits: 3), source)
		XCTAssertEqual(source.asLittleEndian(resultBits: 3), littleResult)
		XCTAssertEqual(littleResult.asLittleEndian(sourceBits: 3), source)
	}
}

extension BitPackingTests: TestCase {
	static var allTests = [
		("testSingleByte8To2", testSingleByte8To2),
		("testMultiByte8To3", testMultiByte8To3),
	]
}
