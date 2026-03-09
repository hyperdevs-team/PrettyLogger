import OSLog

@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
public enum PrettyLoggerPrivacy {
    case auto
    case `public`
    case `private`

    var osLogPrivacy: OSLogPrivacy {
        switch self {
        case .auto:
            return .auto

        case .public:
            return .public

        case .private:
            return .private
        }
    }
}
