//
//  LinuxMain.swift
//  Math
//

import XCTest
@testable import MathTests

#if swift(>=4.2)
#else
import Glibc

srand(UInt32(time(nil)))

extension MutableCollection {
	mutating func shuffle() {
		guard self.count > 1 else { return }
		for (firstUnshuffled, unshuffledCount) in zip(self.indices, stride(from: self.count, to: 1, by: -1)) {
			#if swift(>=4.1)
			let d: Int = numericCast(random() % numericCast(unshuffledCount))
			#else
			let d: IndexDistance = numericCast(random() % numericCast(unshuffledCount))
			#endif
			guard d != 0 else { continue }
			let i = self.index(firstUnshuffled, offsetBy: d)
			self.swapAt(firstUnshuffled, i)
		}
	}
}

extension Sequence {
	func shuffled() -> [Iterator.Element] {
		var result = Array(self)
		result.shuffle()
		return result
	}
}
#endif

XCTMain([
	testCase(ByteTests.allTests.shuffled()),
	testCase(ModTests.allTests.shuffled()),
	testCase(RotationTests.allTests.shuffled()),
	testCase(HexStringTests.allTests.shuffled()),
	testCase(ByteMergingTests.allTests.shuffled()),
	testCase(BitPackingTests.allTests.shuffled()),
])
