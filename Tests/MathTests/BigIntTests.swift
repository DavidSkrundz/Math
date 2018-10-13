//
//  BigIntTests.swift
//  MathTests
//

import XCTest
import Math

final class BigIntTests: XCTestCase {
	func testUnsignedInitTrim() {
		XCTAssertEqual(BigUInt(words: [0,0,0,0,0]).words, [0])
		XCTAssertEqual(BigUInt(words: [0,1,0,0,0]).words, [0,1])
		XCTAssertEqual(BigUInt(words: [0,0,0,0,1]).words, [0,0,0,0,1])
	}
	
	func testUnsignedStringConversion() {
		let string = "245436734638587562330084522450672087566546356742200100037"
		guard let number = BigUInt(string) else { XCTFail(); return }
		XCTAssertEqual(number.description, string)
	}
	
	func testUnsignedEquality() {
		XCTAssertEqual(BigUInt(integerLiteral: 3), BigUInt(integerLiteral: 3))
		XCTAssertNotEqual(BigUInt(integerLiteral: 3), BigUInt(integerLiteral: 5))
	}
	
	func testUnsignedCompare() {
		XCTAssertLessThan(BigUInt(words: [.min]), BigUInt(words: [BigUInt.Words.Element.min+1]))
		XCTAssertLessThan(BigUInt(words: [BigUInt.Words.Element.max-1]), BigUInt(words: [BigUInt.Words.Element.max]))
		XCTAssertLessThan((BigUInt(words: [.max,.max]) + 1), BigUInt(words: [BigUInt.Words.Element.min+1,.min,1]))
	}
	
	func testUnsignedShift() {
		XCTAssertEqual(BigUInt(words: [0]) << 12, BigUInt(words: [0]))
		XCTAssertEqual(BigUInt(words: [1]) << 0, BigUInt(words: [1]))
		XCTAssertEqual(BigUInt(words: [1]) << 1, BigUInt(words: [2]))
		XCTAssertEqual(BigUInt(words: [1]) << BigUInt.Words.Element.bitWidth, BigUInt(words: [0,1]))
		
		XCTAssertEqual(BigUInt(words: [0]) >> 12, BigUInt(words: [0]))
		XCTAssertEqual(BigUInt(words: [1]) >> 0, BigUInt(words: [1]))
		XCTAssertEqual(BigUInt(words: [2]) >> 1, BigUInt(words: [1]))
		XCTAssertEqual(BigUInt(words: [0,1]) >> BigUInt.Words.Element.bitWidth, BigUInt(words: [1]))
	}
	
	func testUnsignedAddition() {
		XCTAssertEqual(BigUInt(words: [.min]).words, [.min])
		XCTAssertEqual(BigUInt(words: [.max]).words, [.max])
		XCTAssertEqual((BigUInt(words: [0]) + 1).words, [1])
		XCTAssertEqual((BigUInt(words: [.max]) + 1).words, [.min,1])
		XCTAssertEqual((BigUInt(words: [.max,.max]) + 1).words, [.min,.min,1])
		XCTAssertEqual((BigUInt(words: [.max,.max,.max]) + 1).words, [.min,.min,.min,1])
		XCTAssertEqual((BigUInt(words: [.max-BigUInt.Words.Element(1),.max]) + 1).words, [.max,.max])
	}
	
	func testUnsignedSubtraction() {
		XCTAssertEqual((BigUInt(words: [1]) - 1).words, [0])
		XCTAssertEqual((BigUInt(words: [.min,1]) - 1).words, [.max])
		XCTAssertEqual((BigUInt(words: [.min,.min,1]) - 1).words, [.max,.max])
		XCTAssertEqual((BigUInt(words: [.min,.min,.min,1]) - 1).words, [.max,.max,.max])
		XCTAssertEqual((BigUInt(words: [.max,.max]) - 1).words, [.max-BigUInt.Words.Element(1),.max])
	}
	
	func testUnsignedMultiplication() {
		XCTAssertEqual((BigUInt(words: [.min]) * 0).words, [0])
		XCTAssertEqual((BigUInt(words: [.max]) * 0).words, [0])
		XCTAssertEqual((BigUInt(words: [24]) * 2).words, [48])
		XCTAssertEqual((BigUInt(words: [.max]) * 1).words, [.max])
		XCTAssertEqual((BigUInt(words: [.max]) * 2).words, [BigUInt.Words.Element.max-1,1])
		XCTAssertEqual((BigUInt(words: [.max]) * BigUInt(words: [.max])).words, [1,BigUInt.Words.Element.max-1])
		XCTAssertEqual((BigUInt(words: [.max,.max]) * BigUInt(words: [.max,.max])).words, [1,0,BigUInt.Words.Element.max-1,.max])
	}
	
	func testUnsignedDivision() {
		XCTAssertEqual((BigUInt(words: [48]) / 2).words, [24])
		XCTAssertEqual((BigUInt(words: [.max]) / 1).words, [.max])
		XCTAssertEqual((BigUInt(words: [BigUInt.Words.Element.max-1,1]) / 2).words, [.max])
		XCTAssertEqual((BigUInt(words: [1,BigUInt.Words.Element.max-1]) / BigUInt(words: [.max])).words, [.max])
		XCTAssertEqual((BigUInt(words: [1,0,BigUInt.Words.Element.max-1,.max]) / BigUInt(words: [.max,.max])).words, [.max,.max])
	}
	
	func testUnsignedExponentiation() {
		XCTAssertEqual((BigUInt(words: [10]).power(of: 5)).words, [100000])
		XCTAssertEqual((BigUInt(words: [10]).power(of: 50)).description, "1"+String(repeating: "0", count: 50))
	}
	
