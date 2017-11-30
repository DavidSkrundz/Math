//
//  FixedWidthInteger+ModularArithmetic.swift
//  Math
//

extension FixedWidthInteger {
	/// Calculates `(self + other) mod (modulo)`
	///
	/// - Precondition: `mod > 0`
	///
	/// - Parameter other: The number to add
	/// - Parameter modulo: The modulus
	public func adding(_ other: Self, modulo: Self) -> Self {
		precondition(modulo > 0)
		let lhs = self.modulo(modulo)
		let rhs = other.modulo(modulo)
		
		let (sum, overflow) = lhs.addingReportingOverflow(rhs)
		if overflow == false { return sum.modulo(modulo) }
		
		let difference = modulo - lhs
		return rhs - difference
	}
	
	/// Calculates `(self - other) mod (modulo)`
	///
	/// - Precondition: `mod > 0`
	///
	/// - Parameter other: The number to subtract
	/// - Parameter modulo: The modulus
	public func subtracting(_ other: Self, modulo: Self) -> Self {
		precondition(modulo > 0)
		let lhs = self.modulo(modulo)
		let rhs = other.modulo(modulo)
		
		let (sub, overflow) = lhs.subtractingReportingOverflow(rhs)
		if overflow == false { return sub.modulo(modulo) }
		
		let difference = modulo - rhs
		return lhs + difference
	}
	
	/// Calculates `(self * other) mod (modulo)`
	///
	/// - Precondition: `mod > 0`
	///
	/// - Parameter other: The number to multiply
	/// - Parameter modulo: The modulus
	public func multiplying(_ other: Self, modulo: Self) -> Self {
		precondition(modulo > 0)
		let lastBit = Self(1) << (self.bitWidth - 1)
		
		var lhs = self.modulo(modulo)
		let rhs = other.modulo(modulo)
		var d: Self = 0
		let mp2 = modulo >> 1
		for _ in 0..<self.bitWidth {
			d = (d > mp2) ? (d << 1) &- modulo : d << 1
			if lhs & lastBit != 0 {
				d = d.adding(rhs, modulo: modulo)
			}
			lhs <<= 1
		}
		return d.modulo(modulo)
	}
	
	/// Calculates `exp(self, other) mod (modulo)`
	///
	/// - Precondition: `mod > 0`
	///
	/// - Parameter exponent: The exponent
	/// - Parameter modulo: The modulus
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
	
	/// Calculates the modular inverse of `self`
	///
	/// - Precondition: `mod > 1`
	///
	/// - Returns: `R` such that `(self * R) mod (mod) == 1` or `nil`
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
				q = q / lhs
				h = q * new + old
				old = new
				new = h
				q = lhs
				lhs = r
				pos = !pos
			}
			return pos ? old : (modulo - old)
		}
	}
	
	/// - Returns: (X,Y,Z) such that `X = gcd(self,other)` and
	///            `Y*self + Z*other = X`
	public func gcdDecomposition(_ other: Self) -> (gcd: Self, Self, Self) {
		guard other != 0 else { return (self, 1, 0) }
		guard other != -1 else { return (1, 0, -1) }
		let n = self / other
		let c = self % other
		let r = other.gcdDecomposition(c)
		if r.0 < 0 {
			return (0&-r.0, 0-r.2, r.2&*n - r.1)
		}
		return (r.0, r.2, r.1 &- r.2&*n)
	}
}
