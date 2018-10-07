//
//  BinaryInteger+Modulo.swift
//  Math
//

extension BinaryInteger {
	public func modulo(_ modulo: Self) -> Self {
		precondition(modulo > 0)
		let remainder = self % modulo
		return remainder >= 0 ? remainder : remainder + modulo
	}
}
