# AnyInteger

Generic, storage‑agnostic arbitrary‑precision integers for Swift.

`AnyInteger` exposes a single generic integer type, `AnyInt<Storage, Signedness>`, plus a set of convenient aliases (such as `UInt256`, `Int256`, `BigInt`, `BigUInt`, and limited‑size big integers). It is designed to feel like Swift’s standard integer types while allowing you to choose how the underlying bytes are stored.

> **Status: Alpha**
>
> This package is in an early alpha state:
> - The public API is not stable and may change without notice.
> - Performance has not been fully optimized yet.
> - A proper benchmark suite is still being designed and implemented.
>
> Do not rely on this library for latency‑ or safety‑critical production workloads yet.

## Features

- Generic integer type `AnyInt<Storage, Signedness>` conforming to `BinaryInteger` and `Comparable`.
- Pluggable byte storage:
  - Fixed‑width storages (`Byte16`, `Byte32`, `Byte64`, `Byte128`, `Byte256`, `Byte512`, `Byte1024`, `Byte2048`, …).
  - Growable dynamic storage (`[UInt8]`).
  - Growable but size‑limited dynamic storage (e.g. `LimitedDynamicStorage256`).
- Convenient type aliases for common sizes:
  - Fixed‑width big integers: `UInt256`, `Int256`, `UInt512`, `Int512`, `UInt1024`, `Int1024`, `UInt2048`, `Int2048`, `UInt4096`, `Int4096`, `UInt8192`, `Int8192`, `UInt16384`, `Int16384`.
  - Arbitrary‑precision: `BigUInt` and `BigInt` (backed by growable `[UInt8]`).
  - Limited arbitrary‑precision (e.g. `LimitedBigInt256`, `LimitedBigUInt256`, …).
- Backward‑compatible 128‑bit integers:
  - `UInt128Backport` / `Int128Backport` mirror the behavior of native `UInt128` / `Int128` using custom 16‑byte storage and are available on older OS versions.

## Usage

### Fixed‑width big integers

```swift
import AnyInteger

let a: UInt256 = 1
let b = UInt256("340282366920938463463374607431768211456")! // 2^128
let sum = a + b

let asInt = Int(a)      // standard integer conversion
let asString = String(b) // decimal description
```

### Arbitrary‑precision integers

```swift
let big: BigInt = BigInt("123456789012345678901234567890")!
let squared = big * big
print(squared)
```

### Limited‑size big integers

`LimitedBigInt*` and `LimitedBigUInt*` types use growable storage with an upper bound. Values that do not fit are clamped or report overflow through the `BinaryInteger` APIs.

```swift
let limited: LimitedBigInt256 = 42
let large = LimitedBigInt256("1234567890" + String(repeating: "0", count: 100))!
```

### 128‑bit compatibility types

On platforms where native `Int128` / `UInt128` are not yet available, you can use the compatibility aliases:

```swift
let x: UInt128Backport = 1
let y = UInt128Backport(UInt64.max)
let z = x &+ y
```

When running on OS versions that provide `Int128` / `UInt128`, you can migrate to the standard types when appropriate.

## Installation

Add `AnyInteger` to your SwiftPM package:

```swift
// In Package.swift
dependencies: [
    .package(url: "https://github.com/dankinsoid/AnyInteger.git", from: "0.0.1")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "AnyInteger", package: "AnyInteger")
        ]
    )
]
```

Then import the module where you want to use it:

```swift
import AnyInteger
```

## API Stability

Because the library is still evolving:

- Names, initializers, and behaviors may change between minor versions.
- New storage types and integer aliases are likely to be added.
- Overflow behavior currently relies on `BinaryInteger` reporting methods and may gain additional customization points.

Pin an exact version or branch if you depend on a specific behavior.

## Performance and Benchmarks

Current implementation focuses on correctness and ergonomics. Known work items:

- Optimize core arithmetic operations (especially multiplication, division, and shifting) for large values.
- Reduce temporary allocations for common arithmetic and conversion operations.
- Tune and document storage strategies for different workloads (fixed vs. dynamic vs. limited dynamic).
- Add a dedicated benchmark suite (e.g. using `swift benchmark` / custom tooling) to track regressions and guide optimization work.

Until this work is complete:

- Prefer smaller fixed‑width types (`UInt256`, `UInt512`, …) where possible.
- Avoid unnecessary conversions to and from strings or floating‑point values in hot paths.

## Contributing

Contributions, ideas, and performance reports are welcome, especially around:

- API ergonomics and missing functionality.
- Performance optimizations and algorithmic improvements.
- Benchmark scenarios that reflect real‑world workloads (cryptography, numeric protocols, serialization formats, etc.).

Please open an issue or a pull request in the repository with a clear description and, if possible, a minimal example or benchmark.
