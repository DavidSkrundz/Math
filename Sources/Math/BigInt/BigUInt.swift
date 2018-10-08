//
//  BigUInt.swift
//  Math
//

/// Unsigned arbitrary precision integer
///
/// Stores its contents in `words` as a `[UInt]`. The size of the numbers is
/// only limited by the available memory
public struct BigUInt: UnsignedInteger, ModularOperations, Random, LosslessStringConvertible {
	public private(set) var words: [UInt] = [0]
	
	public init(words: [UInt]) {
		self.words = BigUInt.trimSignExtension(words)
	}
}

/// Properties
extension BigUInt {
	private var usedBits: Int {
		return self.bitWidth - self.words.last!.leadingZeroBitCount
	}
	
	public var bitWidth: Int {
		return self.words.count * Words.Element.bitWidth
	}
	
	public var trailingZeroBitCount: Int {
		let zeros = self.words.prefix { $0.trailingZeroBitCount == $0.bitWidth }
		let zeroValueBits = zeros.count * Words.Element.bitWidth
		let firstValueBits = self.words
			.dropFirst(zeros.count)
			.first?.trailingZeroBitCount ?? 0
		return zeroValueBits + firstValueBits
	}
}

/// Initializers
extension BigUInt {
	public init(integerLiteral value: UInt64) {
		self.init(words: [value].asLittleEndian())
	}
	
	public init?(_ description: String) {
		self.init(description, radix: 10)
	}
	
	public init?<S : StringProtocol>(_ text: S, radix: Int = 10) {
		precondition(radix > 1)
		let text = String(text.filter { $0 != "_" })
		let (charsPerWord, power) = BigUInt.charactersPerWord(forRadix: radix)
		
		var words: Words = []
		var end = text.endIndex
		var start = end
		var count = 0
		while start != text.startIndex {
			start = text.index(before: start)
			count += 1
			if count == charsPerWord {
				guard let d = Words.Element(text[start ..< end], radix: radix) else { return nil }
				words.append(d)
				end = start
				count = 0
			}
		}
		if start != end {
			guard let d = Words.Element(text[start ..< end], radix: radix) else { return nil }
			words.append(d)
		}
		
		if power == 0 {
			self.init(words: words)
		} else {
			var value = BigUInt()
			for d in words.reversed() {
				value *= BigUInt(power)
				value += BigUInt(d)
			}
			self = value
		}
	}
	
	public init?<T: BinaryFloatingPoint>(exactly source: T) {
		if source.isInfinite { return nil }
		if source.isNaN { return nil }
		if source < 0.0 { return nil }
		if source.isZero { self = 0; return }
		
		let value = source.rounded(.towardZero)
		if value != source { return nil }
		
		let significand = value.significandBitPattern
		let high = BigUInt(1) << value.exponent
		let low = BigUInt(significand) >> (T.significandBitCount - Int(value.exponent))
		self = high + low
	}
	
	public init<T: BinaryFloatingPoint>(_ source: T) {
		self.init(exactly: source.rounded(.towardZero))!
	}
	
	public init<T: BinaryInteger>(_ source: T) {
		self.init(words: [source].asLittleEndian())
	}
	
	public init?<T: BinaryInteger>(exactly source: T) {
		self.init(words: [source].asLittleEndian())
	}
	
	public init<T: BinaryInteger>(clamping source: T) {
		self.init(words: [source].asLittleEndian())
	}
	
	public init<T: BinaryInteger>(truncatingIfNeeded source: T) {
		self.init(words: [source].asLittleEndian())
	}
}

/// Operators
extension BigUInt {
	public static func + (lhs: BigUInt, rhs: BigUInt) -> BigUInt {
		let short = lhs.words.count < rhs.words.count ? lhs.words : rhs.words
		let long = lhs.words.count < rhs.words.count ? rhs.words : lhs.words
		var new = Words(repeating: 0, count: long.count)
		
		var (value, overflow) = (Words.Element(), Words.Element())
		for i in 0..<short.count {
			(value, overflow) = BigUInt.adding(lhs.words[i], rhs.words[i], carry: overflow)
			new[i] = value
		}
		for i in short.count..<long.count {
			(value, overflow) = BigUInt.adding(long[i], 0, carry: overflow)
			new[i] = value
		}
		new.append(overflow)
		return BigUInt(words: new)
	}
	
