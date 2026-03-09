import XCTest

@testable import PrettyLogger

class LegacyFormatOutputTests: XCTestCase {
    private var originalSeparator: String!
    private var originalTerminator: String!
    private var originalLevel: PrettyLoggerLevel!

    override func setUp() {
        super.setUp()
        // Save original state
        originalSeparator = PrettyLogger.shared.separator
        originalTerminator = PrettyLogger.shared.terminator
        originalLevel = PrettyLogger.shared.level
    }

    override func tearDown() {
        // Restore original state
        PrettyLogger.shared.separator = originalSeparator
        PrettyLogger.shared.terminator = originalTerminator
        PrettyLogger.shared.level = originalLevel
        super.tearDown()
    }

    func testLegacyOutputWithTwoParameters() {
        PrettyLogger.shared.level = .info
        PrettyLogger.shared.separator = " ❎ "
        let output = logInfo("2", "3")

        XCTAssertEqual(output?.contains("2 ❎ 3"), true)
    }
}
