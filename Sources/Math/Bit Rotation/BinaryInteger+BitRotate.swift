//
//  BinaryInteger+BitRotate.swift
//  Math
//

extension BinaryInteger {
	/// Perform bit rotation on `lhs` rotating right by `rhs` bits
	public static func >>> <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> Self {
		let bitsInSelf = RHS(lhs.bitWidth)
		let rhs = rhs.modulo(bitsInSelf)
		let top = lhs << (bitsInSelf - rhs)
		let bottom = (lhs >> rhs) & Self((1 << (bitsInSelf - rhs)) &- 1)
		return top | bottom
	}
	
	/// Perform bit rotation on `lhs` rotating left by `rhs` bits
	public static func <<< <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> Self {
		let bitsInSelf = RHS(lhs.bitWidth)
		let rhs = rhs.modulo(bitsInSelf)
		let top = lhs << rhs
		let bottom = (lhs >> (bitsInSelf - rhs)) & Self((1 << rhs) &- 1)
		return top | bottom
	}
}
