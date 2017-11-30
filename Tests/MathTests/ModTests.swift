//
//  ModTests.swift
//  MathTests
//

import XCTest
import Math

class ModTests: XCTestCase {
	func testModInt8() {
		for a in Int8.min...Int8.max {
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
			for m in 1...UInt8.max {
				XCTAssertEqual(a.modulo(m), a % m, "\(a) mod \(m)")
			}
		}
	}
	
	func testAddingInt8() {
		for a in Int8.min...Int8.max {
			for b in Int8.min...Int8.max {
				for m in 1...Int8.max {
					XCTAssertEqual(a.adding(b, modulo: m), Int8((Int(a) + Int(b)).modulo(Int(m))), "\(a) + \(b) mod \(m)")
				}
			}
		}
	}
	
	func testAddingUInt8() {
		for a in UInt8.min...UInt8.max {
			for b in UInt8.min...UInt8.max {
				for m in 1...UInt8.max {
					XCTAssertEqual(a.adding(b, modulo: m), UInt8((Int(a) + Int(b)).modulo(Int(m))), "\(a) + \(b) mod \(m)")
				}
			}
		}
	}
	
	func testSubtractingInt8() {
		for a in Int8.min...Int8.max {
			for b in Int8.min...Int8.max {
				for m in 1...Int8.max {
					XCTAssertEqual(a.subtracting(b, modulo: m), Int8((Int(a) - Int(b)).modulo(Int(m))), "\(a) - \(b) mod \(m)")
				}
			}
		}
	}
	
	func testSubtractingUInt8() {
		for a in UInt8.min...UInt8.max {
			for b in UInt8.min...UInt8.max {
				for m in 1...UInt8.max {
					XCTAssertEqual(a.subtracting(b, modulo: m), UInt8((Int(a) - Int(b)).modulo(Int(m))), "\(a) - \(b) mod \(m)")
				}
			}
		}
	}
	
	func testMultiplyingInt8() {
		for a in Int8.min...Int8.max {
			for b in Int8.min...Int8.max {
				for m in 1...Int8.max {
					XCTAssertEqual(a.multiplying(b, modulo: m), Int8((Int(a) * Int(b)).modulo(Int(m))), "\(a) * \(b) mod \(m)")
				}
			}
		}
	}
	
	func testMultiplyingUInt8() {
		for a in UInt8.min...UInt8.max {
			for b in UInt8.min...UInt8.max {
				for m in 1...UInt8.max {
					XCTAssertEqual(a.multiplying(b, modulo: m), UInt8((Int(a) * Int(b)).modulo(Int(m))), "\(a) * \(b) mod \(m)")
				}
			}
		}
	}
	
	func testExponentiatingInt8() {
		for a in Int8.min...Int8.max {
			for b in Int8.min...Int8.max {
				for m in 1...Int8.max {
					_ = a.exponentiating(by: b, modulo: m)
				}
			}
		}
	}
	
	func testExponentiatingUInt8() {
		for a in UInt8.min...UInt8.max {
			for b in UInt8.min...UInt8.max {
				for m in 1...UInt8.max {
					_ = a.exponentiating(by: b, modulo: m)
				}
			}
		}
	}
	
	func testInverseInt8() {
		for a in Int8.min...Int8.max {
			for m in 2...Int8.max {
				if let r = a.inverse(modulo: m) {
					XCTAssertEqual(a.multiplying(r, modulo: m), 1, "\(a).inv(\(m))")
				}
			}
		}
	}
	
	func testInverseUInt8() {
		for a in UInt8.min...UInt8.max {
			for m in 2...UInt8.max {
				if let r = a.inverse(modulo: m) {
					XCTAssertEqual(a.multiplying(r, modulo: m), 1, "\(a).inv(\(m))")
				}
			}
		}
	}
	
	func testGCDDecompositionInt8() {
		for a in Int8.min...Int8.max {
			for b in Int8.min...Int8.max {
				let r = a.gcdDecomposition(b)
				XCTAssertEqual(r.1&*a &+ r.2&*b, r.0, "\(a).gcdD(\(b))")
			}
		}
	}
	
	func testGCDDecompositionUInt8() {
		for a in UInt8.min...UInt8.max {
			for b in UInt8.min...UInt8.max {
				let r = a.gcdDecomposition(b)
				XCTAssertEqual(r.1&*a &+ r.2&*b, r.0, "\(a).gcdD(\(b))")
			}
		}
	}
	
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
