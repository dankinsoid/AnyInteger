import Testing
import Foundation
@testable import AnyInteger

// MARK: - System Tests

enum AnyIntTests {

    typealias IntToTest = UInt128_bc
    typealias SignedIntToTest = Int128_bc

    @Suite("System Tests")
    struct SystemTests {

        @Test func canReceiveAnInt() {
            let expectedResult = IntToTest(1)
            let testResult = IntToTest(Int(1))
            #expect(testResult == expectedResult)
        }
        
        @Test func canBeSentToAnInt() {
            let expectedResult: Int = 1
            let uint = IntToTest(1)
            let testResult = Int(uint)
            #expect(testResult == expectedResult)
        }
        
        @Test func integerLiteralInput() {
            let expectedResult = IntToTest(1)
            let testResult: IntToTest = 1
            #expect(testResult == expectedResult)
        }
        
        @Test func canReceiveAString() {
            let expectedResult = IntToTest(1)
            let testResult = IntToTest(String("1"))
            #expect(testResult == expectedResult)
        }
        
        @Test func stringLiteralInput() {
            let expectedResult = IntToTest(1)
            let testResult = IntToTest("1")
            #expect(testResult == expectedResult)
        }
        
        @Test func canBeSentToAFloat() {
            let expectedResult: Float = 1
            let testResult = Float(IntToTest(1))
            #expect(testResult == expectedResult)
        }
    }
    
    // MARK: - Base Type Tests
    
    @Suite("Base Type Tests")
    struct BaseTypeTests {
        @Test func defaultInitializerSetsToZero() {
            let result = IntToTest()
            #expect(result == 0)
        }
        
        @Test func initWithUInt128() {
            var tests = [IntToTest()]
            tests.append(IntToTest(1))
            tests.append(IntToTest(UInt64.max))
            tests.append(IntToTest.max)
            
            for test in tests {
                #expect(IntToTest(test) == test)
            }
        }
        
        @Test func stringInitializerWithEmptyString() {
            #expect(IntToTest("" as String) == nil)
        }
        
        @Test func stringInitializerWithInvalidFormats() {
            var tests = ["0b2"]
            tests.append("0o8")
            tests.append("0xG")
            
            for test in tests {
                #expect(IntToTest(test) == nil)
            }
        }
    }
    
    // MARK: - FixedWidthInteger Tests
    
    @Suite("FixedWidthInteger Tests")
    struct FixedWidthIntegerTests {
        @Test func nonzeroBitCount() {
            var tests = [(input: IntToTest.min, result: 0)]
            tests.append((input: IntToTest(1), result: 1))
            tests.append((input: IntToTest(3), result: 2))
            tests.append((input: IntToTest(UInt64.max), result: 64))
            tests.append((input: IntToTest("18446744073709551616")!, result: 1)) // 2^64
            tests.append((input: IntToTest("55340232221128654848")!, result: 2)) // 3 * 2^64
            tests.append((input: IntToTest.max, result: 128))
            
            for test in tests {
                #expect(test.input.nonzeroBitCount == test.result)
            }
        }
        
        @Test func leadingZeroBitCount() {
            var tests = [(input: IntToTest.min, result: 128)]
            tests.append((input: IntToTest(1), result: 127))
            tests.append((input: IntToTest(UInt64.max), result: 64))
            tests.append((input: IntToTest("18446744073709551616")!, result: 63)) // 2^64
            tests.append((input: IntToTest.max, result: 0))
            
            for test in tests {
                #expect(test.input.leadingZeroBitCount == test.result)
            }
        }
        
        func endianTests() -> [(input: IntToTest, byteSwapped: IntToTest)] {
            var tests = [(input: IntToTest(), byteSwapped: IntToTest())]
            tests.append((input: IntToTest(1),
                          byteSwapped: IntToTest("1329227995784915872903807060280344576")!))
            tests.append((input: IntToTest("321610663957864131473347600161621603570")!,
                          byteSwapped: IntToTest("322945104609358769584862092275138032625")!))
            return tests
        }
        
        @Test func bigEndianProperty() {
            for test in endianTests() {
#if arch(i386) || arch(x86_64) || arch(arm) || arch(arm64)
                let expectedResult = test.byteSwapped
#else
                let expectedResult = test.input
#endif
                #expect(test.input.bigEndian == expectedResult)
            }
        }
        
        @Test func bigEndianInitializer() {
            for test in endianTests() {
#if arch(i386) || arch(x86_64) || arch(arm) || arch(arm64)
                let expectedResult = test.byteSwapped
#else
                let expectedResult = test.input
#endif
                #expect(IntToTest(bigEndian: test.input) == expectedResult)
            }
        }
        
        @Test func littleEndianProperty() {
            for test in endianTests() {
#if arch(i386) || arch(x86_64) || arch(arm) || arch(arm64)
                let expectedResult = test.input
#else
                let expectedResult = test.byteSwapped
#endif
                #expect(test.input.littleEndian == expectedResult)
            }
        }
        
        @Test func littleEndianInitializer() {
            for test in endianTests() {
#if arch(i386) || arch(x86_64) || arch(arm) || arch(arm64)
                let expectedResult = test.input
#else
                let expectedResult = test.byteSwapped
#endif
                #expect(IntToTest(littleEndian: test.input) == expectedResult)
            }
        }
        
        @Test func byteSwappedProperty() {
            for test in endianTests() {
                #expect(test.input.byteSwapped == test.byteSwapped)
            }
        }
        
        @Test func initWithTruncatingBits() {
            let testResult = IntToTest(_truncatingBits: UInt.max)
            #expect(testResult == IntToTest(UInt.max))
        }
        
        @Test func addingReportingOverflow() {
            // 0 + 0 = 0
            var tests = [(augend: IntToTest.min, addend: IntToTest.min,
                          sum: (partialValue: IntToTest.min, overflow: false))]
            // IntToTest.max + 0 = IntToTest.max
            tests.append((augend: IntToTest.max, addend: IntToTest.min,
                          sum: (partialValue: IntToTest.max, overflow: false)))
            // IntToTest.max + 1 = 0, with overflow
            tests.append((augend: IntToTest.max, addend: IntToTest(1),
                          sum: (partialValue: IntToTest.min, overflow: true)))
            // IntToTest.max + 2 = 1, with overflow
            tests.append((augend: IntToTest.max, addend: IntToTest(2),
                          sum: (partialValue: IntToTest(1), overflow: true)))
            // UInt64.max + 1 = 2^64
            tests.append((augend: IntToTest(UInt64.max), addend: IntToTest(1),
                          sum: (partialValue: IntToTest("18446744073709551616")!, overflow: false)))
            
            for test in tests {
                let sum = test.augend.addingReportingOverflow(test.addend)
                #expect(sum.partialValue == test.sum.partialValue)
                #expect(sum.overflow == test.sum.overflow)
            }
        }
        
