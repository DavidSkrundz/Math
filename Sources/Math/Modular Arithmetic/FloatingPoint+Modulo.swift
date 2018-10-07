//
//  FloatingPoint+Modulo.swift
//  Math
//

extension FloatingPoint {
	public func modulo(_ modulo: Self) -> Self {
		precondition(modulo > 0)
		let remainder = self.remainder(dividingBy: modulo)
		return remainder >= 0 ? remainder : remainder + modulo
	}
}
