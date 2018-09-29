//
//  BinaryInteger+Modulo.swift
//  Math
//

extension BinaryInteger {
	/// Calculate the `self mod (modulo)`
	///
	/// - Precondition: `mod > 0`
	///
	/// - Parameter modulo: The modulus
	///
	/// - Returns: The modulo in the range `[0,mod)`
	public func modulo(_ modulo: Self) -> Self {
		precondition(modulo > 0)
		let remainder = self % modulo
		return remainder >= 0 ? remainder : remainder + modulo
	}
}
