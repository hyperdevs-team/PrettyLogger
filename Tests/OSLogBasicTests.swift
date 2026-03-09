import XCTest

@testable import PrettyLogger

class OSLogBasicTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Reset to default state
        PrettyLogger.shared.level = .all
    }

    func testBasicOSLogFunctions() {
        // Test that OSLog functions can be called without crashing
        // These functions don't return values, so we test they execute successfully

        XCTAssertNoThrow(logFatal("Fatal message"))
        XCTAssertNoThrow(logError("Error message"))
        XCTAssertNoThrow(logWarning("Warning message"))
        XCTAssertNoThrow(logInfo("Info message"))
        XCTAssertNoThrow(logDebug("Debug message"))
        XCTAssertNoThrow(logTrace("Trace message"))
    }

    func testOSLogWithCategory() {
        // Test that category parameter works
        XCTAssertNoThrow(logFatal("Fatal with category", category: "Test"))
        XCTAssertNoThrow(logError("Error with category", category: "Network"))
        XCTAssertNoThrow(logWarning("Warning with category", category: "UI"))
        XCTAssertNoThrow(logInfo("Info with category", category: "Database"))
        XCTAssertNoThrow(logDebug("Debug with category", category: "Cache"))
        XCTAssertNoThrow(logTrace("Trace with category", category: "Auth"))
    }

    func testOSLogWithPrivacy() {
        // Test that privacy parameter works
        XCTAssertNoThrow(logInfo("Public message", privacy: .public))
        XCTAssertNoThrow(logInfo("Private message", privacy: .private))
        XCTAssertNoThrow(logInfo("Auto privacy message", privacy: .auto))
    }

    func testOSLogWithAllParameters() {
        // Test that all parameters work together
        XCTAssertNoThrow(logFatal("Fatal", category: "Test", privacy: .public))
        XCTAssertNoThrow(logError("Error", category: "Network", privacy: .private))
        XCTAssertNoThrow(logWarning("Warning", category: "UI", privacy: .auto))
        XCTAssertNoThrow(logInfo("Info", category: "Database", privacy: .public))
        XCTAssertNoThrow(logDebug("Debug", category: "Cache", privacy: .private))
        XCTAssertNoThrow(logTrace("Trace", category: "Auth", privacy: .auto))
    }

    func testOSLogWithStringInterpolation() {
        // Test that string interpolation works properly
        let userID = "user123"
        let count = 42
        let isActive = true

        XCTAssertNoThrow(logInfo("User \(userID) has \(count) items"))
        XCTAssertNoThrow(logDebug("Status: \(isActive ? "active" : "inactive")"))
        XCTAssertNoThrow(logError("Error for user \(userID): count=\(count)", category: "Debug"))
    }

    func testOSLogWithEmptyMessage() {
        // Test that empty messages work
        XCTAssertNoThrow(logInfo(""))
        XCTAssertNoThrow(logError("", category: "Test"))
        XCTAssertNoThrow(logDebug("", privacy: .private))
        XCTAssertNoThrow(logWarning("", category: "Test", privacy: .auto))
    }

    func testOSLogWithNilCategory() {
        // Test that nil category (default) works
        XCTAssertNoThrow(logInfo("Message with nil category", category: nil))
        XCTAssertNoThrow(logError("Another message", category: nil, privacy: .auto))
    }

    func testOSLogWithLongMessage() {
        // Test that long messages work
        let longMessage = String(repeating: "This is a long message. ", count: 50)

        XCTAssertNoThrow(logInfo(longMessage))
        XCTAssertNoThrow(logDebug(longMessage, category: "Performance"))
        XCTAssertNoThrow(logError(longMessage, category: "Test", privacy: .private))
    }

    func testOSLogWithSpecialCharacters() {
        // Test that special characters work
        let messageWithEmojis = "User logged in 🎉 with status ✅"
        let messageWithUnicode = "Café naïve résumé"
        let messageWithSymbols = "Price: $100.50 @ 50% off"

        XCTAssertNoThrow(logInfo(messageWithEmojis))
        XCTAssertNoThrow(logDebug(messageWithUnicode, category: "i18n"))
        XCTAssertNoThrow(logWarning(messageWithSymbols, privacy: .public))
    }

    func testOSLogCategoryConstants() {
        // Test using category constants (common pattern)
        let networkCategory = "Network"
        let authCategory = "Authentication"
        let uiCategory = "UserInterface"

        XCTAssertNoThrow(logInfo("API request started", category: networkCategory))
        XCTAssertNoThrow(logError("Login failed", category: authCategory))
        XCTAssertNoThrow(logDebug("Button tapped", category: uiCategory))
    }

    func testOSLogDoesNotReturnValue() {
        // Verify that OSLog functions don't return values (unlike legacy API)
        // This is a compile-time check, but we can verify the type

        let result1: Void = logInfo("Test message")
        let result2: Void = logError("Test error", category: "Test")
        let result3: Void = logDebug("Test debug", privacy: .private)

        // If this compiles, the functions correctly return Void
        XCTAssertTrue(true)  // Just to have an assertion
    }
}
