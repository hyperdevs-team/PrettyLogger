import Combine
import XCTest

@testable import PrettyLogger

class QuickOutputTest: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    private var originalLevel: PrettyLoggerLevel!
    private var originalSeparator: String!
    private var originalTerminator: String!

    override func setUp() {
        super.setUp()
        cancellables.removeAll()

        // Save original state
        originalLevel = PrettyLogger.shared.level
        originalSeparator = PrettyLogger.shared.separator
        originalTerminator = PrettyLogger.shared.terminator

        // Reset to default state for tests
        PrettyLogger.shared.level = .all
    }

    override func tearDown() {
        // Restore original state
        PrettyLogger.shared.level = originalLevel
        PrettyLogger.shared.separator = originalSeparator
        PrettyLogger.shared.terminator = originalTerminator
        cancellables.removeAll()
        super.tearDown()
    }

    func testOSLogOutputStreamIntegration() {
        let expectation = XCTestExpectation(description: "OSLog should send to output stream")
        expectation.expectedFulfillmentCount = 3

        var receivedOutputs: [PrettyLoggerOutput] = []

        PrettyLogger.shared.output
            .sink { output in
                receivedOutputs.append(output)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Test new OSLog API
        logInfo("Test message 1")
        logError("Test error message", category: "Testing")
        logDebug("Test debug message", category: "Debug", privacy: .private)

        wait(for: [expectation], timeout: 3.0)

        // Verify we received the outputs
        XCTAssertEqual(receivedOutputs.count, 3)

        // Check first output (basic)
        XCTAssertEqual(receivedOutputs[0].level, .info)
        XCTAssertEqual(receivedOutputs[0].message, "Test message 1")
        XCTAssertEqual(receivedOutputs[0].file, "QuickOutputTest.swift")

        // Check second output (with category)
        XCTAssertEqual(receivedOutputs[1].level, .error)
        XCTAssertEqual(receivedOutputs[1].message, "Test error message")
        XCTAssertEqual(receivedOutputs[1].file, "QuickOutputTest.swift")

        // Check third output (with category and privacy)
        XCTAssertEqual(receivedOutputs[2].level, .debug)
        XCTAssertEqual(receivedOutputs[2].message, "Test debug message")
        XCTAssertEqual(receivedOutputs[2].file, "QuickOutputTest.swift")
    }

    func testLegacyOutputStreamStillWorks() {
        let expectation = XCTestExpectation(
            description: "Legacy API should still send to output stream")
        expectation.expectedFulfillmentCount = 2

        var receivedOutputs: [PrettyLoggerOutput] = []

        PrettyLogger.shared.output
            .sink { output in
                receivedOutputs.append(output)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Test legacy API (deprecated but should still work)
        let _ = logInfo("Legacy message 1", "part 2")
        let _ = logError("Legacy error")

        wait(for: [expectation], timeout: 3.0)

        // Verify we received the outputs
        XCTAssertEqual(receivedOutputs.count, 2)

        // Check legacy outputs have file/line info
        XCTAssertEqual(receivedOutputs[0].level, .info)
        XCTAssertEqual(receivedOutputs[0].message, "Legacy message 1 part 2")
        XCTAssertNotNil(receivedOutputs[0].file)  // Legacy API provides file info
        XCTAssertNotNil(receivedOutputs[0].line)  // Legacy API provides line info
        XCTAssertNotNil(receivedOutputs[0].formatted)  // Legacy API provides formatted string

        XCTAssertEqual(receivedOutputs[1].level, .error)
        XCTAssertEqual(receivedOutputs[1].message, "Legacy error")
        XCTAssertNotNil(receivedOutputs[1].file)
    }

    func testMixedAPIUsageInOutputStream() {
        let expectation = XCTestExpectation(
            description: "Both APIs should work together in output stream")
        expectation.expectedFulfillmentCount = 4

        var receivedOutputs: [PrettyLoggerOutput] = []

        PrettyLogger.shared.output
            .sink { output in
                receivedOutputs.append(output)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Mix both APIs
        logInfo("OSLog message")  // New API
        let _ = logWarning("Legacy warning")  // Legacy API
        logError("OSLog error", category: "Test")  // New API with category
        let _ = logDebug("Legacy debug", "with parts")  // Legacy API with parts

        wait(for: [expectation], timeout: 3.0)

        XCTAssertEqual(receivedOutputs.count, 4)

        XCTAssertNotNil(receivedOutputs[0].file)  // OSLog
        XCTAssertNotNil(receivedOutputs[1].file)  // Legacy
        XCTAssertNotNil(receivedOutputs[2].file)  // OSLog
        XCTAssertNotNil(receivedOutputs[3].file)  // Legacy
    }

    func testLevelFilteringWorksForBothAPIs() {
        PrettyLogger.shared.level = .error  // Only error and fatal should pass

        let expectation = XCTestExpectation(
            description: "Level filtering should work for both APIs")
        expectation.expectedFulfillmentCount = 4  // 2 from each API

        var receivedOutputs: [PrettyLoggerOutput] = []

        PrettyLogger.shared.output
            .sink { output in
                receivedOutputs.append(output)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // OSLog API - only error and fatal should pass
        logFatal("OSLog fatal - should pass")
        logError("OSLog error - should pass")
        logInfo("OSLog info - should be filtered")
        logDebug("OSLog debug - should be filtered")

        // Legacy API - only error and fatal should pass
        let _ = logFatal("Legacy fatal - should pass")
        let _ = logError("Legacy error - should pass")
        let _ = logInfo("Legacy info - should be filtered")
        let _ = logDebug("Legacy debug - should be filtered")

        wait(for: [expectation], timeout: 3.0)

        XCTAssertEqual(receivedOutputs.count, 4)
        XCTAssertEqual(receivedOutputs[0].level, .fatal)  // OSLog fatal
        XCTAssertEqual(receivedOutputs[1].level, .error)  // OSLog error
        XCTAssertEqual(receivedOutputs[2].level, .fatal)  // Legacy fatal
        XCTAssertEqual(receivedOutputs[3].level, .error)  // Legacy error
    }
}
