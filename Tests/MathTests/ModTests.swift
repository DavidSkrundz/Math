//
//  ModTests.swift
//  MathTests
//

import XCTest
import Math

final class ModTests: XCTestCase {
	func testModInt8() {
		for a in Int8.min...Int8.max {
			printProgress(at: a)
			for m in 1...Int8.max {
				if a < 0 {
					XCTAssertEqual(a.modulo(m), ((a % m) + m) % m, "\(a) mod \(m)")
				} else {
					XCTAssertEqual(a.modulo(m), a % m, "\(a) mod \(m)")
				}
			}
		}
	}
	
	func testModUInt8() {
		for a in UInt8.min...UInt8.max {
			printProgress(at: a)
			for m in 1...UInt8.max {
				XCTAssertEqual(a.modulo(m), a % m, "\(a) mod \(m)")
			}
		}
	}
	
	func testAddingInt8() {
		for a in Int8.min...Int8.max {
			printProgress(at: a)
			for b in Int8.min...Int8.max {
				for m in 1...Int8.max {
					XCTAssertEqual(a.adding(b, modulo: m), Int8((Int(a) + Int(b)).modulo(Int(m))), "\(a) + \(b) mod \(m)")
				}
			}
		}
	}
	
	func testAddingUInt8() {
		for a in UInt8.min...UInt8.max {
			printProgress(at: a)
			for b in UInt8.min...UInt8.max {
				for m in 1...UInt8.max {
					XCTAssertEqual(a.adding(b, modulo: m), UInt8((Int(a) + Int(b)).modulo(Int(m))), "\(a) + \(b) mod \(m)")
				}
			}
		}
	}
	
	func testSubtractingInt8() {
		for a in Int8.min...Int8.max {
			printProgress(at: a)
			for b in Int8.min...Int8.max {
				for m in 1...Int8.max {
					XCTAssertEqual(a.subtracting(b, modulo: m), Int8((Int(a) - Int(b)).modulo(Int(m))), "\(a) - \(b) mod \(m)")
				}
			}
		}
	}
	
	func testSubtractingUInt8() {
		for a in UInt8.min...UInt8.max {
			printProgress(at: a)
			for b in UInt8.min...UInt8.max {
				for m in 1...UInt8.max {
					XCTAssertEqual(a.subtracting(b, modulo: m), UInt8((Int(a) - Int(b)).modulo(Int(m))), "\(a) - \(b) mod \(m)")
				}
			}
		}
	}
	
	func testMultiplyingInt8() {
		for a in Int8.min...Int8.max {
			printProgress(at: a)
			for b in Int8.min...Int8.max {
				for m in 1...Int8.max {
					XCTAssertEqual(a.multiplying(b, modulo: m), Int8((Int(a) * Int(b)).modulo(Int(m))), "\(a) * \(b) mod \(m)")
				}
			}
		}
	}
	
	func testMultiplyingUInt8() {
		for a in UInt8.min...UInt8.max {
			printProgress(at: a)
			for b in UInt8.min...UInt8.max {
				for m in 1...UInt8.max {
					XCTAssertEqual(a.multiplying(b, modulo: m), UInt8((Int(a) * Int(b)).modulo(Int(m))), "\(a) * \(b) mod \(m)")
				}
			}
		}
	}
	
	func testExponentiatingInt8() {
		// A subset of the full range that only includes the edges
		let edges = [
			Int8.min, Int8.min+1, Int8.min+2, Int8.min+3,
			Int8.max-3, Int8.max-2, Int8.max-1, Int8.max
		]
		for a in edges {
			for b in edges {
				for m in 1...Int8.max {
					_ = a.exponentiating(by: b, modulo: m)
				}
			}
		}
		
		XCTAssertEqual(Int8(66).exponentiating(by: 22, modulo: 88), 0)
		XCTAssertEqual(Int8(46).exponentiating(by: 114, modulo: 120), 16)
		XCTAssertEqual(Int8(112).exponentiating(by: 22, modulo: 45), 4)
		XCTAssertEqual(Int8(-54).exponentiating(by: 80, modulo: 78), 48)
		XCTAssertEqual(Int8(112).exponentiating(by: -83, modulo: 37), 1)
		XCTAssertEqual(Int8(79).exponentiating(by: -116, modulo: 94), 1)
		XCTAssertEqual(Int8(-96).exponentiating(by: -5, modulo: 94), 1)
		XCTAssertEqual(Int8(72).exponentiating(by: 117, modulo: 21), 15)
		XCTAssertEqual(Int8(20).exponentiating(by: -102, modulo: 99), 1)
		XCTAssertEqual(Int8(-55).exponentiating(by: 14, modulo: 5), 0)
	}
	
