//
//  TestCount.swift
//  MathTests
//

import XCTest

protocol TestCase {
	static var allTests: [(String, (Self) -> () -> ())] { get }
}

#if os(macOS)

final class TestCount: XCTestCase {
	func testTestCount() {
		AssertTestCount(ByteTests.self)
		AssertTestCount(ModTests.self)
		AssertTestCount(RotationTests.self)
		AssertTestCount(HexStringTests.self)
		AssertTestCount(ByteMergingTests.self)
		AssertTestCount(BitPackingTests.self)
		AssertTestCount(FiniteFieldIntegerTests.self)
		AssertTestCount(BigIntTests.self)
		AssertTestCount(SquareRootTests.self)
	}
}

func AssertTestCount<T: XCTestCase & TestCase>(_ T: T.Type) {
	let allTestsCount = T.allTests.count
	let testCount = T.defaultTestSuite.testCaseCount
	let difference = testCount - allTestsCount
	XCTAssertEqual(allTestsCount, testCount,
				   "\(difference) tests are missing from \(String(describing: T)).allTests")
}

#endif
