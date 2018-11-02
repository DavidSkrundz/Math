//
//  Random.swift
//  Math
//

// TODO: Remove this protocol when Swift stdlib has its own protocol
//       for random numbers rather than just having `.random()` on
//       `FixedWidthInteger`

public protocol Random: Comparable {
	static func random(in range: Range<Self>) -> Self
	static func random(in range: ClosedRange<Self>) -> Self
	
	static func random<T: RandomNumberGenerator>(in range: Range<Self>, using generator: inout T) -> Self
	static func random<T: RandomNumberGenerator>(in range: ClosedRange<Self>, using generator: inout T) -> Self
}
