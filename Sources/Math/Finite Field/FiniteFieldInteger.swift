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
///         static var Order = UInt8(31) // Must be prime
///         var value: Element = 0
///     }
///
/// - Note: `Self.Order` must be prime
public protocol FiniteFieldInteger: Numeric, Strideable, Hashable, LosslessStringConvertible {
	associatedtype Element: FixedWidthInteger, UnsignedInteger
	
	static var Order: Element { get }
	
	var value: Element { get set }
	
	init()
}

/// Default init
extension FiniteFieldInteger {
	public init(_ value: Element) {
		self.init(integerLiteral: value)
	}
}

/// CustomStringConvertible
extension FiniteFieldInteger {
	public var description: String {
		return self.value.description
	}
}

/// LosslessStringConvertible
extension FiniteFieldInteger {
	public init?(_ description: String) {
		guard  let value = Element(description) else { return nil }
		self.init(value)
	}
}

/// ExpressibleByIntegerLiteral
extension FiniteFieldInteger {
	public init(integerLiteral value: Element) {
		self.init()
		self.value = value.modulo(Self.Order)
	}
}

/// Equatable
extension FiniteFieldInteger {
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.value == rhs.value
	}
}

/// Comparable
extension FiniteFieldInteger {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		return lhs.value < rhs.value
	}
}

/// Hashable
extension FiniteFieldInteger {
	public var hashValue: Int {
		return self.value.hashValue
	}
	
	public func hash(into hasher: inout Hasher) {
		self.value.hash(into: &hasher)
	}
}

/// Strideable
extension FiniteFieldInteger {
	public func distance(to other: Self) -> Int {
		if other > self {
			return Int(other.value - self.value)
		} else {
			return Int(Self.Order - self.value + other.value)
		}
	}
	
	public func advanced(by n: Int) -> Self {
		if n > 0 {
			return self + Self(exactly: n)!
		} else {
			return self - Self(exactly: -n)!
		}
	}
	
	public static func ... (minimum: Self, maximum: Self) -> ClosedRange<Self> {
		return ClosedRange(uncheckedBounds: (minimum, maximum))
	}
}

/// Numeric
extension FiniteFieldInteger {
	public var magnitude: Self { return self }
	
	public init?<T>(exactly source: T) where T: BinaryInteger {
		if let exact = Element(exactly: source) {
			self.init(exact)
		} else {
			guard let order = T(exactly: Self.Order) else { return nil }
			self.init(exactly: source.modulo(order))
		}
	}
	
	public static func + (lhs: Self, rhs: Self) -> Self {
		return Self(lhs.value.adding(rhs.value, modulo: Self.Order))
	}
	
	public static func - (lhs: Self, rhs: Self) -> Self {
		return Self(lhs.value.subtracting(rhs.value, modulo: Self.Order))
	}
	
	public static func * (lhs: Self, rhs: Self) -> Self {
		return Self(lhs.value.multiplying(rhs.value, modulo: Self.Order))
	}
	
	public static func += (lhs: inout Self, rhs: Self) {
		lhs = lhs + rhs
	}
	
	public static func -= (lhs: inout Self, rhs: Self) {
		lhs = lhs - rhs
	}
	
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}
}

/// Division, Exponentiation, & Modulo
extension FiniteFieldInteger {
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
	
	public func exponentiating(by value: Element) -> Self {
		return Self(self.value.exponentiating(by: value, modulo: Self.Order))
	}
	
	public static func /= (lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}
	
	public static func %= (lhs: inout Self, rhs: Self) {
		lhs = lhs % rhs
	}
}
