//
//  SquareRootTests.swift
//  MathTests
//

import XCTest
import Math

final class SquareRootTests: XCTestCase {
	func testSqrtInt8() {
		XCTAssertEqual(Int8(0).sqrt(), 0, "sqrt(0)")
		print(Int8(64).sqrt())
loop:	for i in 1..<Int8.max {
			let s = i.sqrt()
			var j = i
			for _ in 0..<s {
				if j >= s { j -= s }
				else { XCTFail("sqrt is too big (\(i))"); continue loop }
			}
			XCTAssertEqual(s*s + j, i, "sqrt(\(i))")
		}
	}
	
	func testSqrtUInt8() {
		XCTAssertEqual(UInt8(0).sqrt(), 0, "sqrt(0)")
loop:	for i in 1..<UInt8.max {
			let s = i.sqrt()
			var j = i
			for _ in 0..<s {
				if j >= s { j -= s }
				else { XCTFail("sqrt is too big (\(i))"); continue loop }
			}
			XCTAssertEqual(s*s + j, i, "sqrt(\(i))")
		}
	}
	
	func testSqrtBigUInt() {
		XCTAssertEqual(BigUInt(0).sqrt(), 0, "sqrt(0)")
		let square = BigUInt(2).power(of: 500)
		let root = square.sqrt()
		XCTAssertEqual(root, BigUInt(2).power(of: 250))
		XCTAssertEqual(root * root, square)
	}
}

extension SquareRootTests: TestCase {
	static var allTests = [
		("testSqrtInt8", testSqrtInt8),
		("testSqrtUInt8", testSqrtUInt8),
		("testSqrtBigUInt", testSqrtBigUInt),
	]
}
