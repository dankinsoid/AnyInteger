import Foundation

/// Marker to expose signedness and opposite-signed counterpart for integer types.
public protocol SignednessRepresentable: _ExpressibleByBuiltinIntegerLiteral, BinaryInteger, Codable where Magnitude: SignednessRepresentable & UnsignedInteger {
    static var isSigned: Bool { get }
    associatedtype OppositeSigned: SignednessRepresentable
}

extension SignednessRepresentable where Self: SignedInteger {
    public static var isSigned: Bool { true }
}

extension SignednessRepresentable where Self: UnsignedInteger {
    public static var isSigned: Bool { false }
}

extension UInt8: SignednessRepresentable { public typealias OppositeSigned = Int8 }
extension Int8: SignednessRepresentable { public typealias OppositeSigned = UInt8 }
extension UInt16: SignednessRepresentable { public typealias OppositeSigned = Int16 }
extension Int16: SignednessRepresentable { public typealias OppositeSigned = UInt16 }
extension UInt32: SignednessRepresentable { public typealias OppositeSigned = Int32 }
extension Int32: SignednessRepresentable { public typealias OppositeSigned = UInt32 }
extension UInt64: SignednessRepresentable { public typealias OppositeSigned = Int64 }
extension Int64: SignednessRepresentable { public typealias OppositeSigned = UInt64 }
extension UInt: SignednessRepresentable { public typealias OppositeSigned = Int }
extension Int: SignednessRepresentable { public typealias OppositeSigned = UInt }
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension UInt128: SignednessRepresentable { public typealias OppositeSigned = Int128 }
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Int128: SignednessRepresentable { public typealias OppositeSigned = UInt128 }

/// Unsigned 128-bit integer backed by a fixed 16-byte storage. It's a backward-compatible version of native `UInt128`.
public typealias UInt128Backport = AnyInt<Byte16, UInt64>
/// Signed 128-bit integer backed by a fixed 16-byte storage. It's a backward-compatible version of native `Int128`.
public typealias Int128Backport = AnyInt<Byte16, Int64>

/// Unsigned 256-bit integer backed by a fixed 32-byte storage.
public typealias UInt256 = AnyInt<Byte32, UInt64>
/// Signed 256-bit integer backed by a fixed 32-byte storage.
public typealias Int256 = AnyInt<Byte32, Int64>
/// Unsigned 512-bit integer backed by a fixed 64-byte storage.
public typealias UInt512 = AnyInt<Byte64, UInt64>
/// Signed 512-bit integer backed by a fixed 64-byte storage.
public typealias Int512 = AnyInt<Byte64, Int64>
/// Unsigned 1024-bit integer backed by a fixed 128-byte storage.
public typealias UInt1024 = AnyInt<Byte128, UInt64>
/// Signed 1024-bit integer backed by a fixed 128-byte storage.
public typealias Int1024 = AnyInt<Byte128, Int64>
/// Unsigned 2048-bit integer backed by a fixed 256-byte storage.
public typealias UInt2048 = AnyInt<Byte256, UInt64>
/// Signed 2048-bit integer backed by a fixed 256-byte storage.
public typealias Int2048 = AnyInt<Byte256, Int64>
/// Unsigned 4096-bit integer backed by a fixed 512-byte storage.
public typealias UInt4096 = AnyInt<Byte512, UInt64>
/// Signed 4096-bit integer backed by a fixed 512-byte storage.
public typealias Int4096 = AnyInt<Byte512, Int64>
/// Unsigned 8192-bit integer backed by a fixed 1024-byte storage.
public typealias UInt8192 = AnyInt<Byte1024, UInt64>
/// Signed 8192-bit integer backed by a fixed 1024-byte storage.
public typealias Int8192 = AnyInt<Byte1024, Int64>
/// Unsigned 16384-bit integer backed by a fixed 2048-byte storage.
public typealias UInt16384 = AnyInt<Byte2048, UInt64>
/// Signed 16384-bit integer backed by a fixed 2048-byte storage.
public typealias Int16384 = AnyInt<Byte2048, Int64>

/// Arbitrary-precision unsigned integer using growable `[UInt8]` storage.
public typealias BigUInt = AnyInt<[UInt8], UInt64>
/// Arbitrary-precision signed integer using growable `[UInt8]` storage.
public typealias BigInt = AnyInt<[UInt8], Int64>

/// Signed big integer limited to 16 bytes of storage.
public typealias LimitedBigInt128 = AnyInt<LimitedDynamicStorage16, Int64>
/// Unsigned big integer limited to 16 bytes of storage.
public typealias LimitedBigUInt128 = AnyInt<LimitedDynamicStorage16, UInt64>
/// Signed big integer limited to 32 bytes of storage.
public typealias LimitedBigInt256 = AnyInt<LimitedDynamicStorage32, Int64>
/// Unsigned big integer limited to 32 bytes of storage.
public typealias LimitedBigUInt256 = AnyInt<LimitedDynamicStorage32, UInt64>
/// Signed big integer limited to 64 bytes of storage.
public typealias LimitedBigInt512 = AnyInt<LimitedDynamicStorage64, Int64>
/// Unsigned big integer limited to 64 bytes of storage.
public typealias LimitedBigUInt512 = AnyInt<LimitedDynamicStorage64, UInt64>
/// Signed big integer limited to 128 bytes of storage.
public typealias LimitedBigInt1024 = AnyInt<LimitedDynamicStorage128, Int64>
/// Unsigned big integer limited to 128 bytes of storage.
public typealias LimitedBigUInt1024 = AnyInt<LimitedDynamicStorage128, UInt64>
/// Signed big integer limited to 256 bytes of storage.
public typealias LimitedBigInt2048 = AnyInt<LimitedDynamicStorage256, Int64>
/// Unsigned big integer limited to 256 bytes of storage.
public typealias LimitedBigUInt2048 = AnyInt<LimitedDynamicStorage256, UInt64>
/// Signed big integer limited to 512 bytes of storage.
public typealias LimitedBigInt4096 = AnyInt<LimitedDynamicStorage512, Int64>
/// Unsigned big integer limited to 512 bytes of storage.
public typealias LimitedBigUInt4096 = AnyInt<LimitedDynamicStorage512, UInt64>
/// Signed big integer limited to 1 kB of storage.
public typealias LimitedBigInt8192 = AnyInt<LimitedDynamicStorage1024, Int64>
/// Unsigned big integer limited to 1 kB of storage.
public typealias LimitedBigUInt8192 = AnyInt<LimitedDynamicStorage1024, UInt64>
/// Signed big integer limited to 2 kB of storage.
public typealias LimitedBigInt16384 = AnyInt<LimitedDynamicStorage2048, Int64>
/// Unsigned big integer limited to 2 kB of storage.
public typealias LimitedBigUInt16384 = AnyInt<LimitedDynamicStorage2048, UInt64>

