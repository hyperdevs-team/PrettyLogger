import Foundation
import OSLog

public enum PrettyLoggerLevel: Int, Comparable, CaseIterable {
    case disable = 0
    case fatal = 1
    case error = 2
    case warn = 3
    case info = 4
    case debug = 5
    case trace = 6
    case all = 7

    public var label: String {
        switch self {
        case .trace: return "✏️"
        case .info:  return "🔍"
        case .debug: return "🐛"
        case .error: return "❌❌❌"
        case .fatal: return "☠️☠️☠️"
        case .warn:  return "⚠️⚠️⚠️"
        case .all, .disable: return ""
        }
    }

    public static func < (lhs: PrettyLoggerLevel, rhs: PrettyLoggerLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public static func <= (lhs: PrettyLoggerLevel, rhs: PrettyLoggerLevel) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }

    public static func > (lhs: PrettyLoggerLevel, rhs: PrettyLoggerLevel) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }

    public static func >= (lhs: PrettyLoggerLevel, rhs: PrettyLoggerLevel) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
}
