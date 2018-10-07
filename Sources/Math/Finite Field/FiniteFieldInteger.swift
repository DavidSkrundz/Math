//
//  FiniteFieldInteger.swift
//  Math
//

/// A protocol used to define finite fields containing `Order` integers starting
/// from zero
///
/// To create a finite field, simply pick a prime and an appropriate
/// `FixedWidthInteger & UnsignedInteger`. e.g. A 31 element `UInt8` field:
///
///     struct F_31: FiniteFieldInteger {
///         static var Order = UInt8(31)
///         var value: Element = 0
///     }
///
/// - Note: `Self.Order` must be prime for division
public protocol FiniteFieldInteger: UnsignedInteger, LosslessStringConvertible {
	associatedtype Element: ModularOperations, UnsignedInteger, LosslessStringConvertible
	
	static var Order: Element { get }
	
	var value: Element { get set }
	
	init()
}

/// Properties
extension FiniteFieldInteger {
	public var words: Element.Words {
		return self.value.words
	}
	
	public var bitWidth: Int {
		return self.value.bitWidth
	}
	
	public var trailingZeroBitCount: Int {
		return self.value.trailingZeroBitCount
	}
}

/// Initializers
extension FiniteFieldInteger {
	public init(integerLiteral value: Element.IntegerLiteralType) {
		self.init(Element(integerLiteral: value))
	}
	
	public init?<T: BinaryInteger>(exactly source: T) {
		if let exact = Element(exactly: source) {
			self.init(exact)
		} else {
			guard let order = T(exactly: Self.Order) else { return nil }
			self.init(exactly: source.modulo(order))
		}
	}
	
	public init?<T: BinaryFloatingPoint>(exactly source: T) {
		if let exact = Element(exactly: source.rounded(.towardZero)) {
			self.init(exact)
		} else {
			guard let order = T(exactly: Self.Order) else { return nil }
			self.init(exactly: source.modulo(order))
		}
	}
	
	public init<T: BinaryInteger>(_ source: T) {
		self.init()
		self.value = Element(source).modulo(Self.Order)
	}
	
	public init<T: BinaryFloatingPoint>(_ source: T) {
		self.init(Element(source))
	}
	
	public init<T: BinaryInteger>(clamping source: T) {
		self.init(Element(clamping: source))
	}
	
	public init<T: BinaryInteger>(truncatingIfNeeded source: T) {
		self.init(Element(truncatingIfNeeded: source))
	}
	
	public init?(_ description: String) {
		guard let value = Element(description) else { return nil }
		self.init(value)
	}
}

/// Operators
extension FiniteFieldInteger {
	public static func + (lhs: Self, rhs: Self) -> Self {
		return Self(lhs.value.adding(rhs.value, modulo: Self.Order))
	}
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		return Self(lhs.value.subtracting(rhs.value, modulo: Self.Order))
	}
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		return Self(lhs.value.multiplying(rhs.value, modulo: Self.Order))
	}
	
	public static func / (lhs: Self, rhs: Self) -> Self {
		guard rhs.value != 0 else {
			fatalError("Division by zero")
		}
		guard let inverse = rhs.value.inverse(modulo: Self.Order) else {
			fatalError("Order is not prime")
		}
		return Self(lhs.value.multiplying(inverse, modulo: Self.Order))
	}
	
	public static func % (lhs: Self, rhs: Self) -> Self {
		return Self(lhs.value.modulo(rhs.value))
	}
	
	public static prefix func ~ (x: Self) -> Self {
		return Self(~x.value)
	}
}

/// Assignments
extension FiniteFieldInteger {
	public static func += (lhs: inout Self, rhs: Self) {
		lhs = lhs + rhs
	}
	
	public static func -= (lhs: inout Self, rhs: Self) {
		lhs = lhs - rhs
	}
	
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}
	
	public static func /= (lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}
	
	public static func %= (lhs: inout Self, rhs: Self) {
		lhs = lhs % rhs
	}
	
	public static func &= (lhs: inout Self, rhs: Self) {
		lhs = Self(lhs.value & rhs.value)
	}
	
	public static func |= (lhs: inout Self, rhs: Self) {
		lhs = Self(lhs.value | rhs.value)
	}
	
	public static func ^= (lhs: inout Self, rhs: Self) {
		lhs = Self(lhs.value ^ rhs.value)
	}
	
	public static func >>= <RHS: BinaryInteger>(lhs: inout Self, rhs: RHS) {
		lhs = Self(lhs.value >> rhs)
	}
	
	public static func <<= <RHS: BinaryInteger>(lhs: inout Self, rhs: RHS) {
		lhs = Self(lhs.value << rhs)
	}
}

/// Exponentiation
extension FiniteFieldInteger {
	public func exponentiating(by value: Self) -> Self {
		return self.exponentiating(by: value.value)
	}
	
	public func exponentiating(by value: Element) -> Self {
		return Self(self.value.exponentiating(by: value, modulo: Self.Order))
	}
}

/// Custom Equatable Conformance
extension FiniteFieldInteger {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.value == rhs.value
	}
}

/// Custom Comparable Conformance
extension FiniteFieldInteger {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		return lhs.value < rhs.value
	}
}

/// Custom Strideable Conformance
extension FiniteFieldInteger {
	public func distance(to other: Self) -> Int {
		if other > self {
			return Int(other.value - self.value)
		} else {
			return Int(Self.Order - self.value + other.value)
		}
	}
	
	public static func ... (minimum: Self, maximum: Self) -> ClosedRange<Self> {
		return ClosedRange(uncheckedBounds: (minimum, maximum))
	}
}