/// Generic arbitrary-precision integer backed by pluggable byte storage.
/// `Storage` defines the byte container (fixed or growable); `Signedness` carries signedness.
public struct AnyInt<
    Storage: BytesStorage,
    Signedness: SignednessRepresentable
>: BinaryInteger,
    Comparable,
    Sendable
{
    public static var isSigned: Bool { Signedness.isSigned }
    public var storage: Storage

    public typealias Magnitude = AnyInt<Storage, Signedness.Magnitude>
    public typealias IntegerLiteralType = Signedness

    public var magnitude: Magnitude {
        var storage = self.storage
        if Self.isSigned, self < 0 {
            storage.negate()
        }
        return Magnitude(storage: storage)
    }

    public static var zero: Self {
        Self(0)
    }

    public var words: Words { Words(bytes: storage) }
    public var bitWidth: Int { storage.count * 8 }
    public var exactBitWidth: Int { 
        bitWidth - (storage.last?.leadingZeroBitCount ?? 0)
    }

    public var leadingZeroBitCount: Int {
        guard !storage.isEmpty else { return bitWidth }
        var count = 0
        for byte in storage.reversed() {
            if byte == 0 {
                count += 8
            } else {
                count += byte.leadingZeroBitCount
                break
            }
        }
        return count
    }

    public var trailingZeroBitCount: Int {
        guard !storage.isEmpty else { return bitWidth }
        var count = 0
        for byte in storage {
            if byte == 0 {
                count += 8
            } else {
                count += byte.trailingZeroBitCount
                break
            }
        }
        return count
    }

    public init(clamping bytes: [UInt8]) {
        storage = Storage(clamping: bytes)
    }

    public init(storage: Storage) {
        self.storage = storage
    }

    public init<T>(_ source: T) where T: BinaryInteger {
        var bytes: [UInt8] = []
        for word in source.words {
            var w = word
            for _ in 0 ..< MemoryLayout<UInt>.size {
                bytes.append(UInt8(truncatingIfNeeded: w))
                w >>= 8
            }
        }

        // For limited (fixed-width) storages, extend the sign bit so that
        // negative values occupy the full storage width in two's complement.
        if let limit = Self.storageLimit {
            let isNegativeSource = source < 0
            let extensionByte: UInt8
            if Self.isSigned && isNegativeSource {
                extensionByte = 0xFF
            } else {
                extensionByte = 0x00
            }
            if bytes.count < limit {
                bytes.append(contentsOf: repeatElement(extensionByte, count: limit - bytes.count))
            }
        }

        storage = Storage(clamping: bytes)
    }

    public init<T>(clamping source: T) where T: BinaryInteger {
        self.init(source)
    }

    public init?<T>(exactly source: T) where T: BinaryInteger {
        if let fixed = (T.self as? any FixedBytesStorage.Type)?.byteCount, source.bitWidth * 8 > fixed {
            return nil
        }
        self.init(source)
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }

    public init?<T>(exactly source: T) where T: BinaryFloatingPoint {
        guard source.isFinite else { return nil }
        let rounded = source.rounded(.towardZero)
        guard rounded == source else { return nil }

        let isNegative = source < 0
        var value = isNegative ? -rounded : rounded
        var bytes: [UInt8] = []

        // Determine max bytes considering both FixedBytesStorage and LimitedBytesStorage
        let maxBytes: Int
        if let fixedType = Storage.self as? any FixedBytesStorage.Type {
            maxBytes = fixedType.byteCount
        } else if let limitedType = Storage.self as? any LimitedBytesStorage.Type {
            maxBytes = limitedType.byteCount
        } else {
            maxBytes = Int.max
        }

        var previousValue = value
        while value > 0 && bytes.count < maxBytes {
            let byte = UInt8(value.truncatingRemainder(dividingBy: 256))
            bytes.append(byte)
            previousValue = value
            value = (value / 256).rounded(.towardZero)
            
            // Check for precision loss: if value didn't decrease by approximately byte/256, we lost precision
            // This is a heuristic check for floating point precision issues
            if value >= previousValue && bytes.count > 1 {
                // Likely precision loss, verify by checking if we can reconstruct
                var reconstructed: T = 0
                var multiplier: T = 1
                for byte in bytes.reversed() {
                    reconstructed += T(byte) * multiplier
                    multiplier *= 256
                    // If multiplier becomes too large, we've exceeded precision
                    if multiplier.isInfinite || multiplier.isNaN {
                        return nil
                    }
                }
                // If reconstructed value doesn't match original, we lost precision
                if abs(reconstructed - previousValue) > previousValue * T.ulpOfOne * 10 {
                    return nil
                }
            }
        }

        if value > 0 {
            return nil
        }

        storage = Storage(clamping: bytes)

        if Self.isSigned && isNegative {
            storage.negate()
        } else if !Self.isSigned && isNegative {
            return nil
        }
    }

    public init<T>(_ source: T) where T: BinaryFloatingPoint {
        guard let value = Self(exactly: source.rounded(.towardZero)) else {
            fatalError("value cannot be converted to AnyInt because it is outside the representable range")
        }
        self = value
    }

    public init<T>(truncatingIfNeeded source: T) where T: BinaryInteger {
        self.init(source)
    }
    
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        let (result, overflow) = lhs.addingReportingOverflow(rhs)
        if overflow {
            fatalError("Overflow occurred during addition.")
        }
        return result
    }
    
    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        let (result, overflow) = lhs.subtractingReportingOverflow(rhs)
        if overflow {
            fatalError("Overflow occurred during subtraction.")
        }
        return result
    }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        let (result, overflow) = lhs.multipliedReportingOverflow(by: rhs)
        if overflow {
            fatalError("Overflow occurred during multiplication.")
        }
        return result
    }
    
    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Self {
        let (result, overflow) = lhs.dividedReportingOverflow(by: rhs)
        if overflow {
            fatalError("Overflow occurred during division.")
        }
        return result
    }
    
    @inlinable
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }
    
    @inlinable
    public static func % (lhs: Self, rhs: Self) -> Self {
        let (result, overflow) = lhs.remainderReportingOverflow(dividingBy: rhs)
        if overflow {
            fatalError("Overflow occurred during remainder operation.")
        }
        return result
    }
    
    @inlinable
    public static func %= (lhs: inout Self, rhs: Self) {
        lhs = lhs % rhs
    }
    
    @inlinable
    public static func &= (lhs: inout Self, rhs: Self) {
        let targetCount = Swift.max(lhs.storage.count, rhs.storage.count)
        if targetCount == 0 { return }
        guard Self.ensureStorageCapacity(&lhs.storage, count: targetCount, signExtendingFrom: lhs.storage) else {
            fatalError("Overflow occurred during bitwise AND.")
        }

        for i in 0 ..< targetCount {
            let rhsByte = i < rhs.storage.count ? rhs.storage[i] : Self.extensionByte(for: rhs.storage)
            lhs.storage[i] &= rhsByte
        }
        Self.trimStorage(&lhs.storage)
    }
    
    @inlinable
    public static func |= (lhs: inout Self, rhs: Self) {
        let targetCount = Swift.max(lhs.storage.count, rhs.storage.count)
        if targetCount == 0 { return }
        guard Self.ensureStorageCapacity(&lhs.storage, count: targetCount, signExtendingFrom: lhs.storage) else {
            fatalError("Overflow occurred during bitwise OR.")
        }

        for i in 0 ..< targetCount {
            let rhsByte = i < rhs.storage.count ? rhs.storage[i] : Self.extensionByte(for: rhs.storage)
            lhs.storage[i] |= rhsByte
        }
        Self.trimStorage(&lhs.storage)
    }

    @inlinable
    public static func ^= (lhs: inout Self, rhs: Self) {
        let targetCount = Swift.max(lhs.storage.count, rhs.storage.count)
        if targetCount == 0 { return }
        guard Self.ensureStorageCapacity(&lhs.storage, count: targetCount, signExtendingFrom: lhs.storage) else {
            fatalError("Overflow occurred during bitwise XOR.")
        }

        for i in 0 ..< targetCount {
            let rhsByte = i < rhs.storage.count ? rhs.storage[i] : Self.extensionByte(for: rhs.storage)
            lhs.storage[i] ^= rhsByte
        }
        Self.trimStorage(&lhs.storage)
    }

    @inlinable
    public static func >>= <RHS>(lhs: inout Self, rhs: RHS) where RHS: BinaryInteger {
        guard let shiftAmount = Int(exactly: rhs) else {
            return
        }
    
        guard shiftAmount > 0 else { 
            lhs <<= -shiftAmount
            return
        }

        let originalStorage = lhs.storage
        let count = originalStorage.count
        guard count > 0 else { return }

        let signByte = Self.extensionByte(for: originalStorage)
        let byteShift = shiftAmount >> 3
        guard byteShift.magnitude < count else {
            lhs = .zero
            return
        }

        let bitShift = shiftAmount & 7
        var result = originalStorage

        for i in 0 ..< count {
            let srcIndex = i + byteShift
            let nextIndex = srcIndex + 1

            let low = srcIndex < count ? originalStorage[srcIndex] : signByte
            var byte = low >> bitShift
            if bitShift > 0 {
                let high = nextIndex < count ? originalStorage[nextIndex] : signByte
                byte |= high << (8 - bitShift)
            }
            result[i] = byte
        }

        lhs.storage = result
        Self.trimStorage(&lhs.storage)
    }

    @inlinable
    public static func <<= <RHS>(lhs: inout Self, rhs: RHS) where RHS: BinaryInteger {
        guard let shiftAmount = Int(exactly: rhs) else {
            lhs = 0 // rhs is too large to represent; shifting to zero
            return
        }

        guard shiftAmount > 0 else {
            lhs >>= -shiftAmount
            return
        }

        let byteShift = shiftAmount >> 3
        let bitShift = shiftAmount & 7

        if let limit = Self.storageLimit, byteShift >= limit {
            lhs = .zero
            return
        }

        // Calculate the number of bytes needed after the shift
        let bitsNeeded = ((lhs.storage.count << 3) - lhs.leadingZeroBitCount) + shiftAmount
        let bytesNeeded = (bitsNeeded + 7) >> 3
        let targetCount = Swift.max(lhs.storage.count, bytesNeeded)

        // Extend storage if needed
        if targetCount > lhs.storage.count {
            Self.extendStorageCapacity(
                &lhs.storage,
                count: targetCount,
                signExtendingFrom: lhs.storage
            )
        }

        for i in stride(from: lhs.storage.count - 1, through: 0, by: -1) {
            if i >= byteShift {
                var byte = lhs.storage[i - byteShift] << bitShift
                if i > byteShift && bitShift > 0 {
                    byte |= lhs.storage[i - byteShift - 1] >> (8 - bitShift)
                }
                lhs.storage[i] = byte
            } else {
                lhs.storage[i] = 0
            }
        }
        Self.trimStorage(&lhs.storage)
    }

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if isSigned {
            let lhsNeg = (lhs.storage.last ?? 0) & 0x80 != 0
            let rhsNeg = (rhs.storage.last ?? 0) & 0x80 != 0
            if lhsNeg != rhsNeg {
                return lhsNeg
            }
        }

        let maxCount = Swift.max(lhs.storage.count, rhs.storage.count)
        for i in stride(from: maxCount - 1, through: 0, by: -1) {
            let lhsByte = i < lhs.storage.count ? lhs.storage[i] : Self.extensionByte(for: lhs.storage)
            let rhsByte = i < rhs.storage.count ? rhs.storage[i] : Self.extensionByte(for: rhs.storage)
            if lhsByte < rhsByte { return true }
            if lhsByte > rhsByte { return false }
        }
        return false
    }

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        let maxCount = Swift.max(lhs.storage.count, rhs.storage.count)
        for i in 0 ..< maxCount {
            let lhsByte = i < lhs.storage.count ? lhs.storage[i] : Self.extensionByte(for: lhs.storage)
            let rhsByte = i < rhs.storage.count ? rhs.storage[i] : Self.extensionByte(for: rhs.storage)
            if lhsByte != rhsByte { return false }
        }
        return true
    }
    
    @inlinable
    public static prefix func ~ (x: Self) -> Self {
        var result = x
        for i in 0 ..< result.storage.count {
            result.storage[i] = ~result.storage[i]
        }
        return result
    }

    public struct Words: RandomAccessCollection {
        public typealias Element = UInt
        public typealias Index = Int

        public let bytes: Storage
        public var startIndex: Int { 0 }
        public var endIndex: Int {
            (bytes.count + MemoryLayout<UInt>.size - 1) / MemoryLayout<UInt>.size
        }

        public subscript(position: Int) -> UInt {
            var word: UInt = 0
            let byteCount = MemoryLayout<UInt>.size
            for i in 0 ..< byteCount {
                let byteIndex = position * byteCount + i
                let byte: UInt8
                if byteIndex < bytes.count {
                    byte = bytes[byteIndex]
                } else {
                    // Sign‑extend for negative signed integers; zero‑extend otherwise.
                    let signByte: UInt8
                    if Signedness.isSigned, let last = bytes.last, (last & 0x80) != 0 {
                        signByte = 0xFF
                    } else {
                        signByte = 0
                    }
                    byte = signByte
                }
                word |= UInt(byte) << (i * 8)
            }
            return word
        }
    }
}