        @Test func subtractingReportingOverflow() {
            // 0 - 0 = 0
            var tests = [(minuend: IntToTest.min, subtrahend: IntToTest.min,
                          difference: (partialValue: IntToTest.min, overflow: false))]
            // Uint128.max - 0 = IntToTest.max
            tests.append((minuend: IntToTest.max, subtrahend: IntToTest.min,
                          difference: (partialValue: IntToTest.max, overflow: false)))
            // IntToTest.max - 1 = IntToTest.max - 1
            tests.append((minuend: IntToTest.max, subtrahend: IntToTest(1),
                          difference: (partialValue: IntToTest("340282366920938463463374607431768211454")!, overflow: false)))
            // 2^64 - 1 = UInt64.max
            tests.append((minuend: IntToTest("18446744073709551616")!, subtrahend: IntToTest(1),
                          difference: (partialValue: IntToTest(UInt64.max), overflow: false)))
            // 0 - 1 = IntToTest.max, with overflow
            tests.append((minuend: IntToTest.min, subtrahend: IntToTest(1),
                          difference: (partialValue: IntToTest.max, overflow: true)))
            // 0 - 2 = IntToTest.max - 1, with overflow
            tests.append((minuend: IntToTest.min, subtrahend: IntToTest(2),
                          difference: (partialValue: IntToTest("340282366920938463463374607431768211454")!, overflow: true)))
            
            for test in tests {
                let difference = test.minuend.subtractingReportingOverflow(test.subtrahend)
                #expect(difference.partialValue == test.difference.partialValue)
                #expect(difference.overflow == test.difference.overflow)
            }
        }
        
        @Test func multipliedReportingOverflow() {
            // 0 * 0 = 0
            var tests = [(multiplier: IntToTest.min, multiplicator: IntToTest.min,
                          product: (partialValue: IntToTest.min, overflow: false))]
            // UInt64.max * UInt64.max = large value
            tests.append((multiplier: IntToTest(UInt64.max), multiplicator: IntToTest(UInt64.max),
                          product: (partialValue: IntToTest("340282366920938463426481119284349108225")!, overflow: false)))
            // IntToTest.max * 0 = 0
            tests.append((multiplier: IntToTest.max, multiplicator: IntToTest.min,
                          product: (partialValue: IntToTest.min, overflow: false)))
            // IntToTest.max * 1 = IntToTest.max
            tests.append((multiplier: IntToTest.max, multiplicator: IntToTest(1),
                          product: (partialValue: IntToTest.max, overflow: false)))
            // IntToTest.max * 2 = overflow
            tests.append((multiplier: IntToTest.max, multiplicator: IntToTest(2),
                          product: (partialValue: IntToTest("340282366920938463463374607431768211454")!, overflow: true)))
            // IntToTest.max * IntToTest.max = 1, with overflow
            tests.append((multiplier: IntToTest.max, multiplicator: IntToTest.max,
                          product: (partialValue: IntToTest(1), overflow: true)))
            
            for test in tests {
                let product = test.multiplier.multipliedReportingOverflow(by: test.multiplicator)
                #expect(product.partialValue == test.product.partialValue)
                #expect(product.overflow == test.product.overflow)
            }
        }
        
