//
//  RotationTests.swift
//  MathTests
//

import XCTest
import Math

final class RotationTests: XCTestCase {
	func testLeftRotation() {
		AssertEqualLSUInt8("00000001", 1, "00000010")
		AssertEqualLSUInt8("00001110", 2, "00111000")
		AssertEqualLSUInt8("00000001", 3, "00001000")
		AssertEqualLSUInt8("10000000", 1, "00000001")
		AssertEqualLSUInt8("10101010", 5, "01010101")
		
		AssertEqualLSInt8("00000001", 1, "00000010")
		AssertEqualLSInt8("00001110", 2, "00111000")
		AssertEqualLSInt8("00000001", 3, "00001000")
		AssertEqualLSInt8("10000000", 1, "00000001")
		AssertEqualLSInt8("10101010", 5, "01010101")
	}
	
	func testRightRotation() {
		AssertEqualRSUInt8("00000001", 1, "10000000")
		AssertEqualRSUInt8("00001110", 2, "10000011")
		AssertEqualRSUInt8("00000001", 3, "00100000")
		AssertEqualRSUInt8("10000000", 1, "01000000")
		AssertEqualRSUInt8("10101010", 5, "01010101")
		
		AssertEqualRSInt8("00000001", 1, "10000000")
		AssertEqualRSInt8("00001110", 2, "10000011")
		AssertEqualRSInt8("00000001", 3, "00100000")
		AssertEqualRSInt8("10000000", 1, "01000000")
		AssertEqualRSInt8("10101010", 5, "01010101")
	}
	
	func testLeftNegativeRotation() {
		AssertEqualLSUInt8("00000001", -1, "10000000")
		AssertEqualLSUInt8("00001110", -2, "10000011")
		AssertEqualLSUInt8("00000001", -3, "00100000")
		AssertEqualLSUInt8("10000000", -1, "01000000")
		AssertEqualLSUInt8("10101010", -5, "01010101")
		
		AssertEqualLSInt8("00000001", -1, "10000000")
		AssertEqualLSInt8("00001110", -2, "10000011")
		AssertEqualLSInt8("00000001", -3, "00100000")
		AssertEqualLSInt8("10000000", -1, "01000000")
		AssertEqualLSInt8("10101010", -5, "01010101")
	}
	
	func testRightNegativeRotation() {
		AssertEqualRSUInt8("00000001", -1, "00000010")
		AssertEqualRSUInt8("00001110", -2, "00111000")
		AssertEqualRSUInt8("00000001", -3, "00001000")
		AssertEqualRSUInt8("10000000", -1, "00000001")
		AssertEqualRSUInt8("10101010", -5, "01010101")
		
		AssertEqualRSInt8("00000001", -1, "00000010")
		AssertEqualRSInt8("00001110", -2, "00111000")
		AssertEqualRSInt8("00000001", -3, "00001000")
		AssertEqualRSInt8("10000000", -1, "00000001")
		AssertEqualRSInt8("10101010", -5, "01010101")
	}
	
	func testLeftOverRotation() {
		AssertEqualLSUInt8("00000001", 9, "00000010")
		AssertEqualLSUInt8("00001110", 10, "00111000")
		AssertEqualLSUInt8("00000001", 11, "00001000")
		AssertEqualLSUInt8("10000000", -7, "00000001")
		AssertEqualLSUInt8("10101010", -3, "01010101")
		
		AssertEqualLSInt8("00000001", 17, "00000010")
		AssertEqualLSInt8("00001110", 10, "00111000")
		AssertEqualLSInt8("00000001", -5, "00001000")
		AssertEqualLSInt8("10000000", -7, "00000001")
		AssertEqualLSInt8("10101010", -3, "01010101")
	}
	
	func testRightOverRotation() {
		AssertEqualRSUInt8("00000001", 9, "10000000")
		AssertEqualRSUInt8("00001110", 10, "10000011")
		AssertEqualRSUInt8("00000001", 11, "00100000")
		AssertEqualRSUInt8("10000000", -7, "01000000")
		AssertEqualRSUInt8("10101010", -3, "01010101")
		
		AssertEqualRSInt8("00000001", 17, "10000000")
		AssertEqualRSInt8("00001110", 10, "10000011")
		AssertEqualRSInt8("00000001", -5, "00100000")
		AssertEqualRSInt8("10000000", -7, "01000000")
		AssertEqualRSInt8("10101010", -3, "01010101")
	}
	
	func testUInt64() {
		let input = UInt64("0101011111101000101100101111011111011000100100101100111010010000", radix: 2)!
		let r7Out = UInt64("0010000010101111110100010110010111101111101100010010010110011101", radix: 2)!
		let L7Out = UInt64("1111010001011001011110111110110001001001011001110100100000101011", radix: 2)!
		XCTAssertEqual(input >>> Int8(7), r7Out)
		XCTAssertEqual(input <<< Int8(7), L7Out)
	}
}

extension RotationTests: TestCase {
	static var allTests = [
		("testLeftRotation", testLeftRotation),
		("testRightRotation", testRightRotation),
		("testLeftNegativeRotation", testLeftNegativeRotation),
		("testRightNegativeRotation", testRightNegativeRotation),
		("testLeftOverRotation", testLeftOverRotation),
		("testRightOverRotation", testRightOverRotation),
		("testUInt64", testUInt64),
	]
}

private func AssertEqualLSInt8(_ input: String, _ shift: Int, _ result: String,
							   _ message: @autoclosure () -> String = "",
							   file: StaticString = #file,
							   line: UInt = #line) {
	let input = Int8(bitPattern: UInt8(input, radix: 2)!)
	let result = Int8(bitPattern: UInt8(result, radix: 2)!)
	AssertEqualLS(input, shift, result, message, file: file, line: line)
}

private func AssertEqualLSUInt8(_ input: String, _ shift: Int, _ result: String,
								_ message: @autoclosure () -> String = "",
								file: StaticString = #file,
								line: UInt = #line) {
	let input = UInt8(input, radix: 2)!
	let result = UInt8(result, radix: 2)!
	AssertEqualLS(input, shift, result, message, file: file, line: line)
}

private func AssertEqualLS<T>(_ input: T, _ shift: Int, _ result: T,
							  _ message: @autoclosure () -> String = "",
							  file: StaticString = #file,
							  line: UInt = #line) where T: BinaryInteger {
	XCTAssertEqual(input <<< shift, result, message, file: file, line: line)
}

private func AssertEqualRSInt8(_ input: String, _ shift: Int, _ result: String,
							   _ message: @autoclosure () -> String = "",
							   file: StaticString = #file,
							   line: UInt = #line) {
	let input = Int8(bitPattern: UInt8(input, radix: 2)!)
	let result = Int8(bitPattern: UInt8(result, radix: 2)!)
	AssertEqualRS(input, shift, result, message, file: file, line: line)
}

private func AssertEqualRSUInt8(_ input: String, _ shift: Int, _ result: String,
								_ message: @autoclosure () -> String = "",
								file: StaticString = #file,
								line: UInt = #line) {
	let input = UInt8(input, radix: 2)!
	let result = UInt8(result, radix: 2)!
	AssertEqualRS(input, shift, result, message, file: file, line: line)
}

private func AssertEqualRS<T>(_ input: T, _ shift: Int, _ result: T,
							  _ message: @autoclosure () -> String = "",
							  file: StaticString = #file,
							  line: UInt = #line) where T: BinaryInteger {
	XCTAssertEqual(input >>> shift, result, message, file: file, line: line)
}
