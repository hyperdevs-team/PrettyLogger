import Combine
import XCTest

@testable import PrettyLogger

class OSLogLevelConfigurationTests: XCTestCase {
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

    func testOSLogOnAllLevels() {
        PrettyLogger.shared.level = .all

        let expectation = XCTestExpectation(description: "All levels should produce output")
        expectation.expectedFulfillmentCount = 6

        var outputCount = 0
        PrettyLogger.shared.output
            .sink { _ in
                outputCount += 1
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Test all OSLog functions - they don't return values but should trigger output
        logFatal("fatal test")
        logError("error test")
        logWarning("warning test")
        logInfo("info test")
        logDebug("debug test")
        logTrace("trace test")

        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(outputCount, 6)
    }

    func testOSLogOnDisableLogger() {
        PrettyLogger.shared.level = .disable

        let expectation = XCTestExpectation(description: "No output should be produced")
        expectation.isInverted = true  // We expect this NOT to be fulfilled

        PrettyLogger.shared.output
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // None of these should produce output
        logFatal("fatal test")
        logError("error test")
        logWarning("warning test")
        logInfo("info test")
        logDebug("debug test")
        logTrace("trace test")

        wait(for: [expectation], timeout: 1.0)
    }

    func testOSLogOnFatalLevel() {
        PrettyLogger.shared.level = .fatal

        let expectation = XCTestExpectation(description: "Only fatal should produce output")
        expectation.expectedFulfillmentCount = 1

        var receivedLevels: [PrettyLoggerLevel] = []
        PrettyLogger.shared.output
            .sink { output in
                receivedLevels.append(output.level)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        logFatal("fatal test")
        logError("error test")
        logWarning("warning test")
        logInfo("info test")
        logDebug("debug test")
        logTrace("trace test")

        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedLevels, [.fatal])
    }

    func testOSLogOnErrorLevel() {
        PrettyLogger.shared.level = .error

        let expectation = XCTestExpectation(description: "Fatal and error should produce output")
        expectation.expectedFulfillmentCount = 2

        var receivedLevels: [PrettyLoggerLevel] = []
        PrettyLogger.shared.output
            .sink { output in
                receivedLevels.append(output.level)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        logFatal("fatal test")
        logError("error test")
        logWarning("warning test")
        logInfo("info test")
        logDebug("debug test")
        logTrace("trace test")

        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedLevels, [.fatal, .error])
    }

    func testOSLogOnWarnLevel() {
        PrettyLogger.shared.level = .warn

        let expectation = XCTestExpectation(
            description: "Fatal, error, and warning should produce output")
        expectation.expectedFulfillmentCount = 3

        var receivedLevels: [PrettyLoggerLevel] = []
        PrettyLogger.shared.output
            .sink { output in
                receivedLevels.append(output.level)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        logFatal("fatal test")
        logError("error test")
        logWarning("warning test")
        logInfo("info test")
        logDebug("debug test")
        logTrace("trace test")

        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedLevels, [.fatal, .error, .warn])
    }

    func testOSLogOnInfoLevel() {
        PrettyLogger.shared.level = .info

        let expectation = XCTestExpectation(description: "Fatal through info should produce output")
        expectation.expectedFulfillmentCount = 4

        var receivedLevels: [PrettyLoggerLevel] = []
        PrettyLogger.shared.output
            .sink { output in
                receivedLevels.append(output.level)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        logFatal("fatal test")
        logError("error test")
        logWarning("warning test")
        logInfo("info test")
        logDebug("debug test")
        logTrace("trace test")

        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedLevels, [.fatal, .error, .warn, .info])
    }

    func testOSLogOnDebugLevel() {
        PrettyLogger.shared.level = .debug

        let expectation = XCTestExpectation(
            description: "Fatal through debug should produce output")
        expectation.expectedFulfillmentCount = 5

        var receivedLevels: [PrettyLoggerLevel] = []
        PrettyLogger.shared.output
            .sink { output in
                receivedLevels.append(output.level)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        logFatal("fatal test")
        logError("error test")
        logWarning("warning test")
        logInfo("info test")
        logDebug("debug test")
        logTrace("trace test")

        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedLevels, [.fatal, .error, .warn, .info, .debug])
    }

    func testOSLogOnTraceLevel() {
        PrettyLogger.shared.level = .trace

        let expectation = XCTestExpectation(description: "All levels should produce output")
        expectation.expectedFulfillmentCount = 6

        var receivedLevels: [PrettyLoggerLevel] = []
        PrettyLogger.shared.output
            .sink { output in
                receivedLevels.append(output.level)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        logFatal("fatal test")
        logError("error test")
        logWarning("warning test")
        logInfo("info test")
        logDebug("debug test")
        logTrace("trace test")

        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedLevels, [.fatal, .error, .warn, .info, .debug, .trace])
    }

    func testOSLogWithCategories() {
        PrettyLogger.shared.level = .all

        let expectation = XCTestExpectation(description: "Logs with categories should work")
        expectation.expectedFulfillmentCount = 3

        var receivedMessages: [String] = []
        PrettyLogger.shared.output
            .sink { output in
                receivedMessages.append(output.message)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        logInfo("Network request", category: "Network")
        logError("Auth failed", category: "Authentication")
        logDebug("Cache hit", category: "Cache")

        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedMessages, ["Network request", "Auth failed", "Cache hit"])
    }

    func testOSLogWithPrivacy() {
        PrettyLogger.shared.level = .all

        let expectation = XCTestExpectation(description: "Logs with privacy should work")
        expectation.expectedFulfillmentCount = 3

        var receivedMessages: [String] = []
        PrettyLogger.shared.output
            .sink { output in
                receivedMessages.append(output.message)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        logInfo("Public info", privacy: .public)
        logDebug("Private debug", privacy: .private)
        logError("Auto privacy", privacy: .auto)

        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedMessages, ["Public info", "Private debug", "Auto privacy"])
    }

    func testOSLogWithCategoryAndPrivacy() {
        PrettyLogger.shared.level = .all

        let expectation = XCTestExpectation(
            description: "Logs with category and privacy should work")
        expectation.expectedFulfillmentCount = 1

        var receivedOutput: PrettyLoggerOutput?
        PrettyLogger.shared.output
            .sink { output in
                receivedOutput = output
                expectation.fulfill()
            }
            .store(in: &cancellables)

        logDebug("Sensitive data", category: "Auth", privacy: .private)

        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedOutput?.message, "Sensitive data")
        XCTAssertEqual(receivedOutput?.level, .debug)
    }
}