extension AnyInt {
    
    @usableFromInline
    static var storageLimit: Int? {
        (Storage.self as? any LimitedBytesStorage.Type)?.byteCount
    }

    @usableFromInline
    static func extensionByte(for template: Storage) -> UInt8 {
        guard isSigned, let last = template.last else { return 0 }
        return (last & 0x80) != 0 ? 0xFF : 0
    }

    @usableFromInline
    static func extendStorageCapacity(
        _ storage: inout Storage,
        count: Int,
        signExtendingFrom template: Storage
    ) {
        var needed = count
        if let storageLimit {
            needed = Swift.min(needed, storageLimit)
        }
        _ = ensureStorageCapacity(&storage, count: needed, signExtendingFrom: template)
    }

    @usableFromInline
    static func ensureStorageCapacity(
        _ storage: inout Storage,
        count: Int,
        signExtendingFrom template: Storage
    ) -> Bool {
        let needed = count
        if needed <= storage.count {
            return true
        }

        if let limit = storageLimit, needed > limit {
            return false
        }

        let fill = extensionByte(for: template)
        let extra = needed - storage.count
        storage.replaceSubrange(storage.endIndex ..< storage.endIndex, with: repeatElement(fill, count: extra))
        return true
    }

    @usableFromInline
    static func trimStorage(_ storage: inout Storage) {
        // Only trim variable-width storages; fixed-width must preserve byteCount.
        guard !(Storage.self is any FixedBytesStorage.Type) else { return }
        guard storage.count > 0 else { return }

        let signByte = extensionByte(for: storage)
        
        // Find the index from the end where trimming should stop
        var trimCount = 0
        for i in stride(from: storage.count - 1, through: 1, by: -1) {
            let last = storage[i]
            let prev = storage[i - 1]
            let prevSignBit = (prev & 0x80) != 0
            let lastSignBit = (signByte & 0x80) != 0

            // Stop if last byte is not pure sign extension or trimming would change the sign bit of the remaining number.
            if last != signByte || prevSignBit != lastSignBit {
                break
            }
            trimCount += 1
        }
        
        // Remove all trailing sign extension bytes in one operation
        if trimCount > 0 {
            let newEndIndex = storage.count - trimCount
            storage.removeSubrange(newEndIndex ..< storage.count)
        }
    }
}

