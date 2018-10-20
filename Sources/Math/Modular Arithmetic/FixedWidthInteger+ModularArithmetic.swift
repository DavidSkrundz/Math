//
//  FixedWidthInteger+ModularArithmetic.swift
//  Math
//

extension FixedWidthInteger {
	public func adding(_ other: Self, modulo: Self) -> Self {
		precondition(modulo > 0)
		let lhs = self.modulo(modulo)
		let rhs = other.modulo(modulo)
		
		let (sum, overflow) = lhs.addingReportingOverflow(rhs)
		if overflow == false { return sum.modulo(modulo) }
		
		let difference = modulo - lhs
		return rhs - difference
	}
	
	public func subtracting(_ other: Self, modulo: Self) -> Self {
		precondition(modulo > 0)
		let lhs = self.modulo(modulo)
		let rhs = other.modulo(modulo)
		
		let (sub, overflow) = lhs.subtractingReportingOverflow(rhs)
		if overflow == false { return sub.modulo(modulo) }
		
		let difference = modulo - rhs
		return lhs + difference
	}
	
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
}
