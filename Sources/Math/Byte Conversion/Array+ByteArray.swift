//
//  Array+ByteArray.swift
//  Math
//

private let indexToHexMap: [Character] = [
	"0", "1", "2", "3", "4", "5", "6", "7",
	"8", "9", "a", "b", "c", "d", "e", "f"
]

extension Array where Element == UInt8 {
	/// - Returns: The hexadecimal `String` representing `self`
	public var hexString: String {
		let halfbytes = self.flatMap { [$0 >> 4, $0 & 0x0F] }
		let characters = halfbytes.map { indexToHexMap[Int($0)] }
		return characters.reduce("") { $0 + "\($1)" }
	}
}
