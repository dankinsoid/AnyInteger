import Foundation

/// Byte-addressable backing storage for `AnyInt`.
/// Provides mutable, hashable collections of `UInt8` bytes that can clamp or truncate input.
public protocol BytesStorage: RandomAccessCollection, RangeReplaceableCollection, MutableCollection, Hashable, Sendable where Element == UInt8, Index == Int {

    /// Creates storage by clamping/truncating the supplied bytes to the storage's capacity.
    init(clamping: [UInt8])
}

extension BytesStorage {

    public var startIndex: Int { 0 }
}

/// Storage with a maximum byte length.
public protocol LimitedBytesStorage: BytesStorage {

    /// Maximum number of addressable bytes.
    static var byteCount: Int { get }
    /// Create a storage with all bytes set to ones.
    static var allOnes: Self { get }
    /// Create a storage with all bytes set to zeros.
    static var allZeros: Self { get }
}

/// Storage with an exact byte length.
public protocol FixedBytesStorage: LimitedBytesStorage {
}

/// Convenience for fixed storages that expose byte members through key paths.
public protocol DefaultFixedBytesStorage: FixedBytesStorage {

    static var keyPathes: [WritableKeyPath<Self, UInt8>] { get }
}

extension FixedBytesStorage {

    public var endIndex: Int { Self.byteCount }

    /// Initializes storage by truncating to the exact fixed `byteCount`.
    public init(clamping bytes: [UInt8]) {
        self.init()
        let bytes = bytes.prefix(Self.byteCount)
        replaceSubrange(0..<Self.byteCount, with: bytes)
    }
}

extension DefaultFixedBytesStorage {

    @inlinable
    public subscript(position: Int) -> UInt8 {
        _read {
            if position < Self.byteCount {
                yield self[keyPath: Self.keyPathes[position]]
            } else {
                fatalError("Index out of range")
            }
        }
        _modify {
            if position < Self.byteCount {
                yield &self[keyPath: Self.keyPathes[position]]
            } else {
                fatalError("Index out of range")
            }
        }
    }

    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, UInt8 == C.Element {
        for (index, newElement) in zip(subrange, newElements) {
            if index < Self.byteCount {
                self[keyPath: Self.keyPathes[index]] = newElement
            } else {
                fatalError("Index out of range")
            }
        }
    }
}

extension Decodable where Self: BytesStorage {

    /// Decodes storage from an unkeyed array of bytes.
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var bytes: [UInt8] = []
        while !container.isAtEnd {
            let byte = try container.decode(UInt8.self)
            bytes.append(byte)
        }
        self.init(clamping: bytes)
    }
}

extension Encodable where Self: BytesStorage {

    /// Encodes storage as an unkeyed array of bytes.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for byte in self {
            try container.encode(byte)
        }
    }
}

/// 1-byte fixed storage.
public struct Byte1: DefaultFixedBytesStorage, Hashable, Sendable, Codable {

    public static let byteCount = 1
    public static let keyPathes: [WritableKeyPath<Byte1, UInt8>] = [\.byte]
    public static let allOnes = Byte1(0xFF)
    public static let allZeros = Self()

    public var byte: UInt8

    public init(_ byte: UInt8) {
        self.byte = byte
    }

    public init() {
        self.init(0)
    }
}

/// 2-byte fixed storage.
public struct Byte2: DefaultFixedBytesStorage, Hashable, Sendable, Codable {

    public static let byteCount = 2
    public static let keyPathes: [WritableKeyPath<Byte2, UInt8>] = [\.byte0, \.byte1]
    public static let allOnes = Byte2(0xFF, 0xFF)
    public static let allZeros = Self()

    public var byte0: UInt8
    public var byte1: UInt8

    public init(_ byte0: UInt8, _ byte1: UInt8) {
        self.byte0 = byte0
        self.byte1 = byte1
    }

    public init() {
        self.init(0, 0)
    }
}

/// 4-byte fixed storage.
public struct Byte4: DefaultFixedBytesStorage, Hashable, Sendable, Codable {

    public static let byteCount = 4
    public static let keyPathes: [WritableKeyPath<Byte4, UInt8>] = [\.byte0, \.byte1, \.byte2, \.byte3]
    public static let allOnes = Byte4(0xFF, 0xFF, 0xFF, 0xFF)
    public static let allZeros = Self()

