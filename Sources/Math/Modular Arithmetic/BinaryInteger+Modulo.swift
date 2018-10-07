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

extension BinaryInteger where Self: ModularOperations {
	public func exponentiating(by exponent: Self, modulo: Self) -> Self {
		precondition(modulo > 0)
		var lhs = self
		var rhs = exponent
		var r: Self = 1
		while rhs > 0 {
			if rhs & 1 == 1 {
				r = r.multiplying(lhs, modulo: modulo)
			}
			rhs = rhs >> 1
			lhs = lhs.multiplying(lhs, modulo: modulo)
		}
		return r.modulo(modulo)
	}
	
	public func inverse(modulo: Self) -> Self? {
		precondition(modulo > 1)
		guard self.gcdDecomposition(modulo).0 == 1 else { return nil }
		if Self.isSigned {
			let k = self % modulo
			let r: Self
			if k < 0 {
				r = 0 - modulo.gcdDecomposition(0-k).2
			} else {
				r = modulo.gcdDecomposition(k).2
			}
			return r.adding(modulo, modulo: modulo)
		} else {
			var lhs = self
			var new: Self = 1
			var old: Self = 0
			var q: Self = modulo
			var h: Self = 0
			var pos = false
			while lhs != 0 {
				let r = q % lhs
				q /= lhs
				h = q * new + old
				old = new
				new = h
				q = lhs
				lhs = r
				pos.toggle()
			}
			return pos ? old : (modulo - old)
		}
	}
}