/// Negation operator for unsigned AnyInt types, returning signed counterpart.
@inlinable
public prefix func - <S: BytesStorage, L: SignednessRepresentable & UnsignedInteger>(value: AnyInt<S, L>) -> AnyInt<S, L.OppositeSigned> {
    var result = value.storage
    result.negate()
    return AnyInt<S, L.OppositeSigned>(storage: result)
}

extension BytesStorage {
    @usableFromInline
    mutating func negate() {
        // Two's complement negation
        var carry: UInt8 = 1
        for i in 0 ..< count {
            let inverted = ~self[i]
            let (newByte, overflow) = inverted.addingReportingOverflow(carry)
            self[i] = newByte
            carry = overflow ? 1 : 0
        }
    }
}

extension AnyInt: UnsignedInteger where Signedness: UnsignedInteger {}

extension AnyInt: SignedNumeric where Signedness: SignedInteger {
    @inlinable
    public static prefix func - (value: Self) -> Self {
        var result = value
        result.negate()
        return result
    }

    @inlinable
    public mutating func negate() {
        storage.negate()
    }
}

extension AnyInt: SignedInteger where Signedness: SignedInteger {}

extension AnyInt: LosslessStringConvertible {

    public var description: String {
        if self == 0 {
            return "0"
        }

        var digits: [Character] = []
        var value = magnitude
        let isNegative = Self.isSigned && self < 0

        while value > 0 {
            let (quotient, remainder, _) = value.dividedWithRemainderReportingOverflow(by: 10)
            // Extract the digit correctly - remainder is guaranteed to be < 10
            // Convert remainder to Int by extracting its value properly
            var digitValue: Int = 0
            if !remainder.storage.isEmpty {
                // For small remainders (< 256), first byte is sufficient
                // For larger, we need to handle properly, but remainder % 10 is always < 10
                digitValue = Int(remainder.storage[0])
            }
            digits.append(Character("\(digitValue)"))
            value = quotient
        }

        if isNegative {
            digits.append("-")
        }
        
        return String(digits.reversed())
    }

    public init?(_ description: String) {
        var str = description
        let isNegative = str.hasPrefix("-")
        if isNegative {
            guard Self.isSigned else { return nil }
            str.removeFirst()
        }

        guard !str.isEmpty else { return nil }

        var result = Self(0)

        for char in str {
            guard let digit = char.wholeNumberValue else { return nil }
            
            let (multiplied, overflow) = result.multipliedReportingOverflow(by: 10)
            guard !overflow else { return nil }
            let (added, overflow2) = multiplied.addingReportingOverflow(Self(digit))
            guard !overflow2 else { return nil }
            result = added
        }

        if isNegative {
            result.storage.negate()
        }

        self = result
    }
}

extension AnyInt: CustomDebugStringConvertible {

    public var debugDescription: String { description }
}

public extension AnyInt {
    
    var nonzeroBitCount: Int {
        storage.reduce(0) { count, byte in
            count + byte.nonzeroBitCount
        }
    }

    var byteSwapped: Self {
        var swappedStorage = storage
        swappedStorage.replaceSubrange(swappedStorage.startIndex ..< swappedStorage.endIndex, with: storage.reversed())
        return Self(storage: swappedStorage)
    }
}

public extension AnyInt {

    func addingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
        let lhsStorage = self.storage
        let rhsStorage = rhs.storage

        // Include an extra byte to capture a possible carry.
        let workingCount = Swift.max(lhsStorage.count, rhsStorage.count) + 1
        let lhsExtension = Self.extensionByte(for: lhsStorage)
        let rhsExtension = Self.extensionByte(for: rhsStorage)

        var resultBytes: [UInt8] = []
        resultBytes.reserveCapacity(workingCount)