    public var byte0: UInt8
    public var byte1: UInt8
    public var byte2: UInt8
    public var byte3: UInt8

    public init(_ byte0: UInt8, _ byte1: UInt8, _ byte2: UInt8, _ byte3: UInt8) {
        self.byte0 = byte0
        self.byte1 = byte1
        self.byte2 = byte2
        self.byte3 = byte3
    }

    public init() {
        self.init(0, 0, 0, 0)
    }
}

/// 8-byte fixed storage.
public struct Byte8: DefaultFixedBytesStorage, Hashable, Sendable, Codable {

    public static let byteCount = 8
    public static let keyPathes: [WritableKeyPath<Byte8, UInt8>] = [
        \.byte0, \.byte1, \.byte2, \.byte3,
        \.byte4, \.byte5, \.byte6, \.byte7
    ]
    public static let allZeros = Self()
    public static let allOnes = Byte8(
        0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF
    )

    public var byte0: UInt8
    public var byte1: UInt8
    public var byte2: UInt8
    public var byte3: UInt8
    public var byte4: UInt8
    public var byte5: UInt8
    public var byte6: UInt8
    public var byte7: UInt8

    public init(
        _ byte0: UInt8, _ byte1: UInt8, _ byte2: UInt8, _ byte3: UInt8,
        _ byte4: UInt8, _ byte5: UInt8, _ byte6: UInt8, _ byte7: UInt8
    ) {
        self.byte0 = byte0
        self.byte1 = byte1
        self.byte2 = byte2
        self.byte3 = byte3
        self.byte4 = byte4
        self.byte5 = byte5
        self.byte6 = byte6
        self.byte7 = byte7
    }

    public init() {
        self.init(0, 0, 0, 0, 0, 0, 0, 0)
    }
}

/// 16-byte fixed storage.
public struct Byte16: DefaultFixedBytesStorage, Hashable, Sendable, Codable {

    public static let byteCount = 16
    public static let keyPathes: [WritableKeyPath<Byte16, UInt8>] = [
        \.byte0, \.byte1, \.byte2, \.byte3,
        \.byte4, \.byte5, \.byte6, \.byte7,
        \.byte8, \.byte9, \.byte10, \.byte11,
        \.byte12, \.byte13, \.byte14, \.byte15
    ]
    public static let allZeros = Self()
    public static let allOnes = Byte16(
        0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF
    )

    public var byte0: UInt8
    public var byte1: UInt8
    public var byte2: UInt8
    public var byte3: UInt8
    public var byte4: UInt8
    public var byte5: UInt8
    public var byte6: UInt8
    public var byte7: UInt8
    public var byte8: UInt8
    public var byte9: UInt8
    public var byte10: UInt8
    public var byte11: UInt8
    public var byte12: UInt8
    public var byte13: UInt8
    public var byte14: UInt8
    public var byte15: UInt8

    public init(
        _ byte0: UInt8, _ byte1: UInt8, _ byte2: UInt8, _ byte3: UInt8,
        _ byte4: UInt8, _ byte5: UInt8, _ byte6: UInt8, _ byte7: UInt8,
        _ byte8: UInt8, _ byte9: UInt8, _ byte10: UInt8, _ byte11: UInt8,
        _ byte12: UInt8, _ byte13: UInt8, _ byte14: UInt8, _ byte15: UInt8
    ) {
        self.byte0 = byte0
        self.byte1 = byte1
        self.byte2 = byte2
        self.byte3 = byte3
        self.byte4 = byte4
        self.byte5 = byte5
        self.byte6 = byte6
        self.byte7 = byte7
        self.byte8 = byte8
        self.byte9 = byte9
        self.byte10 = byte10
        self.byte11 = byte11
        self.byte12 = byte12
        self.byte13 = byte13
        self.byte14 = byte14
        self.byte15 = byte15
    }

    public init() {
        self.init(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    }
}

/// 32-byte fixed storage.
public struct Byte32: DefaultFixedBytesStorage, Hashable, Sendable, Codable {

