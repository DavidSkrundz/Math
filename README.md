# Math

[![](https://img.shields.io/badge/Swift-4.0%20--%204.2-orange.svg)][1]
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
.package(url: "https://github.com/DavidSkrundz/Math.git", .upToNextMinor(from: "1.2.0"))
```

## `BinaryInteger`

Modulo:

```Swift
func modulo(_ modulo: Self) -> Self
```

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

Modular Arithmetic:

```Swift
func adding(_ other: Self, modulo: Self) -> Self
func subtracting(_ other: Self, modulo: Self) -> Self
func multiplying(_ other: Self, modulo: Self) -> Self
func exponentiating(by exponent: Self, modulo: Self) -> Self
func inverse(modulo: Self) -> Self?
func gcdDecomposition(_ other: Self) -> (gcd: Self, selfCount: Self, otherCount: Self)
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