        var carry: UInt16 = 0
        for index in 0 ..< workingCount {
            let lhsByte = index < lhsStorage.count ? lhsStorage[index] : lhsExtension
            let rhsByte = index < rhsStorage.count ? rhsStorage[index] : rhsExtension

            let sum = UInt16(lhsByte) &+ UInt16(rhsByte) &+ carry
            resultBytes.append(UInt8(truncatingIfNeeded: sum))
            carry = sum >> 8
        }

        let storageLimit = Self.storageLimit ?? Int.max
        let bytesToStore = Swift.min(resultBytes.count, storageLimit)
        let bytesSlice = bytesToStore == resultBytes.count ? resultBytes : Array(resultBytes.prefix(bytesToStore))
        var resultStorage = Storage(clamping: bytesSlice)

        var overflow = false
        if resultBytes.count > storageLimit {
            let signByte = resultBytes[Swift.min(bytesToStore, resultBytes.count) - 1]
            let expectedExtension: UInt8
            if Self.isSigned && (signByte & 0x80) != 0 {
                expectedExtension = 0xFF
            } else {
                expectedExtension = 0x00
            }

            for byte in resultBytes[storageLimit...] {
                if byte != expectedExtension {
                    overflow = true
                    break
                }
            }
        }

        Self.trimStorage(&resultStorage)
        return (Self(storage: resultStorage), overflow)
    }

    func subtractingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool) {
        let lhsStorage = self.storage
        let rhsStorage = rhs.storage

        // One extra byte to capture a possible borrow.
        let workingCount = Swift.max(lhsStorage.count, rhsStorage.count) + 1
        let lhsExtension = Self.extensionByte(for: lhsStorage)
        let rhsExtension = Self.extensionByte(for: rhsStorage)

        var resultBytes: [UInt8] = []
        resultBytes.reserveCapacity(workingCount)

        var borrow: Int16 = 0
        for index in 0 ..< workingCount {
            let lhsByte = index < lhsStorage.count ? lhsStorage[index] : lhsExtension
            let rhsByte = index < rhsStorage.count ? rhsStorage[index] : rhsExtension

            let diff = Int16(lhsByte) - Int16(rhsByte) - borrow
            if diff < 0 {
                resultBytes.append(UInt8(truncatingIfNeeded: diff &+ 256))
                borrow = 1
            } else {
                resultBytes.append(UInt8(truncatingIfNeeded: diff))
                borrow = 0
            }
        }

        let storageLimit = Self.storageLimit ?? Int.max
        let bytesToStore = Swift.min(resultBytes.count, storageLimit)
        let bytesSlice = bytesToStore == resultBytes.count ? resultBytes : Array(resultBytes.prefix(bytesToStore))
        var resultStorage = Storage(clamping: bytesSlice)

        var overflow = false
        if resultBytes.count > storageLimit {
            let signByte = resultBytes[Swift.min(bytesToStore, resultBytes.count) - 1]
            let expectedExtension: UInt8
            if Self.isSigned && (signByte & 0x80) != 0 {
                expectedExtension = 0xFF
            } else {
                expectedExtension = 0x00
            }

            for byte in resultBytes[storageLimit...] {
                if byte != expectedExtension {
                    overflow = true
                    break
                }
            }
        }

        Self.trimStorage(&resultStorage)
        return (Self(storage: resultStorage), overflow)
    }

    func multipliedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
        let lhsStorage = self.storage
        let rhsStorage = rhs.storage

        let lhsIsNegative = Self.isSigned && ((lhsStorage.last ?? 0) & 0x80) != 0
        let rhsIsNegative = Self.isSigned && ((rhsStorage.last ?? 0) & 0x80) != 0
        let resultShouldBeNegative = lhsIsNegative != rhsIsNegative

        // Work with magnitudes (unsigned representations).
        let lhsMagnitude = lhsIsNegative ? self.magnitude.storage : lhsStorage
        let rhsMagnitude = rhsIsNegative ? rhs.magnitude.storage : rhsStorage

        // Early return for zero multiplicands.
        if lhsMagnitude.allSatisfy({ $0 == 0 }) || rhsMagnitude.allSatisfy({ $0 == 0 }) {
            return (Self.zero, false)
        }

        let lhsCount = lhsMagnitude.count
        let rhsCount = rhsMagnitude.count
        var resultBytes = Array<UInt8>(repeating: 0, count: lhsCount + rhsCount)

        for i in 0 ..< lhsCount {
            var carry: UInt16 = 0
            let lhsByte = UInt16(lhsMagnitude[i])
            for j in 0 ..< rhsCount {
                let index = i + j
                let existing = UInt16(resultBytes[index])
                let rhsByte = UInt16(rhsMagnitude[j])
                let product = lhsByte * rhsByte + existing + carry
                resultBytes[index] = UInt8(truncatingIfNeeded: product)
                carry = product >> 8
            }
            var k = i + rhsCount
            while carry > 0 {
                if k >= resultBytes.count {
                    resultBytes.append(0)
                }
                let sum = UInt16(resultBytes[k]) + carry
                resultBytes[k] = UInt8(truncatingIfNeeded: sum)
                carry = sum >> 8
                k += 1
            }
        }

        // Apply sign if needed.
        if resultShouldBeNegative {
            // Make space for a potential carry during two's complement.
            resultBytes.append(0)
            for idx in 0 ..< resultBytes.count {
                resultBytes[idx] = ~resultBytes[idx]
            }
            var carry: UInt16 = 1
            for idx in 0 ..< resultBytes.count {
                let sum = UInt16(resultBytes[idx]) + carry
                resultBytes[idx] = UInt8(truncatingIfNeeded: sum)
                carry = sum >> 8
                if carry == 0 { break }
            }
            if carry > 0 {
                resultBytes.append(UInt8(truncatingIfNeeded: carry))
            }
        }

        let storageLimit = Self.storageLimit ?? Int.max
        let bytesToStore = Swift.min(resultBytes.count, storageLimit)
        let bytesSlice = bytesToStore == resultBytes.count ? resultBytes : Array(resultBytes.prefix(bytesToStore))
        var resultStorage = Storage(clamping: bytesSlice)

        var overflow = false
        if resultBytes.count > storageLimit {
            let signByte = resultBytes[Swift.min(bytesToStore, resultBytes.count) - 1]
            let expectedExtension: UInt8
            if Self.isSigned && (signByte & 0x80) != 0 {
                expectedExtension = 0xFF
            } else {
                expectedExtension = 0x00
            }

            for byte in resultBytes[storageLimit...] {
                if byte != expectedExtension {
                    overflow = true
                    break
                }
            }
        }

        Self.trimStorage(&resultStorage)
        return (Self(storage: resultStorage), overflow)
    }

    // TODO: https://habr.com/ru/companies/ruvds/articles/836054/
    func dividedWithRemainderReportingOverflow(by rhs: Self) -> (partialValue: Self, remainder: Self, overflow: Bool) {
        // Division by zero: signal overflow, return zeros.
        if rhs == Self.zero {
            return (self, Self.zero, true)
        }

        let lhsNegative = Self.isSigned && self < 0
        let rhsNegative = Self.isSigned && rhs < 0
        let quotientNegative = lhsNegative != rhsNegative
        let remainderNegative = lhsNegative

        let lhsMagnitude = Array(self.magnitude.storage)
        let rhsMagnitude = Array(rhs.magnitude.storage)

        func isZero(_ bytes: [UInt8]) -> Bool {
            bytes.allSatisfy { $0 == 0 }
        }

        func trimZeros(_ bytes: [UInt8]) -> [UInt8] {
            var result = bytes
            while result.count > 1, result.last == 0 {
                result.removeLast()
            }
            return result
        }

        func bitLength(_ bytes: [UInt8]) -> Int {
            let trimmed = trimZeros(bytes)
            guard let last = trimmed.last else { return 0 }
            var leading = 8
            var value = last
            while value != 0 {
                value >>= 1
                leading -= 1
            }
            return (trimmed.count - 1) * 8 + (8 - leading)
        }

        func compare(_ lhs: [UInt8], _ rhs: [UInt8]) -> Int {
            let l = trimZeros(lhs)
            let r = trimZeros(rhs)
            if l.count != r.count {
                return l.count < r.count ? -1 : 1
            }
            for i in stride(from: l.count - 1, through: 0, by: -1) {
                if l[i] != r[i] {
                    return l[i] < r[i] ? -1 : 1
                }
            }
            return 0
        }

        func subtract(_ lhs: [UInt8], _ rhs: [UInt8]) -> [UInt8] {
            var result = lhs
            var borrow: Int16 = 0
            let count = Swift.max(lhs.count, rhs.count)
            for i in 0 ..< count {
                let lhsByte = i < result.count ? result[i] : 0
                let rhsByte = i < rhs.count ? rhs[i] : 0
                var diff = Int16(lhsByte) - Int16(rhsByte) - borrow
                if diff < 0 {
                    diff += 256
                    borrow = 1
                } else {
                    borrow = 0
                }
                if i < result.count {
                    result[i] = UInt8(truncatingIfNeeded: diff)
                } else {
                    result.append(UInt8(truncatingIfNeeded: diff))
                }
            }
            return trimZeros(result)
        }

        func shiftLeft(_ bytes: [UInt8], by shift: Int) -> [UInt8] {
            guard shift > 0 else { return bytes }
            let byteShift = shift / 8
            let bitShift = shift % 8
            var result = Array<UInt8>(repeating: 0, count: bytes.count + byteShift + 1)
            for i in 0 ..< bytes.count {
                let shiftedIndex = i + byteShift
                let value = bytes[i]
                result[shiftedIndex] &+= value << bitShift
                if bitShift > 0 {
                    result[shiftedIndex + 1] &+= value >> (8 - bitShift)
                }
            }
            return trimZeros(result)
        }

        func setBit(_ bytes: inout [UInt8], at position: Int) {
            let byteIndex = position / 8
            let bitIndex = position % 8
            if byteIndex >= bytes.count {
                bytes.append(contentsOf: repeatElement(0, count: byteIndex - bytes.count + 1))
            }
            bytes[byteIndex] |= 1 << bitIndex
        }

        func applySign(to magnitude: [UInt8], negative: Bool) -> [UInt8] {
            guard negative, !isZero(magnitude) else { return magnitude }
            var bytes = magnitude
            for i in 0 ..< bytes.count { bytes[i] = ~bytes[i] }
            var carry: UInt16 = 1
            for i in 0 ..< bytes.count {
                let sum = UInt16(bytes[i]) + carry
                bytes[i] = UInt8(truncatingIfNeeded: sum)
                carry = sum >> 8
                if carry == 0 { break }
            }
            if carry > 0 { bytes.append(UInt8(truncatingIfNeeded: carry)) }
            return bytes
        }

        func buildResult(from bytes: [UInt8]) -> (Self, Bool) {
            let storageLimit = Self.storageLimit ?? Int.max

            // For fixed/limited-width storages, pad with sign extension so that
            // negative results occupy the full width in two's complement.
            var paddedBytes = bytes
            if let limit = Self.storageLimit, paddedBytes.count < limit {
                let isNegative = Self.isSigned && (bytes.last ?? 0) & 0x80 != 0
                let extensionByte: UInt8 = isNegative ? 0xFF : 0x00
                paddedBytes += repeatElement(extensionByte, count: limit - paddedBytes.count)
            }

            let bytesToStore = Swift.min(paddedBytes.count, storageLimit)
            let slice = bytesToStore == paddedBytes.count ? paddedBytes : Array(paddedBytes.prefix(bytesToStore))
            var storage = Storage(clamping: slice)

            var overflow = false
            if paddedBytes.count > storageLimit {
                let signByte = slice[Swift.min(bytesToStore, slice.count) - 1]
                let expectedExtension: UInt8 = (Self.isSigned && (signByte & 0x80) != 0) ? 0xFF : 0x00
                for byte in paddedBytes[storageLimit...] where byte != expectedExtension {
                    overflow = true
                    break
                }
            }

            Self.trimStorage(&storage)
            return (Self(storage: storage), overflow)
        }

        // Handle simple cases.
        if compare(lhsMagnitude, rhsMagnitude) < 0 || isZero(lhsMagnitude) {
            // quotient = 0, remainder = lhs
            let remainderBytes = applySign(to: trimZeros(lhsMagnitude), negative: remainderNegative && !isZero(lhsMagnitude))
            let (remainderValue, remainderOverflow) = buildResult(from: remainderBytes)
            return (Self.zero, remainderValue, remainderOverflow)
        }

        // Long division on magnitudes.
        let divisor = trimZeros(rhsMagnitude)
        var remainder = trimZeros(lhsMagnitude)
        let dividendBits = bitLength(remainder)
        let divisorBits = bitLength(divisor)
        let maxShift = Swift.max(0, dividendBits - divisorBits)

        var quotientBytes: [UInt8] = []
        for shift in stride(from: maxShift, through: 0, by: -1) {
            let shiftedDivisor = shiftLeft(divisor, by: shift)
            if compare(remainder, shiftedDivisor) >= 0 {
                remainder = subtract(remainder, shiftedDivisor)
                setBit(&quotientBytes, at: shift)
            }
        }

        let signedQuotientBytes = applySign(to: trimZeros(quotientBytes), negative: quotientNegative)
        let signedRemainderBytes = applySign(to: trimZeros(remainder), negative: remainderNegative && !isZero(remainder))

        let (quotientValue, quotientOverflow) = buildResult(from: signedQuotientBytes)
        let (remainderValue, remainderOverflow) = buildResult(from: signedRemainderBytes)

        return (quotientValue, remainderValue, quotientOverflow || remainderOverflow)
    }

    func dividedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool) {
        let (quotient, _, overflow) = self.dividedWithRemainderReportingOverflow(by: rhs)
        return (quotient, overflow)
    }

    func remainderReportingOverflow(dividingBy rhs: Self) -> (partialValue: Self, overflow: Bool) {
        let (_, remainder, overflow) = self.dividedWithRemainderReportingOverflow(by: rhs)
        return (remainder, overflow)
    }
}