    public static let byteCount = 32
    public static let keyPathes: [WritableKeyPath<Byte32, UInt8>] = [
        \.byte0, \.byte1, \.byte2, \.byte3,
        \.byte4, \.byte5, \.byte6, \.byte7,
        \.byte8, \.byte9, \.byte10, \.byte11,
        \.byte12, \.byte13, \.byte14, \.byte15,
        \.byte16, \.byte17, \.byte18, \.byte19,
        \.byte20, \.byte21, \.byte22, \.byte23,
        \.byte24, \.byte25, \.byte26, \.byte27,
        \.byte28, \.byte29, \.byte30, \.byte31
    ]
    public static let allZeros = Self()
    public static let allOnes = Byte32(
        0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF,
        0xFF, 0xFF, 0xFF, 0xFF
    )

    public var byte0: UInt8
    public var byte1: UInt8
    public var byte2: UInt8
    public var byte3: UInt8
    public var byte4: UInt8
    public var byte5: UInt8
    public var byte6: UInt8
    public var byte7: UInt8
    public var byte8: UInt8
    public var byte9: UInt8
    public var byte10: UInt8
    public var byte11: UInt8
    public var byte12: UInt8
    public var byte13: UInt8
    public var byte14: UInt8
    public var byte15: UInt8
    public var byte16: UInt8
    public var byte17: UInt8
    public var byte18: UInt8
    public var byte19: UInt8
    public var byte20: UInt8
    public var byte21: UInt8
    public var byte22: UInt8
    public var byte23: UInt8
    public var byte24: UInt8
    public var byte25: UInt8
    public var byte26: UInt8
    public var byte27: UInt8
    public var byte28: UInt8
    public var byte29: UInt8
    public var byte30: UInt8
    public var byte31: UInt8

    public init(
        _ byte0: UInt8, _ byte1: UInt8, _ byte2: UInt8, _ byte3: UInt8,
        _ byte4: UInt8, _ byte5: UInt8, _ byte6: UInt8, _ byte7: UInt8,
        _ byte8: UInt8, _ byte9: UInt8, _ byte10: UInt8, _ byte11: UInt8,
        _ byte12: UInt8, _ byte13: UInt8, _ byte14: UInt8, _ byte15: UInt8,
        _ byte16: UInt8, _ byte17: UInt8, _ byte18: UInt8, _ byte19: UInt8,
        _ byte20: UInt8, _ byte21: UInt8, _ byte22: UInt8, _ byte23: UInt8,
        _ byte24: UInt8, _ byte25: UInt8, _ byte26: UInt8, _ byte27: UInt8,
        _ byte28: UInt8, _ byte29: UInt8, _ byte30: UInt8, _ byte31: UInt8
    ) {
        self.byte0 = byte0
        self.byte1 = byte1
        self.byte2 = byte2
        self.byte3 = byte3
        self.byte4 = byte4
        self.byte5 = byte5
        self.byte6 = byte6
        self.byte7 = byte7
        self.byte8 = byte8
        self.byte9 = byte9
        self.byte10 = byte10
        self.byte11 = byte11
        self.byte12 = byte12
        self.byte13 = byte13
        self.byte14 = byte14
        self.byte15 = byte15
        self.byte16 = byte16
        self.byte17 = byte17
        self.byte18 = byte18
        self.byte19 = byte19
        self.byte20 = byte20
        self.byte21 = byte21
        self.byte22 = byte22
        self.byte23 = byte23
        self.byte24 = byte24
        self.byte25 = byte25
        self.byte26 = byte26
        self.byte27 = byte27
        self.byte28 = byte28
        self.byte29 = byte29
        self.byte30 = byte30
        self.byte31 = byte31
    }

    public init() {
        self.init(
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0
        )
    }
}

/// 64-byte fixed storage.
public struct Byte64: DefaultFixedBytesStorage, Hashable, Sendable, Codable {