	func testUnsignedRemainder() {
		XCTAssertEqual((BigUInt(words: [48]) % 2).words, [0])
		XCTAssertEqual((BigUInt(words: [.max]) % 1).words, [0])
		XCTAssertEqual((BigUInt(words: [BigUInt.Words.Element.max,1]) % 2).words, [1])
		XCTAssertEqual((BigUInt(words: [3,BigUInt.Words.Element.max-1]) % BigUInt(words: [.max])).words, [2])
		XCTAssertEqual((BigUInt(words: [10,0,.max,.max]) % BigUInt(words: [.max,.max])).words, [10])
	}
	
	func testUnsignedAnd() {
		XCTAssertEqual((BigUInt(words: [5]) & BigUInt(words: [11])).words, [1])
		XCTAssertEqual((BigUInt(words: [5]) & BigUInt(words: [7])).words, [5])
		XCTAssertEqual((BigUInt(words: [2,13]) & BigUInt(words: [4])).words, [0])
		XCTAssertEqual((BigUInt(words: [2,13]) & BigUInt(words: [11,3])).words, [2,1])
	}
	
	func testUnsignedOr() {
		XCTAssertEqual((BigUInt(words: [5]) | BigUInt(words: [11])).words, [15])
		XCTAssertEqual((BigUInt(words: [5]) | BigUInt(words: [7])).words, [7])
		XCTAssertEqual((BigUInt(words: [2,13]) | BigUInt(words: [4])).words, [6,13])
		XCTAssertEqual((BigUInt(words: [2,13]) | BigUInt(words: [11,3])).words, [11,15])
	}
	
	func testUnsignedXor() {
		XCTAssertEqual((BigUInt(words: [5]) ^ BigUInt(words: [11])).words, [14])
		XCTAssertEqual((BigUInt(words: [5]) ^ BigUInt(words: [7])).words, [2])
		XCTAssertEqual((BigUInt(words: [2,13]) ^ BigUInt(words: [4])).words, [6,13])
		XCTAssertEqual((BigUInt(words: [2,13]) ^ BigUInt(words: [11,3])).words, [9,14])
	}
	
	func testUnsignedTrailingBits() {
		XCTAssertEqual(BigUInt(words: [0]).trailingZeroBitCount, BigUInt.Words.Element.bitWidth)
		XCTAssertEqual(BigUInt(words: [1]).trailingZeroBitCount, 0)
		XCTAssertEqual(BigUInt(words: [0,1]).trailingZeroBitCount, BigUInt.Words.Element.bitWidth)
		XCTAssertEqual(BigUInt(words: [0,0,1]).trailingZeroBitCount, BigUInt.Words.Element.bitWidth * 2)
	}
	
	func testUnsignedNegate() {
		XCTAssertEqual(~BigUInt(words: [0]), BigUInt(words: [.max]))
		XCTAssertEqual(~BigUInt(words: [1]), BigUInt(words: [BigUInt.Words.Element.max-1]))
		XCTAssertEqual(~BigUInt(words: [0,0,1]), BigUInt(words: [.max,.max,BigUInt.Words.Element.max-1]))
	}
	
	func testUnsignedCoverage() {
		XCTAssertEqual(BigUInt(exactly: 1.0), BigUInt(words: [1]))
		XCTAssertEqual(BigUInt(exactly: 1.0e10), BigUInt(words: [1_00000_00000]))
		XCTAssertEqual(BigUInt(1.23456e2), BigUInt(words: [123]))
		XCTAssertEqual(BigUInt(12345e40).description.count, 5+40)
		XCTAssertEqual(BigUInt(UInt8(4)), BigUInt(words: [4]))
		XCTAssertEqual(BigUInt(clamping: UInt8(4)), BigUInt(words: [4]))
		XCTAssertEqual(BigUInt(truncatingIfNeeded: UInt8(4)), BigUInt(words: [4]))
		XCTAssertEqual(BigUInt(exactly: UInt8(4)), BigUInt(words: [4]))
		
		var a = BigUInt(3)
		a += 3
		a -= 1
		a *= 4
		a /= 5
		a %= 3
		a <<= 3
		a >>= 2
		a |= 3
		a &= 6
		a ^= 5
		XCTAssertEqual(a, 7)
	}
	
	func testRecreation() {
		let a = BigUInt("6189700642690137449562111")!
		let b = BigUInt(a)
		XCTAssertEqual(b, a)
	}
}

extension BigIntTests: TestCase {
	static var allTests = [
		("testUnsignedInitTrim", testUnsignedInitTrim),
		("testUnsignedStringConversion", testUnsignedStringConversion),
		("testUnsignedEquality", testUnsignedEquality),
		("testUnsignedCompare", testUnsignedCompare),
		("testUnsignedShift", testUnsignedShift),
		("testUnsignedAddition", testUnsignedAddition),
		("testUnsignedSubtraction", testUnsignedSubtraction),
		("testUnsignedMultiplication", testUnsignedMultiplication),
		("testUnsignedDivision", testUnsignedDivision),
		("testUnsignedExponentiation", testUnsignedExponentiation),
		("testUnsignedRemainder", testUnsignedRemainder),
		("testUnsignedAnd", testUnsignedAnd),
		("testUnsignedOr", testUnsignedOr),
		("testUnsignedXor", testUnsignedXor),
		("testUnsignedTrailingBits", testUnsignedTrailingBits),
		("testUnsignedNegate", testUnsignedNegate),
		("testUnsignedCoverage", testUnsignedCoverage),
		("testRecreation", testRecreation),
	]
}