public extension AnyInt where Storage: LimitedBytesStorage {

    func multipliedFullWidth(by other: Self) -> (high: Self, low: Magnitude) {
        let lhsStorage = self.storage
        let rhsStorage = other.storage

        // Determine working width (single-width in bytes).
        let baseCount = Storage.byteCount

        let lhsNegative = Self.isSigned && self < 0
        let rhsNegative = Self.isSigned && other < 0
        let resultNegative = lhsNegative != rhsNegative

        let lhsMag = lhsNegative ? self.magnitude.storage : lhsStorage
        let rhsMag = rhsNegative ? other.magnitude.storage : rhsStorage

        // Prepare buffers sized to the working width.
        var lhsBytes = Array(lhsMag.prefix(baseCount))
        lhsBytes += repeatElement(Self.extensionByte(for: lhsMag), count: Swift.max(0, baseCount - lhsBytes.count))
        var rhsBytes = Array(rhsMag.prefix(baseCount))
        rhsBytes += repeatElement(Self.extensionByte(for: rhsMag), count: Swift.max(0, baseCount - rhsBytes.count))

        // Long multiplication on unsigned magnitudes.
        var product = Array<UInt8>(repeating: 0, count: baseCount * 2)
        for i in 0 ..< baseCount {
            var carry: UInt16 = 0
            let lhsByte = UInt16(lhsBytes[i])
            for j in 0 ..< baseCount {
                let idx = i + j
                let rhsByte = UInt16(rhsBytes[j])
                let sum = UInt16(product[idx]) + lhsByte * rhsByte + carry
                product[idx] = UInt8(truncatingIfNeeded: sum)
                carry = sum >> 8
            }
            if carry > 0, i + baseCount < product.count {
                product[i + baseCount] = UInt8(truncatingIfNeeded: UInt16(product[i + baseCount]) + carry)
            }
        }

        // Apply sign to the full 2*baseCount product if needed (two's complement).
        if resultNegative {
            for idx in 0 ..< product.count {
                product[idx] = ~product[idx]
            }
            var carry: UInt16 = 1
            for idx in 0 ..< product.count {
                let sum = UInt16(product[idx]) + carry
                product[idx] = UInt8(truncatingIfNeeded: sum)
                carry = sum >> 8
                if carry == 0 { break }
            }
        }

        // Split into low and high parts.
        let lowBytes = Array(product.prefix(baseCount))
        let highBytes = Array(product.dropFirst(baseCount).prefix(baseCount))

        var lowStorage = Storage(clamping: lowBytes)
        var highStorage = Storage(clamping: highBytes)
        Self.trimStorage(&lowStorage)
        Self.trimStorage(&highStorage)

        return (Self(storage: highStorage), Magnitude(storage: lowStorage))
    }

