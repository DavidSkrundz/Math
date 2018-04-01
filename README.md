Math [![Swift Version](https://img.shields.io/badge/Swift-4.1-orange.svg)](https://swift.org/download/#snapshots) [![Build Status](https://travis-ci.org/DavidSkrundz/Math.svg?branch=master)](https://travis-ci.org/DavidSkrundz/Math) [![Codebeat Status](https://codebeat.co/badges/1be2981d-cfc2-42d3-aa44-1451a1660d60)](https://codebeat.co/projects/github-com-davidskrundz-math-master)
====

Adds bitwise operations and modular arithmetic

###### Todo:
- Improve bit packing performance


Bit Rotation
------------

Adds `<<<` and `>>>` to `BinaryInteger`

```Swift
let a = UInt8("11000100", radix: 2)
let b = a <<< 2
b == UInt8("00010011", radix: 2) // true
```

Bit Packing
-----------

Adds

```Swift
.asBigEndian<T: BinaryInteger>(sourceBits: Int = MemoryLayout<Element>.size * 8, resultBits: Int = MemoryLayout<T>.size * 8) -> [T]
.asLittleEndian<T: BinaryInteger>(sourceBits: Int = MemoryLayout<Element>.size * 8, resultBits: Int = MemoryLayout<T>.size * 8) -> [T]
```

to `Array<T: BinaryInteger>`

These functions convert between `BinaryInteger` types, as well as the number of bits that are used within each. Calling `[UInt8].asBigEndian(resultBits: 2) -> [UInt8]` would result in the source bytes being unpacked into 2-bit numbers represented as a `[UInt8]`.

``` Swift
[UInt8].asBigEndian() -> [UInt16]
is the inverse of
[UInt16].bigEndianBytes
```

```Swift
[Type1].asBigEndian(sourceBits: A, resultBits: B) -> [Type2]
is the inverse of
[Type2].asBigEndian(sourceBits: B, resultBits: A) -> [Type1]
```

Byte Conversion
---------------

Adds

```Swift
.littleEndianBytes -> [UInt8]
.bigEndianBytes -> [UInt8]
```

to `FixedWidthInteger`

Hex Conversion
--------------

Adds `.hexString -> String` to `Array<UInt8>`

Modular Arithmetic
------------------

Adds `.modulo(_ modulo: Self) -> Self` to `BinaryInteger`

Adds multiple functions to `FixedWidthInteger`

```Swift
.adding(_ other: Self, modulo: Self) -> Self
.subtracting(_ other: Self, modulo: Self) -> Self
.multiplying(_ other: Self, modulo: Self) -> Self
.exponentiating(by exponent: Self, modulo: Self) -> Self
.inverse(modulo: Self) -> Self` (Modular inverse)
.gcdDecomposition(_ other: Self) -> (gcd: Self, selfCount: Self, otherCount: Self)
```