	func testExponentiatingUInt8() {
		// A subset of the full range that only includes the edges
		let edges = [
			UInt8.min, UInt8.min+1, UInt8.min+2, UInt8.min+3,
			UInt8.max-3, UInt8.max-2, UInt8.max-1, UInt8.max
		]
		for a in edges {
			for b in edges {
				for m in 1...UInt8.max {
					_ = a.exponentiating(by: b, modulo: m)
				}
			}
		}
		
		XCTAssertEqual(UInt8(250).exponentiating(by: 211, modulo: 112), 96)
		XCTAssertEqual(UInt8(212).exponentiating(by: 173, modulo: 35), 32)
		XCTAssertEqual(UInt8(23).exponentiating(by: 237, modulo: 46), 23)
		XCTAssertEqual(UInt8(232).exponentiating(by: 206, modulo: 240), 64)
		XCTAssertEqual(UInt8(80).exponentiating(by: 179, modulo: 210), 110)
		XCTAssertEqual(UInt8(3).exponentiating(by: 132, modulo: 87), 54)
		XCTAssertEqual(UInt8(219).exponentiating(by: 144, modulo: 107), 35)
		XCTAssertEqual(UInt8(104).exponentiating(by: 194, modulo: 129), 67)
		XCTAssertEqual(UInt8(234).exponentiating(by: 71, modulo: 146), 112)
		XCTAssertEqual(UInt8(220).exponentiating(by: 243, modulo: 188), 144)
	}
	
	func testInverseInt8() {
		for a in Int8.min...Int8.max {
			printProgress(at: a)
			for m in 2...Int8.max {
				if let r = a.inverse(modulo: m) {
					XCTAssertEqual(a.multiplying(r, modulo: m), 1, "\(a).inv(\(m))")
				}
			}
		}
	}
	
	func testInverseUInt8() {
		for a in UInt8.min...UInt8.max {
			printProgress(at: a)
			for m in 2...UInt8.max {
				if let r = a.inverse(modulo: m) {
					XCTAssertEqual(a.multiplying(r, modulo: m), 1, "\(a).inv(\(m))")
				}
			}
		}
	}
	
	func testGCDDecompositionInt8() {
		for a in Int8.min...Int8.max {
			printProgress(at: a)
			for b in Int8.min...Int8.max {
				let r = a.gcdDecomposition(b)
				XCTAssertEqual(r.1&*a &+ r.2&*b, r.0, "\(a).gcdD(\(b))")
			}
		}
	}
	
	func testGCDDecompositionUInt8() {
		for a in UInt8.min...UInt8.max {
			printProgress(at: a)
			for b in UInt8.min...UInt8.max {
				let r = a.gcdDecomposition(b)
				XCTAssertEqual(r.1&*a &+ r.2&*b, r.0, "\(a).gcdD(\(b))")
			}
		}
	}
}

extension ModTests: TestCase {
	static var allTests = [
		("testModInt8", testModInt8),
		("testModUInt8", testModUInt8),
		("testAddingInt8", testAddingInt8),
		("testAddingUInt8", testAddingUInt8),
		("testSubtractingInt8", testSubtractingInt8),
		("testSubtractingUInt8", testSubtractingUInt8),
		("testMultiplyingInt8", testMultiplyingInt8),
		("testMultiplyingUInt8", testMultiplyingUInt8),
		("testExponentiatingInt8", testExponentiatingInt8),
		("testExponentiatingUInt8", testExponentiatingUInt8),
		("testInverseInt8", testInverseInt8),
		("testInverseUInt8", testInverseUInt8),
		("testGCDDecompositionInt8", testGCDDecompositionInt8),
		("testGCDDecompositionUInt8", testGCDDecompositionUInt8),
	]
}

@_specialize(where T == Int8)
@_specialize(where T == UInt8)
@inline(__always)
private func printProgress<T: BinaryInteger>(at value: T) {
	if value.modulo(50) == 0 {
		print("Progress: \(value)...")
	}
}