    public static let byteCount = 64
    public static let keyPathes: [WritableKeyPath<Byte64, UInt8>] = [
        \.byte0, \.byte1, \.byte2, \.byte3,
        \.byte4, \.byte5, \.byte6, \.byte7,
        \.byte8, \.byte9, \.byte10, \.byte11,
        \.byte12, \.byte13, \.byte14, \.byte15,
        \.byte16, \.byte17, \.byte18, \.byte19,
        \.byte20, \.byte21, \.byte22, \.byte23,
        \.byte24, \.byte25, \.byte26, \.byte27,
        \.byte28, \.byte29, \.byte30, \.byte31,
        \.byte32, \.byte33, \.byte34, \.byte35,
        \.byte36, \.byte37, \.byte38, \.byte39,
        \.byte40, \.byte41, \.byte42, \.byte43,
        \.byte44, \.byte45, \.byte46, \.byte47,
        \.byte48, \.byte49, \.byte50, \.byte51,
        \.byte52, \.byte53, \.byte54, \.byte55,
        \.byte56, \.byte57, \.byte58, \.byte59,
        \.byte60, \.byte61, \.byte62, \.byte63
    ]
    
    public static let allZeros = Self()
    public static let allOnes = {
        var storage = Self()
        for index in 0..<Self.byteCount {
            storage[keyPath: Self.keyPathes[index]] = 0xFF
        }
        return storage
    }()

    public var byte0: UInt8 = 0
    public var byte1: UInt8 = 0
    public var byte2: UInt8 = 0
    public var byte3: UInt8 = 0
    public var byte4: UInt8 = 0
    public var byte5: UInt8 = 0
    public var byte6: UInt8 = 0
    public var byte7: UInt8 = 0
    public var byte8: UInt8 = 0
    public var byte9: UInt8 = 0
    public var byte10: UInt8 = 0
    public var byte11: UInt8 = 0
    public var byte12: UInt8 = 0
    public var byte13: UInt8 = 0
    public var byte14: UInt8 = 0
    public var byte15: UInt8 = 0
    public var byte16: UInt8 = 0
    public var byte17: UInt8 = 0
    public var byte18: UInt8 = 0
    public var byte19: UInt8 = 0
    public var byte20: UInt8 = 0
    public var byte21: UInt8 = 0
    public var byte22: UInt8 = 0
    public var byte23: UInt8 = 0
    public var byte24: UInt8 = 0
    public var byte25: UInt8 = 0
    public var byte26: UInt8 = 0
    public var byte27: UInt8 = 0
    public var byte28: UInt8 = 0
    public var byte29: UInt8 = 0
    public var byte30: UInt8 = 0    
    public var byte31: UInt8 = 0
    public var byte32: UInt8 = 0
    public var byte33: UInt8 = 0
    public var byte34: UInt8 = 0
    public var byte35: UInt8 = 0
    public var byte36: UInt8 = 0
    public var byte37: UInt8 = 0
    public var byte38: UInt8 = 0
    public var byte39: UInt8 = 0
    public var byte40: UInt8 = 0
    public var byte41: UInt8 = 0
    public var byte42: UInt8 = 0
    public var byte43: UInt8 = 0
    public var byte44: UInt8 = 0
    public var byte45: UInt8 = 0
    public var byte46: UInt8 = 0
    public var byte47: UInt8 = 0
    public var byte48: UInt8 = 0
    public var byte49: UInt8 = 0
    public var byte50: UInt8 = 0
    public var byte51: UInt8 = 0
    public var byte52: UInt8 = 0
    public var byte53: UInt8 = 0
    public var byte54: UInt8 = 0
    public var byte55: UInt8 = 0
    public var byte56: UInt8 = 0
    public var byte57: UInt8 = 0
    public var byte58: UInt8 = 0
    public var byte59: UInt8 = 0
    public var byte60: UInt8 = 0
    public var byte61: UInt8 = 0
    public var byte62: UInt8 = 0
    public var byte63: UInt8 = 0

    public init() {}
}

/// 128-byte fixed storage.
public struct Byte128: DefaultFixedBytesStorage, Hashable, Sendable, Codable {

