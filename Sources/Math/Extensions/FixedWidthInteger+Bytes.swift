//
//  FixedWidthInteger+Bytes.swift
//  Math
//

extension FixedWidthInteger {
	/// - Returns: A `[UInt8]` representing the bytes of `self`
	public var littleEndianBytes: [UInt8] {
		var copy = self.littleEndian
		return withUnsafeBytes(of: &copy, Array.init)
	}
	
	/// - Returns: A `[UInt8]` representing the bytes of `self`
	public var bigEndianBytes: [UInt8] {
		var copy = self.bigEndian
		return withUnsafeBytes(of: &copy, Array.init)
	}
}
