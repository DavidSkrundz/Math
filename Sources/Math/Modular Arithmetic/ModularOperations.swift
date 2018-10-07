//
//  ModularOperations.swift
//  Math
//

/// Declares methods backing modular arithmetic operations
public protocol ModularOperations {
	/// Calculate the `self mod (modulo)`
	///
	/// - Precondition: `mod > 0`
	///
	/// - Parameter modulo: The modulus
	///
	/// - Returns: The modulo in the range `[0,mod)`
	func modulo(_ modulo: Self) -> Self
	
	/// Calculates `(self + other) mod (modulo)`
	///
	/// - Precondition: `mod > 0`
	///
	/// - Parameter other: The number to add
	/// - Parameter modulo: The modulus
	func adding(_ other: Self, modulo: Self) -> Self
	
	/// Calculates `(self - other) mod (modulo)`
	///
	/// - Precondition: `mod > 0`
	///
	/// - Parameter other: The number to subtract
	/// - Parameter modulo: The modulus
	func subtracting(_ other: Self, modulo: Self) -> Self
	
	/// Calculates `(self * other) mod (modulo)`
	///
	/// - Precondition: `mod > 0`
	///
	/// - Parameter other: The number to multiply
	/// - Parameter modulo: The modulus
	func multiplying(_ other: Self, modulo: Self) -> Self
	
	/// Calculates `exp(self, other) mod (modulo)`
	///
	/// - Precondition: `mod > 0`
	///
	/// - Parameter exponent: The exponent
	/// - Parameter modulo: The modulus
	func exponentiating(by exponent: Self, modulo: Self) -> Self
	
	/// Calculates the modular inverse of `self`
	///
	/// - Precondition: `mod > 1`
	///
	/// - Returns: `R` such that `(self * R) mod (mod) == 1` or `nil`
	func inverse(modulo: Self) -> Self?
	
	/// - Returns: (X,Y,Z) such that `X = gcd(self,other)` and
	///            `Y*self + Z*other = X`
	func gcdDecomposition(_ other: Self) -> (gcd: Self, selfCount: Self, otherCount: Self)
}
