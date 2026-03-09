import Combine
import XCTest

@testable import PrettyLogger

class LegacyOutputTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
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
        cancellables.removeAll()
        super.tearDown()
    }

    func testLegacyOutputText() {
        PrettyLogger.shared.level = .info
        PrettyLogger.shared.separator = " ❎ "

        let expirationComplete = expectation(description: "wait for output in output")

        var expectedOutput: String? = nil
        PrettyLogger.shared
            .output
            .delay(for: 2, scheduler: RunLoop.main)
            .sink { output in
                XCTAssertEqual(output.formatted, expectedOutput)
                expirationComplete.fulfill()
            }
            .store(in: &cancellables)

        expectedOutput = logInfo("hola holita")

        waitForExpectations(timeout: 10)
    }
}