    public static let byteCount = 128
    public static let keyPathes: [WritableKeyPath<Byte128, UInt8>] = [
        \.byte0, \.byte1, \.byte2, \.byte3,
        \.byte4, \.byte5, \.byte6, \.byte7,
        \.byte8, \.byte9, \.byte10, \.byte11,
        \.byte12, \.byte13, \.byte14, \.byte15,
        \.byte16, \.byte17, \.byte18, \.byte19,
        \.byte20, \.byte21, \.byte22, \.byte23,
        \.byte24, \.byte25, \.byte26, \.byte27,
        \.byte28, \.byte29, \.byte30, \.byte31,
        \.byte32, \.byte33, \.byte34, \.byte35,
        \.byte36, \.byte37, \.byte38, \.byte39,
        \.byte40, \.byte41, \.byte42, \.byte43,
        \.byte44, \.byte45, \.byte46, \.byte47,
        \.byte48, \.byte49, \.byte50, \.byte51,
        \.byte52, \.byte53, \.byte54, \.byte55,
        \.byte56, \.byte57, \.byte58, \.byte59,
        \.byte60, \.byte61, \.byte62, \.byte63,
        \.byte64, \.byte65, \.byte66, \.byte67,
        \.byte68, \.byte69, \.byte70, \.byte71,
        \.byte72, \.byte73, \.byte74, \.byte75,
        \.byte76, \.byte77, \.byte78, \.byte79,
        \.byte80, \.byte81, \.byte82, \.byte83,
        \.byte84, \.byte85, \.byte86, \.byte87,
        \.byte88, \.byte89, \.byte90, \.byte91,
        \.byte92, \.byte93, \.byte94, \.byte95,
        \.byte96, \.byte97, \.byte98, \.byte99,
        \.byte100, \.byte101, \.byte102, \.byte103,
        \.byte104, \.byte105, \.byte106, \.byte107,
        \.byte108, \.byte109, \.byte110, \.byte111,
        \.byte112, \.byte113, \.byte114, \.byte115,
        \.byte116, \.byte117, \.byte118, \.byte119,
        \.byte120, \.byte121, \.byte122, \.byte123,
        \.byte124, \.byte125, \.byte126, \.byte127
    ]
    
    public static let allZeros = Self()
    public static let allOnes = {
        var storage = Self()
        for index in 0..<Self.byteCount {
            storage[keyPath: Self.keyPathes[index]] = 0xFF
        }
        return storage
    }()