	public static func - (lhs: BigUInt, rhs: BigUInt) -> BigUInt {
		let short = lhs.words.count < rhs.words.count ? lhs.words : rhs.words
		let long = lhs.words.count < rhs.words.count ? rhs.words : lhs.words
		var new = Words(repeating: 0, count: long.count)
		
		var (value, overflow) = (Words.Element(), false)
		for i in 0..<short.count {
			(value, overflow) = BigUInt.subtracting(lhs.words[i], rhs.words[i], carry: overflow)
			new[i] = value
		}
		for i in short.count..<long.count {
			(value, overflow) = BigUInt.subtracting(long[i], 0, carry: overflow)
			new[i] = value
		}
		if overflow { fatalError("Subtracting past zero on \(BigUInt.self)") }
		return BigUInt(words: new)
	}
	
	public static func * (lhs: BigUInt, rhs: BigUInt) -> BigUInt {
		let short = lhs.words.count < rhs.words.count ? lhs.words : rhs.words
		let long = lhs.words.count < rhs.words.count ? rhs.words : lhs.words
		var new = Words(repeating: 0, count: short.count + long.count)
		
		var carry = Words.Element()
		for i in 0..<long.count {
			carry = 0
			for j in 0..<short.count {
				let (high, low) = long[i].multipliedFullWidth(by: short[j])
				(new[i + j], carry) = BigUInt.adding(new[i + j], Words.Element(low), carry: carry)
				carry += high
			}
			new[i + short.count] = carry
		}
		return BigUInt(words: new)
	}
	
	public static func / (lhs: BigUInt, rhs: BigUInt) -> BigUInt {
		return lhs.quotientAndRemainder(dividingBy: rhs).quotient
	}
	
	public static func % (lhs: BigUInt, rhs: BigUInt) -> BigUInt {
		return lhs.quotientAndRemainder(dividingBy: rhs).remainder
	}
	
	public static prefix func ~ (x: BigUInt) -> BigUInt {
		return BigUInt(words: x.words.map { ~$0 })
	}
	
	public static func << <RHS: BinaryInteger>(lhs: BigUInt, rhs: RHS) -> BigUInt {
		if rhs == 0 { return lhs }
		if rhs < 0 { return lhs >> (0 - rhs) }
		
		let valueWidth = RHS(Words.Element.bitWidth)
		let (quotient, remainder) = rhs.quotientAndRemainder(dividingBy: valueWidth)
		
		var newValue = lhs.words + [0]
		
		let highOffset = Int(remainder)
		let lowOffset = Words.Element.bitWidth - highOffset
		if highOffset != 0 {
			for i in (1..<newValue.count).reversed() {
				newValue[i] = newValue[i] << highOffset | newValue[i - 1] >> lowOffset
			}
			newValue[0] <<= highOffset
		}
		
		newValue.insert(contentsOf: Words(repeating: 0, count: Int(quotient)), at: 0)
		return BigUInt(words: newValue)
	}
	
	public static func >> <RHS: BinaryInteger>(lhs: BigUInt, rhs: RHS) -> BigUInt {
		if rhs == 0 { return lhs }
		if rhs < 0 { return lhs << (0 - rhs) }
		
		let valueWidth = RHS(Words.Element.bitWidth)
		let (quotient, remainder) = rhs.quotientAndRemainder(dividingBy: valueWidth)
		
		var newValue = Array(lhs.words.dropFirst(Int(quotient)))
		if newValue.isEmpty { return 0 }
		
		let lowOffset = Int(remainder)
		let highOffset = Words.Element.bitWidth - lowOffset
		if lowOffset != 0 {
			for i in 0..<(newValue.count - 1) {
				newValue[i] = newValue[i] >> lowOffset | newValue[i + 1] << highOffset
			}
			newValue[newValue.count - 1] >>= lowOffset
		}
		
		return BigUInt(words: newValue)
	}

	
	public static func & (lhs: BigUInt, rhs: BigUInt) -> BigUInt {
		let sequence = zip(lhs.words, rhs.words).map { $0.0 & $0.1 }
		return BigUInt(words: sequence)
	}
	
	public static func | (lhs: BigUInt, rhs: BigUInt) -> BigUInt {
		let short = lhs.words.count < rhs.words.count ? lhs.words : rhs.words
		let long = lhs.words.count < rhs.words.count ? rhs.words : lhs.words
		let sequence = zip(short, long).map { $0.0 | $0.1 }
		return BigUInt(words: sequence + long.dropFirst(short.count))
	}
	
