//
//  BinaryInteger+sqrt.swift
//  Math
//

extension BinaryInteger {
	public func sqrt() -> Self {
		assert(self >= 0, "Canot take the square root of a negative number")
		
		var op = self.magnitude
		var res: Self.Magnitude = 0
		
		var one = Self.Magnitude(1) << (self.bitWidth - 2)
		while one > op { one >>= 2 }
		
		while one != 0 {
			if op >= res + one {
				op -= res + one
				res += one << 1
			}
			res >>= 1
			one >>= 2
		}
		return Self(res)
	}
}