    public var byte0: UInt8 = 0
    public var byte1: UInt8 = 0
    public var byte2: UInt8 = 0
    public var byte3: UInt8 = 0
    public var byte4: UInt8 = 0
    public var byte5: UInt8 = 0
    public var byte6: UInt8 = 0
    public var byte7: UInt8 = 0
    public var byte8: UInt8 = 0
    public var byte9: UInt8 = 0
    public var byte10: UInt8 = 0
    public var byte11: UInt8 = 0
    public var byte12: UInt8 = 0
    public var byte13: UInt8 = 0
    public var byte14: UInt8 = 0
    public var byte15: UInt8 = 0
    public var byte16: UInt8 = 0
    public var byte17: UInt8 = 0
    public var byte18: UInt8 = 0
    public var byte19: UInt8 = 0
    public var byte20: UInt8 = 0
    public var byte21: UInt8 = 0
    public var byte22: UInt8 = 0
    public var byte23: UInt8 = 0
    public var byte24: UInt8 = 0
    public var byte25: UInt8 = 0
    public var byte26: UInt8 = 0
    public var byte27: UInt8 = 0
    public var byte28: UInt8 = 0
    public var byte29: UInt8 = 0
    public var byte30: UInt8 = 0    
    public var byte31: UInt8 = 0
    public var byte32: UInt8 = 0
    public var byte33: UInt8 = 0
    public var byte34: UInt8 = 0
    public var byte35: UInt8 = 0
    public var byte36: UInt8 = 0
    public var byte37: UInt8 = 0
    public var byte38: UInt8 = 0
    public var byte39: UInt8 = 0
    public var byte40: UInt8 = 0
    public var byte41: UInt8 = 0
    public var byte42: UInt8 = 0
    public var byte43: UInt8 = 0
    public var byte44: UInt8 = 0
    public var byte45: UInt8 = 0
    public var byte46: UInt8 = 0
    public var byte47: UInt8 = 0
    public var byte48: UInt8 = 0
    public var byte49: UInt8 = 0
    public var byte50: UInt8 = 0
    public var byte51: UInt8 = 0
    public var byte52: UInt8 = 0
    public var byte53: UInt8 = 0
    public var byte54: UInt8 = 0
    public var byte55: UInt8 = 0
    public var byte56: UInt8 = 0
    public var byte57: UInt8 = 0
    public var byte58: UInt8 = 0
    public var byte59: UInt8 = 0
    public var byte60: UInt8 = 0
    public var byte61: UInt8 = 0
    public var byte62: UInt8 = 0
    public var byte63: UInt8 = 0
    public var byte64: UInt8 = 0
    public var byte65: UInt8 = 0
    public var byte66: UInt8 = 0
    public var byte67: UInt8 = 0
    public var byte68: UInt8 = 0
    public var byte69: UInt8 = 0
    public var byte70: UInt8 = 0
    public var byte71: UInt8 = 0
    public var byte72: UInt8 = 0
    public var byte73: UInt8 = 0
    public var byte74: UInt8 = 0
    public var byte75: UInt8 = 0
    public var byte76: UInt8 = 0
    public var byte77: UInt8 = 0
    public var byte78: UInt8 = 0
    public var byte79: UInt8 = 0
    public var byte80: UInt8 = 0
    public var byte81: UInt8 = 0
    public var byte82: UInt8 = 0
    public var byte83: UInt8 = 0
    public var byte84: UInt8 = 0
    public var byte85: UInt8 = 0
    public var byte86: UInt8 = 0
    public var byte87: UInt8 = 0
    public var byte88: UInt8 = 0
    public var byte89: UInt8 = 0
    public var byte90: UInt8 = 0
    public var byte91: UInt8 = 0
    public var byte92: UInt8 = 0
    public var byte93: UInt8 = 0
    public var byte94: UInt8 = 0
    public var byte95: UInt8 = 0
    public var byte96: UInt8 = 0
    public var byte97: UInt8 = 0
    public var byte98: UInt8 = 0
    public var byte99: UInt8 = 0
    public var byte100: UInt8 = 0
    public var byte101: UInt8 = 0
    public var byte102: UInt8 = 0
    public var byte103: UInt8 = 0
    public var byte104: UInt8 = 0
    public var byte105: UInt8 = 0
    public var byte106: UInt8 = 0
    public var byte107: UInt8 = 0
    public var byte108: UInt8 = 0
    public var byte109: UInt8 = 0
    public var byte110: UInt8 = 0
    public var byte111: UInt8 = 0
    public var byte112: UInt8 = 0
    public var byte113: UInt8 = 0
    public var byte114: UInt8 = 0
    public var byte115: UInt8 = 0
    public var byte116: UInt8 = 0
    public var byte117: UInt8 = 0
    public var byte118: UInt8 = 0
    public var byte119: UInt8 = 0
    public var byte120: UInt8 = 0
    public var byte121: UInt8 = 0
    public var byte122: UInt8 = 0
    public var byte123: UInt8 = 0
    public var byte124: UInt8 = 0
    public var byte125: UInt8 = 0
    public var byte126: UInt8 = 0
    public var byte127: UInt8 = 0

    public init() {}
}

public typealias Byte256 = TwoStorages<Byte128, Byte128>
public typealias Byte512 = TwoStorages<Byte256, Byte256>
public typealias Byte1024 = TwoStorages<Byte512, Byte512>
public typealias Byte2048 = TwoStorages<Byte1024, Byte1024>

public struct TwoStorages<L: FixedBytesStorage, R: FixedBytesStorage>: FixedBytesStorage {

    public var left: L
    public var right: R

    public static var byteCount: Int {
        L.byteCount + R.byteCount
    }
    
    public static var allZeros: TwoStorages<L, R> {
        TwoStorages(L.allZeros, R.allZeros)
    }
    public static var allOnes: TwoStorages<L, R> {
        TwoStorages(L.allOnes, R.allOnes)
    }

    public init(_ left: L, _ right: R) {
        self.left = left
        self.right = right
    }

    public init() {
        self.left = L()
        self.right = R()
    }

    public init(clamping bytes: [UInt8]) {
        let leftBytes = bytes.prefix(L.byteCount)
        let rightBytes = bytes.dropFirst(L.byteCount).prefix(R.byteCount)
        self.left = L(clamping: Array(leftBytes))
        self.right = R(clamping: Array(rightBytes))
    }

