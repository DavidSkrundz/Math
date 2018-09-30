//
//  Array+BitPacking.swift
//  Math
//

private enum Endianness {
	case big
	case little
}

extension Array where Element: BinaryInteger {
	/// Converts an array of `BinaryInteger` from one type to another but
	/// assuming only `sourceBits` and `destinationBits` number of bits are
	/// used. Any bits above that count are ignored and lost.
	///
	/// - Precondition: `0 < sourceBits <= Element().bitWidth`
	/// - Precondition: `0 < resultBits <= T().bitWidth`
	///
	/// - Note: The sign of the input/output has no importance. Only the binary
	///         representation matters
	///
	/// - Note: Endianness is only considered in the case of multiple elements.
	///         If `self` is a `[UInt16]`, each `UInt16` is treated as a single
	///         big endian value. The result has simila
	///
	/// - Parameter sourceBits: The number of bits from each source word to use
	/// - Parameter resultBits: The number of bits in each result word to fill
	public func asBigEndian<T: BinaryInteger>(
		sourceBits: Int = Element().bitWidth,
		resultBits: Int = T().bitWidth) -> [T] {
		return self.toArray(endinanness: .big,
							sourceBits: sourceBits,
							resultBits: resultBits)
	}
	
	/// Converts an array of `BinaryInteger` from one type to another but
	/// assuming only `sourceBits` and `destinationBits` number of bits are
	/// used. Any bits above that count are ignored and lost.
	///
	/// - Precondition: `0 < sourceBits <= Element().bitWidth`
	/// - Precondition: `0 < resultBits <= T().bitWidth`
	///
	/// - Note: The sign of the input/output has no importance. Only the binary
	///         representation matters
	///
	/// - Note: Endianness is only considered in the case of multiple elements.
	///         If `self` is a `[UInt16]`, each `UInt16` is treated as a single
	///         big endian value. The result has simila
	///
	/// - Parameter sourceBits: The number of bits from each source word to use
	/// - Parameter resultBits: The number of bits in each result word to fill
	public func asLittleEndian<T: BinaryInteger>(
		sourceBits: Int = Element().bitWidth,
		resultBits: Int = T().bitWidth) -> [T] {
		return self.toArray(endinanness: .little,
							sourceBits: sourceBits,
							resultBits: resultBits)
	}
	
	/// Performs the conversion for `.asBigEndian` and `.asLittleEndian`
	///
	/// - Precondition: `0 < sourceBits <= Element().bitWidth`
	/// - Precondition: `0 < resultBits <= T().bitWidth`
	private func toArray<T: BinaryInteger>(endinanness: Endianness,
										   sourceBits: Int,
										   resultBits: Int) -> [T] {
		precondition(sourceBits > 0)
		precondition(resultBits > 0)
		precondition(sourceBits <= Element().bitWidth)
		precondition(resultBits <= T().bitWidth)
		let sourceShift: (Int) -> Int
		let resultShift: (Int) -> Int
		switch endinanness {
			case .big:
				sourceShift = { sourceBits - 1 - $0 }
				resultShift = { $0 - 1 }
			case .little:
				sourceShift = { $0 }
				resultShift = { resultBits - $0 }
		}
		
		let resultCount = (self.count * sourceBits + resultBits-1) / resultBits
		var result = [T](repeating: 0, count: resultCount)
		
		var resultIndex = 0
		var resultBitIndex = resultBits
		
		for word in self {
			for sourceBitIndex in 0..<sourceBits {
				let bit = (word >> sourceShift(sourceBitIndex)) & 1
				result[resultIndex] |= T(bit) << resultShift(resultBitIndex)
				resultBitIndex -= 1
				if resultBitIndex == 0 {
					resultBitIndex = resultBits
					resultIndex += 1
				}
			}
		}
		return result
	}
}
