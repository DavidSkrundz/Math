# Math

[![](https://img.shields.io/badge/Swift-4.2-orange.svg)][1]
[![](https://img.shields.io/badge/os-macOS%20|%20Linux-lightgray.svg)][1]
[![](https://travis-ci.com/DavidSkrundz/Math.svg?branch=master)][2]
[![](https://codebeat.co/badges/1be2981d-cfc2-42d3-aa44-1451a1660d60)][3]
[![](https://codecov.io/gh/DavidSkrundz/Math/branch/master/graph/badge.svg)][4]

[1]: https://swift.org/download/#releases
[2]: https://travis-ci.com/DavidSkrundz/Math
[3]: https://codebeat.co/projects/github-com-davidskrundz-math-master
[4]: https://codecov.io/gh/DavidSkrundz/Math

Modular arithmetic and bitwise operations

## Importing

```Swift
.package(url: "https://github.com/DavidSkrundz/Math.git", .upToNextMinor(from: "1.4.0"))
```

## `Random`

Declares the four `random()` functions that come with `FixedWidthInteger`

## `ModularOperations`

Declares modular arithmetic operations

```Swift
func modulo(_ modulo: Self) -> Self
func adding(_ other: Self, modulo: Self) -> Self
func subtracting(_ other: Self, modulo: Self) -> Self
func multiplying(_ other: Self, modulo: Self) -> Self
func exponentiating(by exponent: Self, modulo: Self) -> Self
func inverse(modulo: Self) -> Self?
func gcdDecomposition(_ other: Self) -> (gcd: Self, selfCount: Self, otherCount: Self)
```

`FloatingPoint` and `BinaryInteger` define `modulo`

`BinaryInteger where Self: ModularOperations` defines `exponentiating` and `inverse`

`FixedWidthInteger` implements the remaining functions

`Int`, `Int8`, `Int16`, `Int32`, `Int64`, `UInt`, `UInt8`, `UInt16`, `UInt32`, and `UInt64` all conform to `ModularOperations`

## `BinaryInteger`

Bit Rotation:

```Swift
static func >>> <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> Self
static func <<< <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> Self
```

## `FixedWidthInteger`

Byte Conversion:

```Swift
var littleEndianBytes: [UInt8]
var bigEndianBytes: [UInt8]
```

## `Array where Element == UInt8`

String Conversion:

```Swift
var hexString: String
```

## `Array where Element: BinaryInteger`

Bit Packing/Unpacking:

```Swift
func asBigEndian<T: BinaryInteger>(sourceBits: Int = MemoryLayout<Element>.size * 8, resultBits: Int = MemoryLayout<T>.size * 8) -> [T]
func asLittleEndian<T: BinaryInteger>(sourceBits: Int = MemoryLayout<Element>.size * 8, resultBits: Int = MemoryLayout<T>.size * 8) -> [T]
```

## `FiniteFieldInteger`

A protocol used for defining custom finite fields. It implements `Numeric`, `Strideable`, and `LosslessStringConvertible`

Defining a new `FiniteFieldInteger`:

```Swift
struct F_31: FiniteFieldInteger {
	static var Order = UInt8(31) // Must be prime
	var value: Element = 0
}
```

Implemented functionality:

```Swift
init()
init(_ value: Element)
init(integerLiteral value: Element)
init?(_ description: String)
init?<T>(exactly source: T) where T: BinaryInteger

var description: String

func distance(to other: Self) -> Int
func advanced(by n: Int) -> Self

static func == (lhs: Self, rhs: Self) -> Bool
static func < (lhs: Self, rhs: Self) -> Bool

static func ... (minimum: Self, maximum: Self) -> ClosedRange<Self>

static func + (lhs: Self, rhs: Self) -> Self
static func - (lhs: Self, rhs: Self) -> Self
static func * (lhs: Self, rhs: Self) -> Self
static func / (lhs: Self, rhs: Self) -> Self
static func % (lhs: Self, rhs: Self) -> Self
func exponentiating(by value: Element) -> Self

static func += (lhs: inout Self, rhs: Self)
static func -= (lhs: inout Self, rhs: Self)
static func *= (lhs: inout Self, rhs: Self)
static func /= (lhs: inout Self, rhs: Self)
static func %= (lhs: inout Self, rhs: Self)
```

## `BigUInt`

An arbitrary precision unsigned integer type. It conforms to `UnsignedInteger` and `ModularOperations`, and provides `func power<T: BinaryInteger>(of exponent: T) -> BigUInt`

`gcdDecomposition()` of `BigUInt` only returns a valid `gcd`. The `selfCount` and `otherCount` values are meaningless (and always zero)

Currently there is no `BigInt` implementation so the `Strideable` conformance comes from the standard library meaning it is not safe to call `distance(to other: BigUInt)` or `advanced(by n: BigInt)` unless the difference is within the range of `Int`
