import XCTest

@testable import PrettyLogger

class LegacyLevelConfigurationTests: XCTestCase {
    private var originalLevel: PrettyLoggerLevel!
    private var originalSeparator: String!
    private var originalTerminator: String!

    override func setUp() {
        super.setUp()
        // Save original state
        originalLevel = PrettyLogger.shared.level
        originalSeparator = PrettyLogger.shared.separator
        originalTerminator = PrettyLogger.shared.terminator
    }

    override func tearDown() {
        // Restore original state
        PrettyLogger.shared.level = originalLevel
        PrettyLogger.shared.separator = originalSeparator
        PrettyLogger.shared.terminator = originalTerminator
        super.tearDown()
    }

    func testLegacyLogOnAllLevels() {
        PrettyLogger.shared.level = .all
        XCTAssertNotNil(logFatal("fatal"))
        XCTAssertNotNil(logError("error"))
        XCTAssertNotNil(logWarning("warning"))
        XCTAssertNotNil(logInfo("info"))
        XCTAssertNotNil(logDebug("debug"))
        XCTAssertNotNil(logTrace("trace"))
    }

    func testLegacyLogOnDisableLogger() {
        PrettyLogger.shared.level = .disable
        XCTAssertNil(logFatal("fatal"))
        XCTAssertNil(logError("error"))
        XCTAssertNil(logWarning("warning"))
        XCTAssertNil(logInfo("info"))
        XCTAssertNil(logDebug("debug"))
        XCTAssertNil(logTrace("trace"))
    }

    func testLegacyLogOnFatalLevel() {
        PrettyLogger.shared.level = .fatal
        XCTAssertNotNil(logFatal("fatal"))
        XCTAssertNil(logError("error"))
        XCTAssertNil(logWarning("warning"))
        XCTAssertNil(logInfo("info"))
        XCTAssertNil(logDebug("debug"))
        XCTAssertNil(logTrace("trace"))
    }

    func testLegacyLogOnErrorLevel() {
        PrettyLogger.shared.level = .error
        XCTAssertNotNil(logFatal("fatal"))
        XCTAssertNotNil(logError("error"))
        XCTAssertNil(logWarning("warning"))
        XCTAssertNil(logInfo("info"))
        XCTAssertNil(logDebug("debug"))
        XCTAssertNil(logTrace("trace"))
    }

    func testLegacyLogOnWarnLevel() {
        PrettyLogger.shared.level = .warn
        XCTAssertNotNil(logFatal("fatal"))
        XCTAssertNotNil(logError("error"))
        XCTAssertNotNil(logWarning("warning"))
        XCTAssertNil(logInfo("info"))
        XCTAssertNil(logDebug("debug"))
        XCTAssertNil(logTrace("trace"))
    }

    func testLegacyLogOnInfoLevel() {
        PrettyLogger.shared.level = .info
        XCTAssertNotNil(logFatal("fatal"))
        XCTAssertNotNil(logError("error"))
        XCTAssertNotNil(logWarning("warning"))
        XCTAssertNotNil(logInfo("info"))
        XCTAssertNil(logDebug("debug"))
        XCTAssertNil(logTrace("trace"))
    }

    func testLegacyLogOnDebugLevel() {
        PrettyLogger.shared.level = .debug
        XCTAssertNotNil(logFatal("fatal"))
        XCTAssertNotNil(logError("error"))
        XCTAssertNotNil(logWarning("warning"))
        XCTAssertNotNil(logInfo("info"))
        XCTAssertNotNil(logDebug("debug"))
        XCTAssertNil(logTrace("trace"))
    }

    func testLegacyLogOnTraceLevel() {
        PrettyLogger.shared.level = .trace
        XCTAssertNotNil(logFatal("fatal"))
        XCTAssertNotNil(logError("error"))
        XCTAssertNotNil(logWarning("warning"))
        XCTAssertNotNil(logInfo("info"))
        XCTAssertNotNil(logDebug("debug"))
        XCTAssertNotNil(logTrace("trace"))
    }

    func testComparable() {
        XCTAssertTrue(PrettyLoggerLevel.info < PrettyLoggerLevel.debug)
        XCTAssertTrue(PrettyLoggerLevel.info <= PrettyLoggerLevel.info)
        XCTAssertTrue(PrettyLoggerLevel.info >= PrettyLoggerLevel.info)
        XCTAssertTrue(PrettyLoggerLevel.info > PrettyLoggerLevel.warn)

        PrettyLoggerLevel.allCases.forEach { level in
            XCTAssertTrue(level >= PrettyLoggerLevel.disable)
            XCTAssertTrue(level <= PrettyLoggerLevel.all)
        }
    }

    func testLabel() {
        PrettyLoggerLevel.allCases.forEach { level in
            switch level {
            case .warn, .fatal, .error:
                XCTAssertEqual(level.label.count, 3)
            case .info, .debug, .trace:
                XCTAssertEqual(level.label.count, 1)
            case .all, .disable:
                XCTAssertEqual(level.label.count, 0)
            }
        }
    }
}