	public static func ^ (lhs: BigUInt, rhs: BigUInt) -> BigUInt {
		let short = lhs.words.count < rhs.words.count ? lhs.words : rhs.words
		let long = lhs.words.count < rhs.words.count ? rhs.words : lhs.words
		let sequence = zip(short, long).map { $0.0 ^ $0.1 }
		return BigUInt(words: sequence + long.dropFirst(short.count))
	}
}

/// Assignments
extension BigUInt {
	public static func += (lhs: inout BigUInt, rhs: BigUInt) {
		lhs = lhs + rhs
	}
	
	public static func -= (lhs: inout BigUInt, rhs: BigUInt) {
		lhs = lhs - rhs
	}
	
	public static func *= (lhs: inout BigUInt, rhs: BigUInt) {
		lhs = lhs * rhs
	}
	
	public static func /= (lhs: inout BigUInt, rhs: BigUInt) {
		lhs = lhs / rhs
	}
	
	public static func %= (lhs: inout BigUInt, rhs: BigUInt) {
		lhs = lhs % rhs
	}
	
	public static func >>= <RHS: BinaryInteger>(lhs: inout BigUInt, rhs: RHS) {
		lhs = lhs >> rhs
	}
	
	public static func <<= <RHS: BinaryInteger>(lhs: inout BigUInt, rhs: RHS) {
		lhs = lhs << rhs
	}
	
	public static func &= (lhs: inout BigUInt, rhs: BigUInt) {
		lhs = lhs & rhs
	}
	
	public static func |= (lhs: inout BigUInt, rhs: BigUInt) {
		lhs = lhs | rhs
	}
	
	public static func ^= (lhs: inout BigUInt, rhs: BigUInt) {
		lhs = lhs ^ rhs
	}
}

/// Exponentiation
extension BigUInt {
	public func power<T: BinaryInteger>(of exponent: T) -> BigUInt {
		if exponent == 0 { return 1 }
		if exponent == 1 { return self }
		if self <= 1 { return self }
		if exponent < 0 { return 0 }
		
		var result: BigUInt = 1
		var base = self
		var exp = exponent
		while exp > 0 {
			if exp & 1 == 1 {
				result *= base
			}
			exp >>= 1
			base *= base
		}
		return result
	}
}

/// Custom Equatable Conformance
extension BigUInt {
	public static func == (lhs: BigUInt, rhs: BigUInt) -> Bool {
		return lhs.words == rhs.words
	}
}

/// Custom Comparable Conformance
extension BigUInt {
	public static func < (lhs: BigUInt, rhs: BigUInt) -> Bool {
		guard lhs.words.count == rhs.words.count else {
			return lhs.words.count < rhs.words.count
		}
		for i in (0..<lhs.words.count).reversed() {
			if lhs.words[i] < rhs.words[i] { return true }
			if lhs.words[i] > rhs.words[i] { return false }
		}
		return false
	}
}

/// Custom Strideable Conformance
extension BigUInt {
	// TODO: Implement the Strideable functions using BigInt
	
//	public func distance(to other: BigUInt) -> BigInt {
//		<#code#>
//	}
	
//	public func advanced(by n: BigInt) -> BigUInt {
//		<#code#>
//	}
}

/// ModularOperations
extension BigUInt {
	public func adding(_ other: BigUInt, modulo: BigUInt) -> BigUInt {
		precondition(modulo > 0)
		let lhs = self.modulo(modulo)
		let rhs = other.modulo(modulo)
		return (lhs + rhs).modulo(modulo)
	}
	
	public func subtracting(_ other: BigUInt, modulo: BigUInt) -> BigUInt {
		precondition(modulo > 0)
		let lhs = self.modulo(modulo)
		let rhs = other.modulo(modulo)
		
		if lhs > rhs {
			return lhs - rhs
		} else {
			return modulo + lhs - rhs
		}
	}
	
	public func multiplying(_ other: BigUInt, modulo: BigUInt) -> BigUInt {
		precondition(modulo > 0)
		let lastBit = BigUInt(1) << (self.bitWidth - 1)

		var lhs = self.modulo(modulo)
		let rhs = other.modulo(modulo)
		var d: BigUInt = 0
		let mp2 = modulo >> 1
		for _ in 0..<self.bitWidth {
			d = (d > mp2) ? (d << 1) - modulo : d << 1
			if lhs & lastBit != 0 {
				d = d.adding(rhs, modulo: modulo)
			}
			lhs <<= 1
		}
		return d.modulo(modulo)
	}
	
