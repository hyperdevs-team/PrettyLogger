import Combine
import Foundation
import OSLog

public class PrettyLogger {
    public static let shared = PrettyLogger()

    public var level: PrettyLoggerLevel = .all
    public var separator: String = " "
    public var terminator: String = "\n"
    public let output = PassthroughSubject<PrettyLoggerOutput, Never>()

    private let mFormatter = DateFormatter(dateFormat: "HH:mm:ss.SSS")

    internal init() {

    }

    // MARK: - Primary OSLog-based API

    internal func logFatal(
        _ message: String, category: String? = nil, privacy: PrettyLoggerPrivacy = .auto,
        file: String, line: Int, column: Int, function: String
    ) {
        // Check level filtering
        if level < .fatal {
            return
        }

        logWithPrivacy(
            logger: createLogger(for: category),
            level: .fault,
            prettyLoggerLevel: .fatal,
            message: message,
            privacy: privacy,
            file: file,
            line: line,
            column: column,
            function: function
        )
    }

    internal func logError(
        _ message: String, category: String? = nil, privacy: PrettyLoggerPrivacy = .auto,
        file: String, line: Int, column: Int, function: String
    ) {
        if level < .error {
            return
        }

        logWithPrivacy(
            logger: createLogger(for: category),
            level: .error,
            prettyLoggerLevel: .error,
            message: message,
            privacy: privacy,
            file: file,
            line: line,
            column: column,
            function: function
        )
    }

    internal func logWarning(
        _ message: String, category: String? = nil, privacy: PrettyLoggerPrivacy = .auto,
        file: String, line: Int, column: Int, function: String
    ) {
        if level < .warn {
            return
        }

        logWithPrivacy(
            logger: createLogger(for: category),
            level: .error,
            prettyLoggerLevel: .warn,
            message: message,
            privacy: privacy,
            file: file,
            line: line,
            column: column,
            function: function
        )
    }

    internal func logInfo(
        _ message: String, category: String? = nil, privacy: PrettyLoggerPrivacy = .auto,
        file: String, line: Int, column: Int, function: String
    ) {
        if level < .info {
            return
        }

        logWithPrivacy(
            logger: createLogger(for: category),
            level: .info,
            prettyLoggerLevel: .info,
            message: message,
            privacy: privacy,
            file: file,
            line: line,
            column: column,
            function: function
        )
    }

    internal func logDebug(
        _ message: String, category: String? = nil, privacy: PrettyLoggerPrivacy = .auto,
        file: String, line: Int, column: Int, function: String
    ) {
        if level < .debug {
            return
        }

        logWithPrivacy(
            logger: createLogger(for: category),
            level: .debug,
            prettyLoggerLevel: .debug,
            message: message,
            privacy: privacy,
            file: file,
            line: line,
            column: column,
            function: function
        )
    }

    internal func logTrace(
        _ message: String, category: String? = nil, privacy: PrettyLoggerPrivacy = .auto,
        file: String, line: Int, column: Int, function: String
    ) {
        if level < .trace {
            return
        }

        logWithPrivacy(
            logger: createLogger(for: category),
            level: .default,
            prettyLoggerLevel: .trace,
            message: message,
            privacy: privacy,
            file: file,
            line: line,
            column: column,
            function: function
        )
    }

    // MARK: - Legacy print-based API (internal)

    internal func logFatalLegacy(
        _ items: [Any], separator: String? = nil, terminator: String? = nil, file: String,
        line: Int, column: Int, function: String
    ) -> String? {
        if level < .fatal {
            return nil
        }
        return log(
            .fatal, items: items, separator: separator, terminator: terminator, file: file,
            line: line, column: column, function: function)
    }

    internal func logErrorLegacy(
        _ items: [Any], separator: String? = nil, terminator: String? = nil, file: String,
        line: Int, column: Int, function: String
    ) -> String? {
        if level < .error {
            return nil
        }
        return log(
            .error, items: items, separator: separator, terminator: terminator, file: file,
            line: line, column: column, function: function)
    }

    internal func logWarningLegacy(
        _ items: [Any], separator: String? = nil, terminator: String? = nil, file: String,
        line: Int, column: Int, function: String
    ) -> String? {
        if level < .warn {
            return nil
        }
        return log(
            .warn, items: items, separator: separator, terminator: terminator, file: file,
            line: line, column: column, function: function)
    }