        @Test func multipliedFullWidth() {
            var tests: [(multiplier: IntToTest, multiplicator: IntToTest, product: (high: IntToTest, low: IntToTest))] =
            [(multiplier: IntToTest.min, multiplicator: IntToTest.min,
              product: (high: IntToTest.min, low: IntToTest.min))]
            tests.append((multiplier: IntToTest(1), multiplicator: IntToTest(1),
                          product: (high: IntToTest.min, low: IntToTest(1))))
            tests.append((multiplier: IntToTest(UInt64.max), multiplicator: IntToTest(UInt64.max),
                          product: (high: IntToTest.min, low: IntToTest("340282366920938463426481119284349108225")!)))
            tests.append((multiplier: IntToTest.max, multiplicator: IntToTest.max,
                          product: (high: IntToTest("340282366920938463463374607431768211454")!, low: IntToTest(1))))
            
            for test in tests {
                let product = test.multiplier.multipliedFullWidth(by: test.multiplicator)
                #expect(
                    product.high == test.product.high,
                    "\n\(test.multiplier) * \(test.multiplicator) == (high: \(test.product.high), low: \(test.product.low)) != (high: \(product.high), low: \(product.low))\n")
                #expect(
                    product.low == test.product.low,
                    "\n\(test.multiplier) * \(test.multiplicator) == (high: \(test.product.high), low: \(test.product.low)) != (high: \(product.high), low: \(product.low))\n")
            }
        }
        
        func divisionTests() -> [(dividend: IntToTest, divisor: IntToTest, quotient: (partialValue: IntToTest, overflow: Bool), remainder: (partialValue: IntToTest, overflow: Bool))] {
            // 0 / 0 = 0, remainder 0, with overflow
            var tests = [(dividend: IntToTest.min, divisor: IntToTest.min,
                          quotient: (partialValue: IntToTest.min, overflow: true),
                          remainder: (partialValue: IntToTest.min, overflow: true))]
            // 0 / 1 = 0, remainder 0
            tests.append((dividend: IntToTest.min, divisor: IntToTest(1),
                          quotient: (partialValue: IntToTest.min, overflow: false),
                          remainder: (partialValue: IntToTest.min, overflow: false)))
            // 0 / IntToTest.max = 0, remainder 0
            tests.append((dividend: IntToTest.min, divisor: IntToTest.max,
                          quotient: (partialValue: IntToTest.min, overflow: false),
                          remainder: (partialValue: IntToTest.min, overflow: false)))
            // 1 / 0 = 1, remainder 0, with overflow
            tests.append((dividend: IntToTest(1), divisor: IntToTest.min,
                          quotient: (partialValue: IntToTest(1), overflow: true),
                          remainder: (partialValue: IntToTest(0), overflow: true)))
            // IntToTest.max / UInt64.max
            tests.append((dividend: IntToTest.max, divisor: IntToTest(UInt64.max),
                          quotient: (partialValue: IntToTest("18446744073709551617")!, overflow: false),
                          remainder: (partialValue: IntToTest.min, overflow: false)))
            // IntToTest.max / IntToTest.max = 1, remainder 0
            tests.append((dividend: IntToTest.max, divisor: IntToTest.max,
                          quotient: (partialValue: IntToTest(1), overflow: false),
                          remainder: (partialValue: IntToTest.min, overflow: false)))
            // UInt64.max / IntToTest.max = 0, remainder UInt64.max
            tests.append((dividend: IntToTest(UInt64.max), divisor: IntToTest.max,
                          quotient: (partialValue: IntToTest.min, overflow: false),
                          remainder: (partialValue: IntToTest(UInt64.max), overflow: false)))
            return tests
        }
        
        @Test func dividedReportingOverflow() {
            for test in divisionTests() {
                let quotient = test.dividend.dividedReportingOverflow(by: test.divisor)
                #expect(
                    quotient.partialValue == test.quotient.partialValue,
                    "\(test.dividend) / \(test.divisor) == \(test.quotient.partialValue)")
                #expect(
                    quotient.overflow == test.quotient.overflow,
                    "\(test.dividend) / \(test.divisor) has overflow? \(test.remainder.overflow)")
            }
        }
        
        @Test func dividingFullWidth() throws {
            // (0, 1) / 1 = 1r0
            var tests: [(dividend: (high: IntToTest, low: IntToTest), divisor: IntToTest, result: (quotient: IntToTest, remainder: IntToTest))] =
            [(dividend: (high: IntToTest.min, low: IntToTest(1)),
              divisor: IntToTest(1),
              result: (quotient: IntToTest(1), remainder: IntToTest.min))]
            // (1, 0) / 1 = 0r0
            tests.append((dividend: (high: IntToTest(1), low: IntToTest.min),
                          divisor: IntToTest(1),
                          result: (quotient: IntToTest.min, remainder: IntToTest.min)))
            // (1, 0) / 2 = 170141183460469231731687303715884105728r0
            if let value = IntToTest("170141183460469231731687303715884105728") {
                tests.append((dividend: (high: IntToTest(1), low: IntToTest.min),
                              divisor: IntToTest(2),
                              result: (quotient: value, remainder: IntToTest.min)))
            }
            
            for test in tests {
                let result = test.divisor.dividingFullWidth(test.dividend)
                #expect(
                    result.quotient == test.result.quotient,
                    "\n\(test.dividend) / \(test.divisor) == \(test.result)")
                #expect(
                    result.remainder == test.result.remainder,
                    "\n\(test.dividend) / \(test.divisor) == \(test.result)")
            }
        }
        
        @Test func remainderReportingOverflow() {
            for test in divisionTests() {
                let remainder = test.dividend.remainderReportingOverflow(dividingBy: test.divisor)
                #expect(
                    remainder.partialValue == test.remainder.partialValue,
                    "\(test.dividend) / \(test.divisor) has a remainder of \(test.remainder.partialValue)")
                #expect(
                    remainder.overflow == test.remainder.overflow,
                    "\(test.dividend) / \(test.divisor) has overflow? \(test.remainder.overflow)")
            }
        }
        
        @Test func quotientAndRemainder() {
            for test in divisionTests() {
                guard test.divisor != 0 else { continue }
                
                let result = test.dividend.quotientAndRemainder(dividingBy: test.divisor)
                #expect(
                    result.quotient == test.quotient.partialValue,
                    "\(test.dividend) / \(test.divisor) == \(test.quotient.partialValue)")
                #expect(
                    result.remainder == test.remainder.partialValue,
                    "\(test.dividend) / \(test.divisor) has a remainder of \(test.remainder.partialValue)")
            }
        }
    }
    
    // MARK: - BinaryInteger Tests
    
    @Suite("BinaryInteger Tests")
    struct BinaryIntegerTests {
        @Test func bitWidthEquals128() {
            #expect(IntToTest.bitWidth == 128)
        }
        
        @Test func trailingZeroBitCount() {
            var tests = [(input: IntToTest.min, expected: 128)]
            tests.append((input: IntToTest(1), expected: 0))
            tests.append((input: IntToTest("18446744073709551616")!, expected: 64)) // 2^64
            tests.append((input: IntToTest.max, expected: 0))
            
            for test in tests {
                #expect(test.input.trailingZeroBitCount == test.expected)
            }
        }
        
        @Test func initFailableFloatingPointExactlyExpectedSuccesses() {
            var tests = [(input: Float(), result: IntToTest())]
            tests.append((input: Float(1), result: IntToTest(1)))
            tests.append((input: Float(1.0), result: IntToTest(1)))
            
            for test in tests {
                #expect(IntToTest(exactly: test.input) == test.result)
            }
        }
        
        @Test func initFailableFloatingPointExactlyExpectedFailures() {
            var tests = [Float(1.1)]
            tests.append(Float(0.1))
            
            for test in tests {
                #expect(IntToTest(exactly: test) == nil)
            }
        }
        
        @Test func initFloatingPoint() {
#if arch(x86_64)
            var tests = [(input: Float80(), result: IntToTest())]
            tests.append((input: Float80(0.1), result: IntToTest()))
            tests.append((input: Float80(1.0), result: IntToTest(1)))
            tests.append((input: Float80(UInt64.max), result: IntToTest(UInt64.max)))
#else
            var tests = [(input: 0.0, result: IntToTest())]
            tests.append((input: 0.1, result: IntToTest()))
            tests.append((input: 1.0, result: IntToTest(1)))
            tests.append((input: Double(UInt32.max), result: IntToTest(UInt32.max)))
#endif
            
            for test in tests {
                #expect(IntToTest(test.input) == test.result)
            }
        }
        
        @Test func word() {
            if UInt.bitWidth == 64 {
                let testValue = UInt("100000000000000000000000000000001", radix: 2)!
                let testResult = IntToTest("100000000000000000000000000000001", radix: 2)!
                
                #expect(Array(testResult.words) == [testValue, 0])
            }
        }
        
        func divisionTests() -> [(dividend: IntToTest, divisor: IntToTest, quotient: IntToTest, remainder: IntToTest)] {
            // 0 / 1 = 0, remainder 0
            var tests: [(dividend: IntToTest, divisor: IntToTest, quotient: IntToTest, remainder: IntToTest)] =
            [(dividend: IntToTest.min, divisor: IntToTest(1),
              quotient: IntToTest.min, remainder: IntToTest.min)]
            // 2 / 1 = 2, remainder 0
            tests.append((dividend: IntToTest(2), divisor: IntToTest(1),
                          quotient: IntToTest(2), remainder: IntToTest.min))
            // 1 / 2 = 0, remainder 1
            tests.append((dividend: IntToTest(1), divisor: IntToTest(2),
                          quotient: IntToTest(0), remainder: IntToTest(1)))
            // IntToTest.max / UInt64.max
            tests.append((dividend: IntToTest.max, divisor: IntToTest(UInt64.max),
                          quotient: IntToTest("18446744073709551617")!, remainder: IntToTest.min))
            // IntToTest.max / IntToTest.max = 1, remainder 0
            tests.append((dividend: IntToTest.max, divisor: IntToTest.max,
                          quotient: IntToTest(1), remainder: IntToTest.min))
            // UInt64.max / IntToTest.max = 0, remainder UInt64.max
            tests.append((dividend: IntToTest(UInt64.max), divisor: IntToTest.max,
                          quotient: IntToTest.min, remainder: IntToTest(UInt64.max)))
            return tests
        }
        
        @Test func divideOperator() {
            for test in divisionTests() {
                let quotient = test.dividend / test.divisor
                #expect(
                    quotient == test.quotient,
                    "\(test.dividend) / \(test.divisor) == \(test.quotient)")
            }
        }
        
        @Test func divideEqualOperator() {
            for test in divisionTests() {
                var quotient = test.dividend
                quotient /= test.divisor
                #expect(
                    quotient == test.quotient,
                    "\(test.dividend) /= \(test.divisor) == \(test.quotient)")
            }
        }
        
        func moduloTests() -> [(dividend: IntToTest, divisor: IntToTest, remainder: IntToTest)] {
            // 0 % 1 = 0
            var tests: [(dividend: IntToTest, divisor: IntToTest, remainder: IntToTest)] =
            [(dividend: IntToTest.min, divisor: IntToTest(1), remainder: IntToTest.min)]
            // 1 % 2 = 1
            tests.append((dividend: IntToTest(1), divisor: IntToTest(2),
                          remainder: IntToTest(1)))
            // 0 % IntToTest.max = 0
            tests.append((dividend: IntToTest.min, divisor: IntToTest.max,
                          remainder: IntToTest.min))
            // IntToTest.max % UInt64.max = 0
            tests.append((dividend: IntToTest.max, divisor: IntToTest(UInt64.max),
                          remainder: IntToTest.min))
            // IntToTest.max % IntToTest.max = 0
            tests.append((dividend: IntToTest.max, divisor: IntToTest.max,
                          remainder: IntToTest.min))
            // UInt64.max % IntToTest.max = UInt64.max
            tests.append((dividend: IntToTest(UInt64.max), divisor: IntToTest.max,
                          remainder: IntToTest(UInt64.max)))
            return tests
        }
        
        @Test func moduloOperator() {
            for test in moduloTests() {
                let remainder = test.dividend % test.divisor
                #expect(
                    remainder == test.remainder,
                    "\(test.dividend) % \(test.divisor) == \(test.remainder)")
            }
        }
        
        @Test func moduloEqualOperator() {
            for test in moduloTests() {
                var remainder = test.dividend
                remainder %= test.divisor
                #expect(
                    remainder == test.remainder,
                    "\(test.dividend) %= \(test.divisor) == \(test.remainder)")
            }
        }
        
        @Test func booleanAndEqualOperator() {
            var tests: [(lhs: IntToTest, rhs: IntToTest, result: IntToTest)] =
            [(lhs: IntToTest.min, rhs: IntToTest.min, result: IntToTest.min)]
            tests.append((lhs: IntToTest(1), rhs: IntToTest(1), result: IntToTest(1)))
            tests.append((lhs: IntToTest.min, rhs: IntToTest.max, result: IntToTest.min))
            tests.append((lhs: IntToTest(UInt64.max), rhs: IntToTest.max, result: IntToTest(UInt64.max)))
            tests.append((lhs: IntToTest.max, rhs: IntToTest.max, result: IntToTest.max))
            
            for test in tests {
                var result = test.lhs
                result &= test.rhs
                #expect(result == test.result)
            }
        }
        
        @Test func booleanOrEqualOperator() {
            var tests: [(lhs: IntToTest, rhs: IntToTest, result: IntToTest)] =
            [(lhs: IntToTest.min, rhs: IntToTest.min, result: IntToTest.min)]
            tests.append((lhs: IntToTest(1), rhs: IntToTest(1), result: IntToTest(1)))
            tests.append((lhs: IntToTest.min, rhs: IntToTest.max, result: IntToTest.max))
            tests.append((lhs: IntToTest(UInt64.max), rhs: IntToTest.max, result: IntToTest.max))
            tests.append((lhs: IntToTest.max, rhs: IntToTest.max, result: IntToTest.max))
            
            for test in tests {
                var result = test.lhs
                result |= test.rhs
                #expect(result == test.result)
            }
        }
        
        @Test func booleanXorEqualOperator() {
            var tests: [(lhs: IntToTest, rhs: IntToTest, result: IntToTest)] =
            [(lhs: IntToTest.min, rhs: IntToTest.min, result: IntToTest.min)]
            tests.append((lhs: IntToTest(1), rhs: IntToTest(1), result: IntToTest.min))
            tests.append((lhs: IntToTest.min, rhs: IntToTest.max, result: IntToTest.max))
            tests.append((lhs: IntToTest(UInt64.max), rhs: IntToTest.max, result: IntToTest("340282366920938463444927863358058659840")!))
            tests.append((lhs: IntToTest.max, rhs: IntToTest.max, result: IntToTest.min))
            
            for test in tests {
                var result = test.lhs
                result ^= test.rhs
                #expect(result == test.result)
            }
        }
        
        @Test func maskingRightShiftEqualOperatorStandardCases() {
            var tests = [(input: IntToTest("170141183460469231731687303715884105728")!, // 2^127
                          shiftWidth: 127,
                          expected: IntToTest(1))]
            tests.append((input: IntToTest("18446744073709551616")!, // 2^64
                          shiftWidth: 64,
                          expected: IntToTest(1)))
            tests.append((input: IntToTest(1),
                          shiftWidth: 1,
                          expected: IntToTest()))
            
            for test in tests {
                var testValue = test.input
                testValue &>>= test.shiftWidth
                #expect(testValue == test.expected)
            }
        }
        
        @Test func maskingRightShiftEqualOperatorEdgeCases() {
            var tests = [(input: IntToTest(2),
                          shiftWidth: 129,
                          expected: IntToTest(1))]
            tests.append((input: IntToTest.max,
                          shiftWidth: 128,
                          expected: IntToTest.max))
            tests.append((input: IntToTest(1),
                          shiftWidth: 0,
                          expected: IntToTest(1)))
            
            for test in tests {
                var testValue = test.input
                testValue &>>= test.shiftWidth
                #expect(testValue == test.expected)
            }
        }
    }
    
    // MARK: - Numeric Tests
    
    @Suite("Numeric Tests")
    struct NumericTests {
        func additionTests() -> [(augend: IntToTest, addend: IntToTest, sum: IntToTest)] {
            // 0 + 0 = 0
            var tests: [(augend: IntToTest, addend: IntToTest, sum: IntToTest)] = [(augend: IntToTest.min, addend: IntToTest.min, sum: IntToTest.min)]
            // 1 + 1 = 2
            tests.append((augend: IntToTest(1), addend: IntToTest(1), sum: IntToTest(2)))
            // IntToTest.max + 0 = IntToTest.max
            tests.append((augend: IntToTest.max, addend: IntToTest.min, sum: IntToTest.max))
            // UInt64.max + 1 = 2^64
            tests.append((augend: IntToTest(UInt64.max), addend: IntToTest(1),
                          sum: IntToTest("18446744073709551616")!))
            return tests
        }
        
        @Test func additionOperator() {
            for test in additionTests() {
                let sum = test.augend + test.addend
                #expect(
                    sum == test.sum,
                    "\(test.augend) + \(test.addend) == \(test.sum)")
            }
        }
        
        @Test func additionEqualOperator() {
            for test in additionTests() {
                var sum = test.augend
                sum += test.addend
                #expect(
                    sum == test.sum,
                    "\(test.augend) += \(test.addend) == \(test.sum)")
            }
        }
        
        func subtractionTests() -> [(minuend: IntToTest, subtrahend: IntToTest, difference: IntToTest)] {
            // 0 - 0 = 0
            var tests: [(minuend: IntToTest, subtrahend: IntToTest, difference: IntToTest)] =
            [(minuend: IntToTest.min, subtrahend: IntToTest.min, difference: IntToTest.min)]
            // Uint128.max - 0 = IntToTest.max
            tests.append((minuend: IntToTest.max, subtrahend: IntToTest.min,
                          difference: IntToTest.max))
            // IntToTest.max - 1
            tests.append((minuend: IntToTest.max, subtrahend: IntToTest(1),
                          difference: IntToTest("340282366920938463463374607431768211454")!))
            // 2^64 - 1 = UInt64.max
            tests.append((minuend: IntToTest("18446744073709551616")!, subtrahend: IntToTest(1),
                          difference: IntToTest(UInt64.max)))
            return tests
        }
        
        @Test func subtractionOperator() {
            for test in subtractionTests() {
                let difference = test.minuend - test.subtrahend
                #expect(
                    difference == test.difference,
                    "\(test.minuend) - \(test.subtrahend) == \(test.difference)")
            }
        }
        
        @Test func subtractionEqualOperator() {
            for test in subtractionTests() {
                var difference = test.minuend
                difference -= test.subtrahend
                #expect(
                    difference == test.difference,
                    "\(test.minuend) -= \(test.subtrahend) == \(test.difference)")
            }
        }
        
        func multiplicationTests() -> [(multiplier: IntToTest, multiplicator: IntToTest, product: IntToTest)] {
            // 0 * 0 = 0
            var tests: [(multiplier: IntToTest, multiplicator: IntToTest, product: IntToTest)] =
            [(multiplier: IntToTest.min, multiplicator: IntToTest.min, product: IntToTest.min)]
            // UInt64.max * UInt64.max
            tests.append((multiplier: IntToTest(UInt64.max), multiplicator: IntToTest(UInt64.max),
                          product: IntToTest("340282366920938463426481119284349108225")!))
            // IntToTest.max * 0 = 0
            tests.append((multiplier: IntToTest.max, multiplicator: IntToTest.min,
                          product: IntToTest.min))
            // IntToTest.max * 1 = IntToTest.max
            tests.append((multiplier: IntToTest.max, multiplicator: IntToTest(1),
                          product: IntToTest.max))
            return tests
        }
        
        @Test func multiplicationOperator() {
            for test in multiplicationTests() {
                let product = test.multiplier * test.multiplicator
                #expect(
                    product == test.product,
                    "\(test.multiplier) * \(test.multiplicator) == \(test.product)")
            }
        }
        
        @Test func multiplicationEqualOperator() {
            for test in multiplicationTests() {
                var product = test.multiplier
                product *= test.multiplicator
                #expect(
                    product == test.product,
                    "\(test.multiplier) *= \(test.multiplicator) == \(test.product)")
            }
        }
    }
    
    // MARK: - Equatable Tests
    
    @Suite("Equatable Tests")
    struct EquatableTests {
        @Test func booleanEqualsOperator() {
            var tests = [(lhs: IntToTest.min,
                          rhs: IntToTest.min, result: true)]
            tests.append((lhs: IntToTest.min,
                          rhs: IntToTest(1), result: false))
            tests.append((lhs: IntToTest.max,
                          rhs: IntToTest.max, result: true))
            tests.append((lhs: IntToTest(UInt64.max),
                          rhs: IntToTest.max, result: false))
            tests.append((lhs: IntToTest("18446744073709551616")!,
                          rhs: IntToTest("18446744073709551616")!, result: true))
            tests.append((lhs: IntToTest("18446744073709551616")!,
                          rhs: IntToTest(), result: false))
            
            for test in tests {
                #expect((test.lhs == test.rhs) == test.result)
            }
        }
    }
    
    // MARK: - ExpressibleByIntegerLiteral Tests
    
    @Suite("ExpressibleByIntegerLiteral Tests")
    struct ExpressibleByIntegerLiteralTests {
        @Test func initWithIntegerLiteral() {
            var tests: [(input: Int64, result: IntToTest)]
            tests = [(input: 0, result: IntToTest())]
            tests.append((input: 1, result: IntToTest(1)))
            tests.append((input: 9223372036854775807, result: IntToTest(Int.max)))
            
            for test in tests {
                #expect(IntToTest(test.input) == test.result)
            }
        }
    }
    
    // MARK: - CustomStringConvertible Tests
    
    @Suite("CustomStringConvertible Tests")
    struct CustomStringConvertibleTests {
        func stringTests() -> [(input: IntToTest, result: [Int: String])] {
            var tests = [(input: IntToTest(), result: [
                2: "0", 8: "0", 10: "0", 16: "0", 18: "0", 36: "0"])]
            tests.append((input: IntToTest(1), result: [
                2: "1", 8: "1", 10: "1", 16: "1", 18: "1", 36: "1"]))
            tests.append((input: IntToTest(UInt64.max), result: [
                2: "1111111111111111111111111111111111111111111111111111111111111111",
                8: "1777777777777777777777",
                10: "18446744073709551615",
                16: "ffffffffffffffff",
                18: "2d3fgb0b9cg4bd2f",
                36: "3w5e11264sgsf"]))
            tests.append((input: IntToTest("18446744073709551616")!, result: [
                2: "10000000000000000000000000000000000000000000000000000000000000000",
                8: "2000000000000000000000",
                10: "18446744073709551616",
                16: "10000000000000000",
                18: "2d3fgb0b9cg4bd2g",
                36: "3w5e11264sgsg"]))
            tests.append((input: IntToTest.max, result: [
                2: "11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
                8: "3777777777777777777777777777777777777777777",
                10: "340282366920938463463374607431768211455",
                16: "ffffffffffffffffffffffffffffffff",
                18: "78a399ccdeb5bd6ha3184c0fh64da63",
                36: "f5lxx1zz5pnorynqglhzmsp33"]))
            return tests
        }
        
        @Test func largeString() {
            let s = "306a0000000000000000000000000000"
            let u = IntToTest(s, radix: 16)!
            #expect(s == String(u, radix: 16))
        }
        
        @Test func descriptionProperty() {
            for test in stringTests() {
                #expect(test.input.description == test.result[10])
            }
        }
        
        @Test func stringDescribingInitializer() {
            for test in stringTests() {
                #expect(String(describing: test.input) == test.result[10])
            }
        }
        
        @Test func stringUInt128InitializerLowercased() {
            for test in stringTests() {
                for result in test.result {
                    let (radix, result) = result
                    let testOutput = String(test.input, radix: radix)
                    #expect(testOutput == result)
                }
            }
        }
        
        @Test func stringUInt128InitializerUppercased() {
            for test in stringTests() {
                for result in test.result {
                    let (radix, result) = result
                    let testOutput = String(test.input, radix: radix, uppercase: true)
                    #expect(testOutput == result.uppercased())
                }
            }
        }
    }
    
    // MARK: - CustomDebugStringConvertible Tests
    
    @Suite("CustomDebugStringConvertible Tests")
    struct CustomDebugStringConvertibleTests {
        func stringTests() -> [(input: IntToTest, result: String)] {
            var tests = [(input: IntToTest(),
                          result: "0")]
            tests.append((input: IntToTest(1),
                          result: "1"))
            tests.append((input: IntToTest(UInt64.max),
                          result: "18446744073709551615"))
            tests.append((input: IntToTest("18446744073709551616")!,
                          result: "18446744073709551616"))
            tests.append((input: IntToTest.max,
                          result: "340282366920938463463374607431768211455"))
            return tests
        }
        
        @Test func debugDescriptionProperty() {
            for test in stringTests() {
                #expect(test.input.debugDescription == test.result)
            }
        }
        
        @Test func stringReflectingInitializer() {
            for test in stringTests() {
                #expect(String(reflecting: test.input) == test.result)
            }
        }
    }
    
    // MARK: - Comparable Tests
    
    @Suite("Comparable Tests")
    struct ComparableTests {
        @Test func lessThanOperator() {
            var tests = [(lhs: IntToTest.min, rhs: IntToTest(1), result: true)]
            tests.append((lhs: IntToTest.min, rhs: IntToTest("18446744073709551616")!, result: true))
            tests.append((lhs: IntToTest(1), rhs: IntToTest("18446744073709551616")!, result: true))
            tests.append((lhs: IntToTest(UInt64.max), rhs: IntToTest.max, result: true))
            tests.append((lhs: IntToTest.min, rhs: IntToTest.min, result: false))
            tests.append((lhs: IntToTest.max, rhs: IntToTest.max, result: false))
            tests.append((lhs: IntToTest.max, rhs: IntToTest(UInt64.max), result: false))
            
            for test in tests {
                #expect((test.lhs < test.rhs) == test.result)
            }
        }
    }
    
    // MARK: - Failable String Initializer Tests
    
    @Suite("Failable String Initializer Tests")
    struct FailableStringInitializerTests {
        func stringTests() -> [(input: String, radix: Int, result: IntToTest?)] {
            var tests = [(input: "", 10, result: nil as IntToTest?)]
            tests.append((input: "0", 10, result: IntToTest()))
            tests.append((input: "1", 10, result: IntToTest(1)))
            tests.append((input: "99", 10, result: IntToTest(99)))
            tests.append((input: "0101", 2, result: IntToTest(5)))
            tests.append((input: "11", 8, result: IntToTest(9)))
            tests.append((input: "FF", 16, result: IntToTest(255)))
            tests.append((input: "0z1234", 10, result: nil))
            return tests
        }
        
        @Test func initWithStringLiteral() {
            for test in stringTests() {
                #expect(IntToTest(test.input, radix: test.radix) == test.result)
            }
        }
        
        @Test func evaluatedWithStringLiteral() {
            let binaryTest = IntToTest("11", radix: 2)
            #expect(binaryTest == IntToTest(3))
            
            let octalTest = IntToTest("11", radix: 8)
            #expect(octalTest == IntToTest(9))
            
            let decimalTest = IntToTest("11", radix: 10)
            #expect(decimalTest == IntToTest(11))
            
            let hexTest = IntToTest("11", radix: 16)
            #expect(hexTest == IntToTest(17))
        }
    }
    
    // MARK: - Codable Tests
    
    @Suite("Codable Tests")
    struct CodableTests {
        @Test func codable() throws {
            let enc = try #require(IntToTest("340282366920938463463374607431768211455"))
            let data = try JSONEncoder().encode(enc)
            let dec = try JSONDecoder().decode(IntToTest.self, from: data)
            #expect(enc == dec)
        }
    }
    
    // MARK: - FloatingPoint Interworking Tests
    
    @Suite("FloatingPoint Interworking Tests")
    struct FloatingPointInterworkingTests {
        @Test func nonFailableInitializer() throws {
            var tests = [(input: IntToTest(), output: Float(0))]
            tests.append((input: IntToTest(UInt64.max),
                          output: Float(UInt64.max)))
            
            for test in tests {
                #expect(Float(test.input) == test.output)
            }
        }
        
        @Test func failableInitializer() throws {
            var tests = [(input: IntToTest(),
                          output: Float(0) as Float?)]
            tests.append((input: IntToTest("18446744073709551616")!,
                          output: 18446744073709551616 as Float))
            
            for test in tests {
                #expect(
                    Float(exactly: test.input) == test.output,
                    "Float(exactly: \(test.input)) == \(String(describing: test.output))"
                )
            }
        }
    }
    
    // MARK: - Basic AnyInt Tests
    
    @Suite("Basic AnyInt Tests")
    struct BasicAnyIntTests {
        
        @Test func basicMath() throws {
            // Basic go/nogo test to verify the basic operations
            let x = IntToTest("123456789012345678901234567890")!
            let y = IntToTest(100_000_000)
            let z = x + y
            let v = x - y
            let a = x / y
            let b = x % y
            let c = x * y
            let d = x & y
            let e = x | y
            let f = x ^ y
            let g = ~x
            let h = IntToTest("1234567890ABCDEF1234567890ABCDEF", radix: 16)!
            
            let sh = String(h.byteSwapped, radix: 16, uppercase: true)
            
            #expect(IntToTest.max.description == "340282366920938463463374607431768211455")
            #expect(x.description == "123456789012345678901234567890")
            #expect(y.description == "100000000")
            #expect(z.description == "123456789012345678901334567890")
            #expect(v.description == "123456789012345678901134567890")
            #expect(a.description == "1234567890123456789012")
            #expect(b.description == "34567890")
            #expect(c.description == "12345678901234567890123456789000000000")
            #expect(d.description == "70582272")
            #expect(e.description == "123456789012345678901263985618")
            #expect(f.description == "123456789012345678901193403346")
            #expect(g.description == "340282366797481674451028928530533643565")
            #expect(sh == "EFCDAB9078563412EFCDAB9078563412")
        }
    }

    // MARK: - Signed AnyInt Tests

    @Suite("Signed AnyInt Tests")
    struct SignedAnyIntTests {

        @Test func basicNegativeLiteralsAndDescription() {
            let minusOne: SignedIntToTest = -1
            let minusTen = SignedIntToTest(-10)
            let bigNegative = SignedIntToTest("-12345678901234567890")

            #expect(minusOne.description == "-1")
            #expect(minusTen.description == "-10")
            #expect(bigNegative?.description == "-12345678901234567890")
        }

        @Test func negativeMagnitudeAndSign() {
            let value = SignedIntToTest(-42)
            let magnitude = value.magnitude

            #expect(SignedIntToTest.isSigned)
            #expect(magnitude == SignedIntToTest.Magnitude(42))
        }

        @Test func arithmeticWithNegatives() {
            let a = SignedIntToTest(-5)
            let b = SignedIntToTest(3)
            let c = SignedIntToTest(-7)

            #expect(a + b == SignedIntToTest(-2))
            #expect(b + a == SignedIntToTest(-2))
            #expect(a - b == SignedIntToTest(-8))
            #expect(b - a == SignedIntToTest(8))
            #expect(a * b == SignedIntToTest(-15))
            #expect(a * c == SignedIntToTest(35))
        }

        @Test func divisionAndRemainderWithNegatives() {
            let a = SignedIntToTest(-7)
            let b = SignedIntToTest(3)

            let quotient = a / b
            let remainder = a % b

            // Swift truncates toward zero for integer division.
            #expect(quotient == SignedIntToTest(-2))
            #expect(remainder == SignedIntToTest(-1))
        }

        @Test func shiftingPreservesSign() {
            var value = SignedIntToTest(-2)
            value >>= 1
            #expect(value == SignedIntToTest(-1))

            var positive = SignedIntToTest(2)
            positive <<= 2
            #expect(positive == SignedIntToTest(8))
        }
    }

    // MARK: - BigInt Dynamic Storage Tests

    @Suite("BigInt Dynamic Storage Tests")
    struct BigIntDynamicStorageTests {

        @Test func basicInitialization() {
            let zero = BigInt(0)
            let one = BigInt(1)
            let negative = BigInt(-42)
            let fromString = BigInt("123456789012345678901234567890")
            let largeString = BigInt("999999999999999999999999999999999999999999")

            #expect(zero == 0)
            #expect(one == 1)
            #expect(negative == -42)
            #expect(fromString?.description == "123456789012345678901234567890")
            #expect(largeString?.description == "999999999999999999999999999999999999999999")
        }

        @Test func addition() {
            let a = BigInt("123456789012345678901234567890")!
            let b = BigInt("987654321098765432109876543210")!
            let sum = a + b
            #expect(sum.description == "1111111110111111111011111111100")

            let withNegative = a + BigInt(-1000)
            #expect(withNegative.description == "123456789012345678901234566890")

            let zero = BigInt(0) + BigInt(0)
            #expect(zero == 0)
        }

        @Test func subtraction() {
            let a = BigInt("987654321098765432109876543210")!
            let b = BigInt("123456789012345678901234567890")!
            let diff = a - b
            #expect(diff.description == "864197532086419753208641975320")

            let negative = BigInt(10) - BigInt(20)
            #expect(negative == -10)
        }

        @Test func multiplication() {
            let a = BigInt("12345678901234567890")!
            let b = BigInt("98765432109876543210")!
            let product = a * b
            #expect(product.description == "1219326311370217952237463801111263526900")

            let byZero = a * BigInt(0)
            #expect(byZero == 0)

            let byOne = a * BigInt(1)
            #expect(byOne == a)

            let negative = BigInt(-5) * BigInt(7)
            #expect(negative == -35)
        }

        @Test func divisionAndRemainderWithNegativesBigInt() {
            let a = BigInt(-7)
            let b = BigInt(3)

            let quotient = a / b
            let remainder = a % b

            #expect(quotient == BigInt(-2))
            #expect(remainder == BigInt(-1))
        }

        @Test func divisionLargeNumbers() {
            let dividend = BigInt("123456789012345678901234567890")!
            let divisor = BigInt("12345678901234567890")!
            let quotient = dividend / divisor
            let remainder = dividend % divisor

            #expect(quotient.description == "10000000000")
            #expect(remainder.description == "1234567890")

            let a = BigInt("999999999999999999999999")!
            let b = BigInt("123456789")!
            let q = a / b
            let r = a % b
            #expect(q.description == "8100000073710000")
            #expect(r.description == "82809999")
        }

        @Test func bitwiseAnd() {
            let a = BigInt("309485009821345068724781056")!
            let b = BigInt("1208925819614629174706176")!
            let result = a & b
            #expect(result == BigInt("0")!)

            let c = BigInt(255)
            let d = BigInt(15)
            #expect((c & d) == 15)
        }

        @Test func bitwiseOr() {
            let a = BigInt("280375465082880")! // 0xFF00FF00FF00
            let b = BigInt("280371170115840")! // 0x00FF00FF00FF
            let result = a | b
            #expect(result == BigInt("281470681743616")!) // Should be the union

            let c = BigInt(240)
            let d = BigInt(15)
            #expect((c | d) == 255)
        }

        @Test func bitwiseXor() {
            let a = BigInt("281474976710655")! // 0xFFFFFFFFFFFF
            let b = BigInt("187649984473770")! // 0xAAAAAAAAAAAA
            let result = a ^ b
            #expect(result == BigInt("93824992236885")!) // 0x555555555555

            let c = BigInt(255)
            let d = BigInt(255)
            #expect((c ^ d) == 0)
        }

        @Test func bitwiseNot() {
            let a = BigInt(0)
            let result = ~a
            #expect(result == -1)

            let b = BigInt(-1)
            let result2 = ~b
            #expect(result2 == 0)
        }

        @Test func shiftingPreservesSignBigInt() {
            var value = BigInt(-2)
            value >>= 1
            #expect(value == BigInt(-1))

            var positive = BigInt(2)
            positive <<= 2
            #expect(positive == BigInt(8))
        }

        @Test func leftShiftLargeValues() {
            let base = BigInt(1)
            let shifted64 = base << 64
            #expect(shifted64.description == "18446744073709551616")

            let shifted128 = base << 128
            #expect(shifted128.description == "340282366920938463463374607431768211456")

            let shifted256 = base << 256
            #expect(shifted256.description == "115792089237316195423570985008687907853269984665640564039457584007913129639936")
        }

        @Test func rightShiftLargeValues() {
            let large = BigInt("115792089237316195423570985008687907853269984665640564039457584007913129639936")!
            var value = large
            value >>= 256
            #expect(value == 1)

            var value2 = large
            value2 >>= 128
            #expect(value2.description == "340282366920938463463374607431768211456")
        }

        @Test func comparison() {
            let a = BigInt("999999999999999999999999")!
            let b = BigInt("1000000000000000000000000")!

            #expect(a < b)
            #expect(b > a)
            #expect(a <= b)
            #expect(b >= a)
            #expect(a != b)

            let c = BigInt("999999999999999999999999")!
            #expect(a == c)
            #expect(a <= c)
            #expect(a >= c)
        }

        @Test func negativeComparison() {
            let a = BigInt(-100)
            let b = BigInt(-50)
            let c = BigInt(0)
            let d = BigInt(50)

            #expect(a < b)
            #expect(b < c)
            #expect(c < d)
            #expect(a < d)
        }

        @Test func stringConversion() {
            let value = BigInt("123456789012345678901234567890")!

            #expect(value.description == "123456789012345678901234567890")
            #expect(String(value, radix: 16) == "18ee90ff6c373e0ee4e3f0ad2")
            #expect(String(value, radix: 2).count > 0)
        }

        @Test func magnitudeAndNegation() {
            let positive = BigInt("123456789012345678901234567890")!
            let negative = -positive

            #expect(negative.description == "-123456789012345678901234567890")
            #expect(positive.magnitude == negative.magnitude)
            #expect(-negative == positive)
        }

        @Test func addingReportingOverflow() {
            let a = BigInt("999999999999999999999999999999")!
            let b = BigInt(1)
            let (sum, overflow) = a.addingReportingOverflow(b)

            #expect(sum.description == "1000000000000000000000000000000")
            #expect(overflow == false)
        }

        @Test func multipliedReportingOverflow() {
            let a = BigInt("123456789012345678901234567890")!
            let b = BigInt("987654321098765432109876543210")!
            let (product, overflow) = a.multipliedReportingOverflow(by: b)

            #expect(product.description == "121932631137021795226185032733622923332237463801111263526900")
            #expect(overflow == false)
        }

        @Test func trailingZeroBitCount() {
            let a = BigInt(8)
            #expect(a.trailingZeroBitCount == 3)

            let b = BigInt(1024)
            #expect(b.trailingZeroBitCount == 10)

            let c = BigInt(1)
            #expect(c.trailingZeroBitCount == 0)
        }

        @Test func nonzeroBitCount() {
            let a = BigInt(7)
            #expect(a.nonzeroBitCount == 3)

            let b = BigInt(255)
            #expect(b.nonzeroBitCount == 8)
        }
    }

    // MARK: - LimitedBigInt Dynamic Storage Tests

    @Suite("LimitedBigInt Dynamic Storage Tests")
    struct LimitedBigIntDynamicStorageTests {

        @Test func basicInitialization() {
            let zero = LimitedBigInt128(0)
            let one = LimitedBigInt128(1)
            let negative = LimitedBigInt128(-42)
            let max = LimitedBigInt128.max
            let min = LimitedBigInt128.min

            #expect(zero == 0)
            #expect(one == 1)
            #expect(negative == -42)
            #expect(max.description == "170141183460469231731687303715884105727")
            #expect(min.description == "-170141183460469231731687303715884105728")
        }

        @Test func addition() {
            let a = LimitedBigInt128("123456789012345678901234567890")!
            let b = LimitedBigInt128("100000000000000000000000000000")!
            let sum = a + b
            #expect(sum.description == "223456789012345678901234567890")

            let negative = LimitedBigInt128(-100) + LimitedBigInt128(-200)
            #expect(negative == -300)
        }

        @Test func subtraction() {
            let a = LimitedBigInt128("123456789012345678901234567890")!
            let b = LimitedBigInt128("23456789012345678901234567890")!
            let diff = a - b
            #expect(diff.description == "100000000000000000000000000000")
        }

        @Test func multiplication() {
            let a = LimitedBigInt128("1234567890123456789")!
            let b = LimitedBigInt128("98765432")!
            let product = a * b
            #expect(product.description == "121932631001371743098917848")

            let negative = LimitedBigInt128(-5) * LimitedBigInt128(7)
            #expect(negative == -35)
        }

        @Test func divisionAndRemainderWithNegativesLimitedBigInt() {
            let a = LimitedBigInt128(-7)
            let b = LimitedBigInt128(3)

            let quotient = a / b
            let remainder = a % b

            #expect(quotient == LimitedBigInt128(-2))
            #expect(remainder == LimitedBigInt128(-1))
        }

        @Test func divisionLargeNumbers() {
            let dividend = LimitedBigInt128("123456789012345678901234567890")!
            let divisor = LimitedBigInt128("12345678901234567890")!
            let quotient = dividend / divisor
            let remainder = dividend % divisor

            #expect(quotient.description == "10000000000")
            #expect(remainder.description == "1234567890")
        }

        @Test func bitwiseOperations() {
            let a = LimitedBigInt128("18374686479671623680")! // 0xFF00FF00FF00FF00
            let b = LimitedBigInt128("18446744073709551615")! // 0xFFFFFFFFFFFFFFFF

            let andResult = a & b
            #expect(andResult == a)

            let c = LimitedBigInt128("4278255360")! // 0xFF00FF00
            let d = LimitedBigInt128("16711935")! // 0x00FF00FF
            let orResult = c | d
            #expect(orResult == LimitedBigInt128("4294967295")!) // 0xFFFFFFFF

            let e = LimitedBigInt128(255)
            let f = LimitedBigInt128(255)
            let xorResult = e ^ f
            #expect(xorResult == 0)
        }

        @Test func bitwiseNot() {
            let a = LimitedBigInt128(0)
            let result = ~a
            #expect(result == -1)

            let b = LimitedBigInt128(-1)
            let result2 = ~b
            #expect(result2 == 0)
        }

        @Test func shiftingPreservesSignLimitedBigInt() {
            var value = LimitedBigInt128(-2)
            value >>= 1
            #expect(value == LimitedBigInt128(-1))

            var positive = LimitedBigInt128(2)
            positive <<= 2
            #expect(positive == LimitedBigInt128(8))
        }

        @Test func leftShift() {
            let base = LimitedBigInt128(1)
            let shifted64 = base << 64
            #expect(shifted64.description == "18446744073709551616")

            let shifted100 = base << 100
            #expect(shifted100.description == "1267650600228229401496703205376")
        }

        @Test func rightShift() {
            let large = LimitedBigInt128("18446744073709551616")!
            var value = large
            value >>= 64
            #expect(value == 1)

            var negative = LimitedBigInt128(-16)
            negative >>= 2
            #expect(negative == -4)
        }

        @Test func comparison() {
            let a = LimitedBigInt128("123456789012345678901234567890")!
            let b = LimitedBigInt128("123456789012345678901234567891")!

            #expect(a < b)
            #expect(b > a)
            #expect(a != b)

            let c = LimitedBigInt128("123456789012345678901234567890")!
            #expect(a == c)
        }

        @Test func negativeComparison() {
            let a = LimitedBigInt128(-1000)
            let b = LimitedBigInt128(-500)
            let c = LimitedBigInt128(0)

            #expect(a < b)
            #expect(b < c)
            #expect(a < c)
        }

        @Test func overflowBehavior() {
            let max = LimitedBigInt128.max
            let (sum, overflow) = max.addingReportingOverflow(LimitedBigInt128(1))
            #expect(overflow == true)
            #expect(sum == LimitedBigInt128.min)

            let min = LimitedBigInt128.min
            let (diff, underflow) = min.subtractingReportingOverflow(LimitedBigInt128(1))
            #expect(underflow == true)
            #expect(diff == LimitedBigInt128.max)
        }

        @Test func magnitudeAndNegation() {
            let positive = LimitedBigInt128("123456789012345678901234567890")!
            let negative = -positive

            #expect(negative.description == "-123456789012345678901234567890")
            #expect(positive.magnitude == negative.magnitude)
            #expect(-negative == positive)
        }

        @Test func trailingZeroBitCount() {
            let a = LimitedBigInt128(8)
            #expect(a.trailingZeroBitCount == 3)

            let b = LimitedBigInt128(1024)
            #expect(b.trailingZeroBitCount == 10)
        }

        @Test func nonzeroBitCount() {
            let a = LimitedBigInt128(7)
            #expect(a.nonzeroBitCount == 3)

            let b = LimitedBigInt128(255)
            #expect(b.nonzeroBitCount == 8)
        }

        @Test func byteSwapped() {
            let a = LimitedBigInt128("1311768467463790320")!
            let swapped = a.byteSwapped
            let expected = LimitedBigInt128("-1090226688147180526")!
            #expect(swapped == expected)
        }

        @Test func stringConversion() {
            let value = LimitedBigInt128("123456789012345678901234567890")!

            #expect(value.description == "123456789012345678901234567890")

            let smallValue = LimitedBigInt128("3735928559")! // 0xDEADBEEF
            #expect(smallValue.description == "3735928559")
        }
    }

    // MARK: - BigUInt Dynamic Storage Tests

    @Suite("BigUInt Dynamic Storage Tests")
    struct BigUIntDynamicStorageTests {

        @Test func basicInitialization() {
            let zero = BigUInt(0)
            let one = BigUInt(1)
            let large = BigUInt("123456789012345678901234567890")

            #expect(zero == 0)
            #expect(one == 1)
            #expect(large?.description == "123456789012345678901234567890")
        }

        @Test func arithmeticOperations() {
            let a = BigUInt("999999999999999999999999")!
            let b = BigUInt("1")!
            let sum = a + b
            #expect(sum.description == "1000000000000000000000000")

            let c = BigUInt("1000000000000000000000000")!
            let d = BigUInt("1")!
            let diff = c - d
            #expect(diff.description == "999999999999999999999999")

            let e = BigUInt("123456789")!
            let f = BigUInt("987654321")!
            let product = e * f
            #expect(product.description == "121932631112635269")
        }

        @Test func unsignedOnly() {
            // BigUInt should not support negative values
            let a = BigUInt(100)
            let b = BigUInt(200)
            // This should wrap or trap, not produce negative
            #expect(a < b)
        }

        @Test func largeValueMultiplication() {
            let a = BigUInt("18446744073709551615")! // UInt64.max
            let b = BigUInt("18446744073709551615")!
            let product = a * b
            #expect(product.description == "340282366920938463426481119284349108225")
        }
    }

    // MARK: - LimitedBigUInt Dynamic Storage Tests

    @Suite("LimitedBigUInt Dynamic Storage Tests")
    struct LimitedBigUIntDynamicStorageTests {

        @Test func basicInitialization() {
            let zero = LimitedBigUInt128(0)
            let one = LimitedBigUInt128(1)
            let max = LimitedBigUInt128.max

            #expect(zero == 0)
            #expect(one == 1)
            #expect(max.description == "340282366920938463463374607431768211455")
        }

        @Test func arithmeticOperations() {
            let a = LimitedBigUInt128("123456789012345678901234567890")!
            let b = LimitedBigUInt128("100000000000000000000000000000")!
            let sum = a + b
            #expect(sum.description == "223456789012345678901234567890")

            let c = LimitedBigUInt128("1000000000000000")!
            let d = LimitedBigUInt128("1")!
            let diff = c - d
            #expect(diff.description == "999999999999999")
        }

        @Test func overflowBehavior() {
            let max = LimitedBigUInt128.max
            let (sum, overflow) = max.addingReportingOverflow(LimitedBigUInt128(1))
            #expect(overflow == true)
            #expect(sum == 0)
        }

        @Test func bitwiseOperations() {
            let a = LimitedBigUInt128("18446744073709551615")! // 0xFFFFFFFFFFFFFFFF
            let b = LimitedBigUInt128("12297829382473034410")! // 0xAAAAAAAAAAAAAAAA

            let andResult = a & b
            #expect(andResult == b)

            let xorResult = a ^ b
            #expect(xorResult == LimitedBigUInt128("6148914691236517205")!) // 0x5555555555555555
        }
    }
}