    func dividingFullWidth(_ dividend: (high: Self, low: Magnitude)) -> (quotient: Self, remainder: Self) {
        let divisor = self
        if divisor == 0 {
            fatalError("Division by zero in dividingFullWidth")
        }

        let baseCount = Storage.byteCount

        func extensionByte(for storage: Storage) -> UInt8 {
            Self.extensionByte(for: storage)
        }

        // Build dividend bytes (low first, then high), padded to baseCount each.
        var lowBytes = Array(dividend.low.storage.prefix(baseCount))
        lowBytes += repeatElement(extensionByte(for: dividend.low.storage), count: Swift.max(0, baseCount - lowBytes.count))

        var highBytes = Array(dividend.high.storage.prefix(baseCount))
        highBytes += repeatElement(extensionByte(for: dividend.high.storage), count: Swift.max(0, baseCount - highBytes.count))

        var dividendBytes = lowBytes + highBytes
        let dividendNegative = Self.isSigned && (dividend.high.storage.last ?? 0) & 0x80 != 0

        // Two's complement to get magnitude if negative.
        if dividendNegative {
            for i in 0 ..< dividendBytes.count { dividendBytes[i] = ~dividendBytes[i] }
            var carry: UInt16 = 1
            for i in 0 ..< dividendBytes.count {
                let sum = UInt16(dividendBytes[i]) + carry
                dividendBytes[i] = UInt8(truncatingIfNeeded: sum)
                carry = sum >> 8
                if carry == 0 { break }
            }
        }

        // Divisor magnitude.
        let divisorNegative = Self.isSigned && divisor < 0
        let divisorStorageForBytes = divisorNegative ? divisor.magnitude.storage : divisor.storage
        var divisorBytes = Array(divisorStorageForBytes.prefix(baseCount))
        divisorBytes += repeatElement(extensionByte(for: divisorStorageForBytes), count: Swift.max(0, baseCount - divisorBytes.count))

        func trimZeros(_ bytes: [UInt8]) -> [UInt8] {
            var result = bytes
            while result.count > 1, result.last == 0 { result.removeLast() }
            return result
        }

        func isZero(_ bytes: [UInt8]) -> Bool {
            bytes.allSatisfy { $0 == 0 }
        }

        func compare(_ lhs: [UInt8], _ rhs: [UInt8]) -> Int {
            let l = trimZeros(lhs)
            let r = trimZeros(rhs)
            if l.count != r.count { return l.count < r.count ? -1 : 1 }
            for i in stride(from: l.count - 1, through: 0, by: -1) where l[i] != r[i] {
                return l[i] < r[i] ? -1 : 1
            }
            return 0
        }

        func subtract(_ lhs: [UInt8], _ rhs: [UInt8]) -> [UInt8] {
            var result = lhs
            var borrow: Int16 = 0
            let count = Swift.max(lhs.count, rhs.count)
            for i in 0 ..< count {
                let lhsByte = i < result.count ? result[i] : 0
                let rhsByte = i < rhs.count ? rhs[i] : 0
                var diff = Int16(lhsByte) - Int16(rhsByte) - borrow
                if diff < 0 {
                    diff += 256
                    borrow = 1
                } else {
                    borrow = 0
                }
                if i < result.count {
                    result[i] = UInt8(truncatingIfNeeded: diff)
                } else {
                    result.append(UInt8(truncatingIfNeeded: diff))
                }
            }
            return trimZeros(result)
        }

        func shiftLeft(_ bytes: [UInt8], by shift: Int) -> [UInt8] {
            guard shift > 0 else { return bytes }
            let byteShift = shift / 8
            let bitShift = shift % 8
            var result = Array<UInt8>(repeating: 0, count: bytes.count + byteShift + 1)
            for i in 0 ..< bytes.count {
                let shiftedIndex = i + byteShift
                let value = bytes[i]
                result[shiftedIndex] &+= value << bitShift
                if bitShift > 0 {
                    result[shiftedIndex + 1] &+= value >> (8 - bitShift)
                }
            }
            return trimZeros(result)
        }

        func bitLength(_ bytes: [UInt8]) -> Int {
            let trimmed = trimZeros(bytes)
            guard let last = trimmed.last else { return 0 }
            var msb = 8
            var v = last
            while v != 0 {
                v >>= 1
                msb -= 1
            }
            return (trimmed.count - 1) * 8 + (8 - msb)
        }

        func setBit(_ bytes: inout [UInt8], at position: Int) {
            let byteIndex = position / 8
            let bitIndex = position % 8
            if byteIndex >= bytes.count {
                bytes.append(contentsOf: repeatElement(0, count: byteIndex - bytes.count + 1))
            }
            bytes[byteIndex] |= 1 << bitIndex
        }

        func applySign(to magnitude: [UInt8], negative: Bool) -> [UInt8] {
            guard negative, !isZero(magnitude) else { return magnitude }
            var bytes = magnitude
            for i in 0 ..< bytes.count { bytes[i] = ~bytes[i] }
            var carry: UInt16 = 1
            for i in 0 ..< bytes.count {
                let sum = UInt16(bytes[i]) + carry
                bytes[i] = UInt8(truncatingIfNeeded: sum)
                carry = sum >> 8
                if carry == 0 { break }
            }
            if carry > 0 { bytes.append(UInt8(truncatingIfNeeded: carry)) }
            return bytes
        }

        // Handle trivial cases.
        if compare(dividendBytes, divisorBytes) < 0 || isZero(dividendBytes) {
            // Quotient = 0; remainder = dividend with sign.
            let remainderBytes = applySign(to: trimZeros(dividendBytes), negative: dividendNegative && !isZero(dividendBytes))
            var remainderStorage = Storage(clamping: Array(remainderBytes.prefix(baseCount)))
            Self.trimStorage(&remainderStorage)
            return (Self.zero, Self(storage: remainderStorage))
        }

        // Long division on magnitudes.
        var remainder = trimZeros(dividendBytes)
        let divisorTrimmed = trimZeros(divisorBytes)
        let maxShift = Swift.max(0, bitLength(remainder) - bitLength(divisorTrimmed))

        var quotientBytes: [UInt8] = []
        for shift in stride(from: maxShift, through: 0, by: -1) {
            let shifted = shiftLeft(divisorTrimmed, by: shift)
            if compare(remainder, shifted) >= 0 {
                remainder = subtract(remainder, shifted)
                setBit(&quotientBytes, at: shift)
            }
        }

        let signedQuotientBytes = applySign(to: trimZeros(quotientBytes), negative: dividendNegative != divisorNegative)
        let signedRemainderBytes = applySign(to: trimZeros(remainder), negative: dividendNegative && !isZero(remainder))

        func buildStorage(from bytes: [UInt8]) -> (Storage, Bool) {
            let bytesToStore = Swift.min(bytes.count, baseCount)
            let slice = bytesToStore == bytes.count ? bytes : Array(bytes.prefix(bytesToStore))
            var storage = Storage(clamping: slice)
            var overflow = bytes.count > baseCount

            if bytes.count > baseCount {
                let signByte = bytes[Swift.min(bytesToStore, bytes.count) - 1]
                let expectedExtension: UInt8 = (Self.isSigned && (signByte & 0x80) != 0) ? 0xFF : 0x00
                for byte in bytes[baseCount...] where byte != expectedExtension {
                    overflow = true
                    break
                }
            }

            Self.trimStorage(&storage)
            return (storage, overflow)
        }

        let (quotientStorage, quotientOverflow) = buildStorage(from: signedQuotientBytes)
        let (remainderStorage, remainderOverflow) = buildStorage(from: signedRemainderBytes)
        _ = quotientOverflow || remainderOverflow

        return (Self(storage: quotientStorage), Self(storage: remainderStorage))
    }
}