    internal func logInfoLegacy(
        _ items: [Any], separator: String? = nil, terminator: String? = nil, file: String,
        line: Int, column: Int, function: String
    ) -> String? {
        if level < .info {
            return nil
        }
        return log(
            .info, items: items, separator: separator, terminator: terminator, file: file,
            line: line, column: column, function: function)
    }

    internal func logDebugLegacy(
        _ items: [Any], separator: String? = nil, terminator: String? = nil, file: String,
        line: Int, column: Int, function: String
    ) -> String? {
        if level < .debug {
            return nil
        }
        return log(
            .debug, items: items, separator: separator, terminator: terminator, file: file,
            line: line, column: column, function: function)
    }

    internal func logTraceLegacy(
        _ items: [Any], separator: String? = nil, terminator: String? = nil, file: String,
        line: Int, column: Int, function: String
    ) -> String? {
        if level < .trace {
            return nil
        }
        return log(
            .trace, items: items, separator: separator, terminator: terminator, file: file,
            line: line, column: column, function: function)
    }

    // MARK: - Private helpers

    private func createLogger(for category: String?) -> Logger {
        let subsystem = Bundle.main.bundleIdentifier ?? "com.prettylogger.default"
        let categoryName = category ?? "default"
        return Logger(subsystem: subsystem, category: categoryName)
    }

    private func logWithPrivacy(
        logger: Logger, level: OSLogType, prettyLoggerLevel: PrettyLoggerLevel, message: String,
        privacy: PrettyLoggerPrivacy, file: String, line: Int, column: Int, function: String
    ) {
        switch privacy {
        case .auto:
            logger.log(level: level, "\(message)")
        case .public:
            logger.log(level: level, "\(message, privacy: .public)")
        case .private:
            logger.log(level: level, "\(message, privacy: .private)")
        }

        sendOutput(
            prettyLoggerLevel,
            message: message,
            file: file,
            line: line,
            column: column,
            function: function
        )
    }

    private func sendOutput(
        _ logLevel: PrettyLoggerLevel, message: String, file: String, line: Int, column: Int,
        function: String, date: Date = Date()
    ) {
        let stringToPrint = stringForCurrentStyle(
            logLevel: logLevel,
            message: message,
            terminator: terminator,
            file: file,
            line: line,
            column: column,
            function: function,
            date: date
        )

        output.send(
            PrettyLoggerOutput(
                level: logLevel,
                message: message,
                file: (file as NSString).lastPathComponent,
                line: line,
                column: column,
                formatted: stringToPrint
            )
        )
    }

    private func log(
        _ logLevel: PrettyLoggerLevel, items: [Any], separator: String?, terminator: String?,
        file: String, line: Int, column: Int, function: String, date: Date = Date()
    ) -> String? {
        let separator = separator ?? self.separator
        let terminator = terminator ?? self.terminator

        let message = buildMessageForLogLevel(items, separator: separator)

        let stringToPrint = stringForCurrentStyle(
            logLevel: logLevel, message: message, terminator: terminator, file: file, line: line,
            column: column, function: function, date: date)
        print(stringToPrint, terminator: terminator)

        let output = PrettyLoggerOutput(
            level: logLevel,
            message: message,
            file: (file as NSString).lastPathComponent,
            line: line,
            column: column,
            formatted: stringToPrint
        )
        self.output.send(output)

        return stringToPrint
    }

    private func buildMessageForLogLevel(_ items: [Any], separator: String) -> String {
        var message = ""

        for (index, item) in items.enumerated() {
            message += String(describing: item) + (index == items.count - 1 ? "" : separator)
        }

        return message
    }

    private func stringForCurrentStyle(
        logLevel: PrettyLoggerLevel, message: String, terminator: String, file: String, line: Int,
        column: Int, function: String, date: Date
    ) -> String {
        let level = "\(logLevel.label)"

        let stringDate = "\(mFormatter.string(from: date))"
        let stringLocation = "[\((file as NSString).lastPathComponent):L\(line)]"
        return "\(stringDate) ◉ \(level) \(message) \(stringLocation)"
    }
}
