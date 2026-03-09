import Foundation

// MARK: - Primary OSLog-based API

public func logFatal(
    _ message: String, category: String? = nil, privacy: PrettyLoggerPrivacy = .auto,
    file: String = #file, line: Int = #line, column: Int = #column, function: String = #function
) {
    PrettyLogger.shared.logFatal(
        message, category: category, privacy: privacy, file: file, line: line, column: column,
        function: function)
}

public func logError(
    _ message: String, category: String? = nil, privacy: PrettyLoggerPrivacy = .auto,
    file: String = #file, line: Int = #line, column: Int = #column, function: String = #function
) {
    PrettyLogger.shared.logError(
        message, category: category, privacy: privacy, file: file, line: line, column: column,
        function: function)
}

public func logWarning(
    _ message: String, category: String? = nil, privacy: PrettyLoggerPrivacy = .auto,
    file: String = #file, line: Int = #line, column: Int = #column, function: String = #function
) {
    PrettyLogger.shared.logWarning(
        message, category: category, privacy: privacy, file: file, line: line, column: column,
        function: function)
}

public func logInfo(
    _ message: String, category: String? = nil, privacy: PrettyLoggerPrivacy = .auto,
    file: String = #file, line: Int = #line, column: Int = #column, function: String = #function
) {
    PrettyLogger.shared.logInfo(
        message, category: category, privacy: privacy, file: file, line: line, column: column,
        function: function)
}

public func logDebug(
    _ message: String, category: String? = nil, privacy: PrettyLoggerPrivacy = .auto,
    file: String = #file, line: Int = #line, column: Int = #column, function: String = #function
) {
    PrettyLogger.shared.logDebug(
        message, category: category, privacy: privacy, file: file, line: line, column: column,
        function: function)
}

public func logTrace(
    _ message: String, category: String? = nil, privacy: PrettyLoggerPrivacy = .auto,
    file: String = #file, line: Int = #line, column: Int = #column, function: String = #function
) {
    PrettyLogger.shared.logTrace(
        message, category: category, privacy: privacy, file: file, line: line, column: column,
        function: function)
}

// MARK: - Legacy print-based API (deprecated)

@available(*, deprecated, message: "Use logFatal(_ message: String, category: String?, privacy: PrettyLoggerPrivacy) instead")
@discardableResult
public func logFatal(
    _ items: Any..., separator: String? = nil, terminator: String? = nil, file: String = #file,
    line: Int = #line, column: Int = #column, function: String = #function
) -> String? {
    return PrettyLogger.shared.logFatalLegacy(
        items, separator: separator, terminator: terminator, file: file, line: line, column: column,
        function: function)
}

@available(*, deprecated, message: "Use logError(_ message: String, category: String?, privacy: PrettyLoggerPrivacy) instead")
@discardableResult
public func logError(
    _ items: Any..., separator: String? = nil, terminator: String? = nil, file: String = #file,
    line: Int = #line, column: Int = #column, function: String = #function
) -> String? {
    return PrettyLogger.shared.logErrorLegacy(
        items, separator: separator, terminator: terminator, file: file, line: line, column: column,
        function: function)
}

@available(*, deprecated, message: "Use logWarning(_ message: String, category: String?, privacy: PrettyLoggerPrivacy) instead")
@discardableResult
public func logWarning(
    _ items: Any..., separator: String? = nil, terminator: String? = nil, file: String = #file,
    line: Int = #line, column: Int = #column, function: String = #function
) -> String? {
    return PrettyLogger.shared.logWarningLegacy(
        items, separator: separator, terminator: terminator, file: file, line: line, column: column,
        function: function)
}

@available(*, deprecated, message: "Use logInfo(_ message: String, category: String?, privacy: PrettyLoggerPrivacy) instead")
@discardableResult
public func logInfo(
    _ items: Any..., separator: String? = nil, terminator: String? = nil, file: String = #file,
    line: Int = #line, column: Int = #column, function: String = #function
) -> String? {
    return PrettyLogger.shared.logInfoLegacy(
        items, separator: separator, terminator: terminator, file: file, line: line, column: column,
        function: function)
}

@available(*, deprecated, message: "Use logDebug(_ message: String, category: String?, privacy: PrettyLoggerPrivacy) instead")
@discardableResult
public func logDebug(
    _ items: Any..., separator: String? = nil, terminator: String? = nil, file: String = #file,
    line: Int = #line, column: Int = #column, function: String = #function
) -> String? {
    return PrettyLogger.shared.logDebugLegacy(
        items, separator: separator, terminator: terminator, file: file, line: line, column: column,
        function: function)
}

@available(*, deprecated, message: "Use logTrace(_ message: String, category: String?, privacy: PrettyLoggerPrivacy) instead")
@discardableResult
public func logTrace(
    _ items: Any..., separator: String? = nil, terminator: String? = nil, file: String = #file,
    line: Int = #line, column: Int = #column, function: String = #function
) -> String? {
    return PrettyLogger.shared.logTraceLegacy(
        items, separator: separator, terminator: terminator, file: file, line: line, column: column,
        function: function)
}