extension AnyInt where Storage: LimitedBytesStorage {

    public static var max: Self {
        var storage = Storage.allOnes
        if isSigned {
            storage[Storage.byteCount - 1] &= 0x7F
        }
        return Self(storage: storage)
    }

    public static var min: Self {
        if isSigned {
            var storage = Storage.allZeros
            storage[Storage.byteCount - 1] = 0x80
            return Self(storage: storage)
        } else {
            return .zero
        }
    }

    public init<T>(_truncatingBits source: T) where T: BinaryInteger {
        self.init(source)
    }
}

extension AnyInt: FixedWidthInteger where Storage: FixedBytesStorage {

    public static var bitWidth: Int {
        Storage.byteCount * 8
    }

    @inlinable
    public static func &>>=(a: inout Self, b: Self) {
        let mask = Self(truncatingIfNeeded: Self.bitWidth &- 1)
        let amount = b & mask
        a >>= amount
    }

    @inlinable
    public static func &<<=(a: inout Self, b: Self) {
        let mask = Self(truncatingIfNeeded: Self.bitWidth &- 1)
        let amount = b & mask
        a <<= amount
    }
}

extension AnyInt: Decodable {

    public init(from decoder: Decoder) throws {
        do {
            let literal = try IntegerLiteralType(from: decoder)
            self.init(literal)
        } catch {
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)
            guard let value = Self(str) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid integer string")
            }
            self = value
        }
    }
}

extension AnyInt: Encodable {

    public func encode(to encoder: Encoder) throws {
        if let fixedType = Storage.self as? any LimitedBytesStorage.Type, fixedType.byteCount <= 8 {
            var container = encoder.singleValueContainer()
            let intValue = IntegerLiteralType(clamping: self)
            try container.encode(intValue)
        } else {
            var container = encoder.singleValueContainer()
            try container.encode(self.description)
        }
    }
}