    public var startIndex: Int { 0 }
    public var endIndex: Int { L.byteCount + R.byteCount }

    public subscript(position: Int) -> UInt8 {
        _read {
            if position < L.byteCount {
                yield left[position]
            } else {
                yield right[position - L.byteCount]
            }
        }
        _modify {
            if position < L.byteCount {
                yield &left[position]
            } else {
                yield &right[position - L.byteCount]
            }
        }
    }

    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, UInt8 == C.Element {
        let leftByteCount = L.byteCount
        if subrange.lowerBound < leftByteCount {
            let leftSubrange = subrange.clamped(to: 0..<leftByteCount)
            let leftNewElements = newElements.prefix(leftSubrange.count)
            left.replaceSubrange(leftSubrange, with: leftNewElements)
        }
        if subrange.upperBound > leftByteCount {
            let rightSubrange = subrange.clamped(to: leftByteCount..<endIndex).lowerBound - leftByteCount..<subrange.upperBound - leftByteCount
            let rightNewElements = newElements.dropFirst(Swift.max(0, leftByteCount - subrange.lowerBound))
            right.replaceSubrange(rightSubrange, with: rightNewElements)
        }
    }
}

extension Array<UInt8>: BytesStorage {

    public init(clamping bytes: [UInt8]) {
        self = bytes
    }
}

public protocol StorageSize {
    static var byteCount: Int { get }
}

public enum StorageSize16: StorageSize { public static let byteCount = 16 }
public enum StorageSize32: StorageSize { public static let byteCount = 32 }
public enum StorageSize64: StorageSize { public static let byteCount = 64 }
public enum StorageSize128: StorageSize { public static let byteCount = 128 }
public enum StorageSize256: StorageSize { public static let byteCount = 256 }
public enum StorageSize512: StorageSize { public static let byteCount = 512 }
public enum StorageSize1024: StorageSize { public static let byteCount = 1024 }
public enum StorageSize2048: StorageSize { public static let byteCount = 2048 }

public typealias LimitedDynamicStorage16 = LimitedDynamicStorage<StorageSize16>
public typealias LimitedDynamicStorage32 = LimitedDynamicStorage<StorageSize32>
public typealias LimitedDynamicStorage64 = LimitedDynamicStorage<StorageSize64>
public typealias LimitedDynamicStorage128 = LimitedDynamicStorage<StorageSize128>
public typealias LimitedDynamicStorage256 = LimitedDynamicStorage<StorageSize256>
public typealias LimitedDynamicStorage512 = LimitedDynamicStorage<StorageSize512>
public typealias LimitedDynamicStorage1024 = LimitedDynamicStorage<StorageSize1024>
public typealias LimitedDynamicStorage2048 = LimitedDynamicStorage<StorageSize2048>

/// Growable storage with an upper bound defined by `MaxSize`.
public struct LimitedDynamicStorage<MaxSize: StorageSize>: LimitedBytesStorage {

    private(set) public var bytes: [UInt8]
    public static var byteCount: Int { MaxSize.byteCount }

    public static var allOnes: LimitedDynamicStorage<MaxSize> {
        LimitedDynamicStorage<MaxSize>(clamping: Array(repeating: 0xFF, count: MaxSize.byteCount))
    }
    
    public static var allZeros: LimitedDynamicStorage<MaxSize> {
        LimitedDynamicStorage<MaxSize>(clamping: Array(repeating: 0x00, count: MaxSize.byteCount))
    }

    public init() {
        self.bytes = []
    }

    public init(clamping bytes: [UInt8]) {
        self.bytes = Array(bytes.prefix(MaxSize.byteCount))
    }

    public var startIndex: Int { bytes.startIndex }
    public var endIndex: Int { bytes.endIndex }

    public subscript(position: Int) -> UInt8 {
        _read {
            yield bytes[position]
        }
        _modify {
            yield &bytes[position]
        }
    }

    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, UInt8 == C.Element {
        let availableCount = MaxSize.byteCount - (bytes.count - subrange.count)
        let elementsToInsert = newElements.prefix(availableCount)
        bytes.replaceSubrange(subrange, with: elementsToInsert)
    }
}
