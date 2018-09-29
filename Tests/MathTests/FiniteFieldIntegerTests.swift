//
//  FiniteFieldIntegerTests.swift
//  MathTests
//

import XCTest
import Math

struct F_31: FiniteFieldInteger {
	static var Order = UInt8(31)
	var value: Element = 0
}

final class FiniteFieldIntegerTests: XCTestCase {
	func testInitMod() {
		for i in 0..<31 {
			XCTAssertEqual(F_31(UInt8(i)).value, UInt8(i))
		}
		for i in 31..<50 {
			XCTAssertEqual(F_31(UInt8(i)).value, UInt8(i - 31))
		}
	}
	
	func testInitString() {
		for i in 0..<31 {
			XCTAssertEqual(F_31("\(i)")!.value, UInt8(i))
			XCTAssertEqual(F_31("\(i)")!.description, "\(i)")
		}
		for i in 31..<50 {
			XCTAssertEqual(F_31("\(i)")!.value, UInt8(i - 31))
			XCTAssertEqual(F_31("\(i)")!.description, "\(i - 31)")
		}
	}
	
	func testAdding() {
		for a in 0..<40 {
			let lhs = F_31(UInt8(a))
			for b in 0..<40 {
				XCTAssertEqual((lhs + F_31(UInt8(b))).value, UInt8(a.adding(b, modulo: 31)))
			}
		}
	}

	func testSubtracting() {
		for a in 0..<40 {
			let lhs = F_31(UInt8(a))
			for b in 0..<40 {
				XCTAssertEqual((lhs - F_31(UInt8(b))).value, UInt8(a.subtracting(b, modulo: 31)))
			}
		}
	}

	func testMultiplying() {
		for a in 0..<40 {
			let lhs = F_31(UInt8(a))
			for b in 0..<40 {
				XCTAssertEqual((lhs * F_31(UInt8(b))).value, UInt8(a.multiplying(b, modulo: 31)))
			}
		}
	}

	func testDividing() {
		for a in 0..<40 {
			let lhs = F_31(UInt8(a))
			for b in 0..<40 {
				if F_31(UInt8(b)).value == 0 { continue }
				XCTAssertEqual((lhs / F_31(UInt8(b))).value, UInt8(a.multiplying(b.inverse(modulo: 31)!, modulo: 31)))
			}
		}
	}

	func testExponentiating() {
		for a in 0..<40 {
			let lhs = F_31(UInt8(a))
			for b in 0..<40 {
				XCTAssertEqual(lhs.exponentiating(by: UInt8(b)).value, UInt8(a.exponentiating(by: b, modulo: 31)), "\(a) exp \(b)")
			}
		}
	}
	
	func testStride() {
		XCTAssertEqual((F_31(0)...F_31(30)).map{$0.value}, [UInt8](0..<31))
		XCTAssertEqual((F_31(10)...F_31(9)).map{$0.value}, [UInt8](10..<31) + [UInt8](0..<10))
	}
	
	func testHashing() {
		XCTAssertEqual(F_31(1).hashValue, F_31(1).hashValue)
		XCTAssertNotEqual(F_31(4).hashValue, F_31(1).hashValue)
		
		
		var hasher1 = Hasher()
		var hasher2 = Hasher()
		F_31(1).hash(into: &hasher1)
		F_31(1).hash(into: &hasher2)
		XCTAssertEqual(hasher1.finalize(), hasher2.finalize())
		
		hasher1 = Hasher()
		hasher2 = Hasher()
		F_31(1).hash(into: &hasher1)
		F_31(2).hash(into: &hasher2)
		XCTAssertNotEqual(hasher1.finalize(), hasher2.finalize())
	}
	
	func testCoverage() {
		XCTAssertNil(F_31("a"))
		XCTAssertEqual(F_31(4).advanced(by: -2), 2)
		XCTAssertEqual(F_31(6).advanced(by: -10), 27)
		XCTAssertEqual(F_31(3).magnitude, 3)
		XCTAssertEqual(F_31(exactly: UInt16(300)), 21)
		
		var a = F_31(3)
		a += 6
		a -= 1
		a *= 2
		a %= 10
		a /= 2
		XCTAssertEqual(a, 3)
	}
}

extension FiniteFieldIntegerTests: TestCase {
	static var allTests = [
		("testInitMod", testInitMod),
		("testInitString", testInitString),
		("testAdding", testAdding),
		("testSubtracting", testSubtracting),
		("testMultiplying", testMultiplying),
		("testDividing", testDividing),
		("testExponentiating", testExponentiating),
		("testStride", testStride),
		("testHashing", testHashing),
		("testCoverage", testCoverage),
	]
}