	/// Since negative numbers cannot be represented and `wrapping` around is
	/// not an option for arbitrary precision integers, the `selfCount` and
	/// `otherCount` values are meaningless
	public func gcdDecomposition(_ other: BigUInt) -> (gcd: BigUInt, selfCount: BigUInt, otherCount: BigUInt) {
		guard other != 0 else { return (self, 1, 0) }
		let (_, c) = self.quotientAndRemainder(dividingBy: other)
		let r = other.gcdDecomposition(c)
		return (r.0, 0, 0)
	}
}

/// Random
extension BigUInt {
	public static func random<T: RandomNumberGenerator>(in range: Range<BigUInt>, using generator: inout T) -> BigUInt {
		let randomRange = range.upperBound - range.lowerBound
		let binaryMax = BigUInt(words: randomRange.words.map { _ in .max })
		let searchRange = binaryMax - (binaryMax % randomRange)
		var number = BigUInt(0)
		repeat {
			number = BigUInt(words: randomRange.words.map { _ in generator.next() })
		} while number >= searchRange
		return (number % binaryMax) + range.lowerBound
	}
	
	public static func random<T: RandomNumberGenerator>(in range: ClosedRange<BigUInt>, using generator: inout T) -> BigUInt {
		let randomRange = range.upperBound - range.lowerBound
		let binaryMax = BigUInt(words: randomRange.words.map { _ in .max })
		let searchRange = binaryMax - (binaryMax % randomRange)
		var number = BigUInt(0)
		repeat {
			number = BigUInt(words: randomRange.words.map { _ in generator.next() })
		} while number > searchRange
		return (number % binaryMax) + range.lowerBound
	}
}

/// Helpers
extension BigUInt {
	private static func trimSignExtension(_ value: Words) -> Words {
		var value = value
		while value.count > 1 && value.last! == 0 {
			value.removeLast(1)
		}
		if value.isEmpty { return [0] }
		return value
	}
	
	private static func adding<T: FixedWidthInteger>(_ lhs: T, _ rhs: T, carry: T) -> (T, T) {
		let (partialSum, firstOverflow) = lhs.addingReportingOverflow(rhs)
		let (sum, secondOverflow) = partialSum.addingReportingOverflow(carry)
		return (sum, (firstOverflow ? 1 : 0) + (secondOverflow ? 1 : 0))
	}
	
	private static func subtracting<T: FixedWidthInteger>(_ lhs: T, _ rhs: T, carry: Bool) -> (T, Bool) {
		if carry {
			let (partialSum, firstOverflow) = lhs.subtractingReportingOverflow(rhs)
			let (sum, secondOverflow) = partialSum.subtractingReportingOverflow(1)
			return (sum, firstOverflow || secondOverflow)
		} else {
			return lhs.subtractingReportingOverflow(rhs)
		}
	}
	
	private static func charactersPerWord(forRadix radix: Int) -> (chars: Int, power: Words.Element) {
		var power = Words.Element()
		var newPower: Words.Element = 1
		var overflow = false
		var count = -1
		while !overflow {
			count += 1
			power = newPower
			(newPower, overflow) = power.multipliedReportingOverflow(by: Words.Element(radix))
		}
		if newPower == 0 {
			return (count + 1, 0)
		}
		return (count, power)
	}
	
	public func quotientAndRemainder(dividingBy rhs: BigUInt) -> (quotient: BigUInt, remainder: BigUInt) {
		if rhs == 0 { fatalError("Division by zero on \(BigUInt.self)") }
		if self < rhs { return (0, self) }
		if self == rhs { return (1, 0) }
		
		var remainder = self
		let n = self.usedBits - rhs.usedBits
		var quotient: BigUInt = 0
		var tempRHS = rhs << n
		var tempQuotient: BigUInt = 1 << n
		
		for _ in (0...n).reversed() {
			if tempRHS <= remainder {
				remainder -= tempRHS
				quotient += tempQuotient
			}
			tempRHS >>= 1
			tempQuotient >>= 1
		}
		
		return (quotient, remainder)
	}
}
