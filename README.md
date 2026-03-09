# PrettyLogger

![Platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=flat)
![Platform](https://img.shields.io/badge/platform-tvOS-blue.svg?style=flat)
![Platform](https://img.shields.io/badge/platform-mac-blue.svg?style=flat)

## Introduction
A modern Swift logging library that integrates with Apple's unified logging system (OSLog) while maintaining a simple and familiar API. Provides structured logging with categories, privacy controls, and seamless integration with system debugging tools 💪

## Platforms
Support for iOS 14.0+, tvOS 14.0+, watchOS 7.0+, and macOS 11.0+

## Support
For Swift 4 please use v1

For Swift 5 please use v2-v3

For Swift 5.5+ with OSLog please use v4+

## Installation
PrettyLogger is available through [Swift Package Manager](https://swift.org/package-manager/).

1. Follow Apple's [Adding Package Dependencies to Your App](
https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app
) guide on how to add a Swift Package dependency.
2. Use `https://github.com/hyperdevs-team/PrettyLogger` as the repository URL.
3. Specify the version to be at least `4.0.0`.

## Usage

### Basic Logging
To log messages, simply use any of the global functions:
```swift
logFatal("Critical error occurred")
logError("Something went wrong")
logWarning("This is a warning")
logInfo("User logged in successfully")
logDebug("Processing user data")
logTrace("Entering function")
```

### Logging with Categories
Organize your logs with categories for better filtering and debugging:
```swift
logInfo("API request started", category: "Network")
logError("Database connection failed", category: "Database")
logDebug("Cache hit for user data", category: "Cache")
logWarning("Low memory warning", category: "System")
```

### Privacy Controls
Control the visibility of sensitive information in your logs:
```swift
let userEmail = "user@example.com"
let authToken = "abc123xyz"

// Public information (visible in all log viewers)
logInfo("App version 1.2.3", privacy: .public)

// Private information (hidden in release builds)
logDebug("User email: \(userEmail)", category: "Auth", privacy: .private)
logTrace("Auth token: \(authToken)", category: "Auth", privacy: .private)

// Auto privacy (system decides based on context) - Default behavior
logInfo("User logged in successfully", privacy: .auto)
```

### Complete Examples
```swift
// Basic usage
logInfo("User authentication started")

// With category
logError("Network timeout occurred", category: "Network")

// With privacy
logDebug("Processing sensitive data", privacy: .private)

// With both category and privacy
logWarning("Failed login attempt", category: "Security", privacy: .private)
```

> **Note**: Starting with version 4.0.0, PrettyLogger uses Apple's unified logging system (OSLog). This means logs are now visible not only in Xcode's console but also in system tools like Console.app, Instruments, and the command-line `log` tool, providing better integration with Apple's debugging ecosystem.

### Log Levels
You can control which logs are shown by setting the level on the shared instance:
```swift
PrettyLogger.shared.level = .all      // Show all messages
PrettyLogger.shared.level = .disable  // Disable all logging
PrettyLogger.shared.level = .info     // Show info and above (hide debug & trace)
PrettyLogger.shared.level = .error    // Show only error and fatal messages
```

The available levels, in order from most restrictive to least restrictive, are:
`disable`, `fatal`, `error`, `warn`, `info`, `debug`, `trace`, `all`

### Real-time Log Monitoring
You can subscribe to log outputs for real-time monitoring or custom handling:
```swift
import Combine

var cancellables = Set<AnyCancellable>()

PrettyLogger.shared.output
    .sink { logOutput in
        print("Received log: \(logOutput.level) - \(logOutput.message)")
        // Send to analytics, crash reporting, etc.
    }
    .store(in: &cancellables)
```

### Viewing Logs in System Tools

With version 4.0.0, you can view your app's logs in various Apple debugging tools:

- **Xcode Console**: Shows logs during development and debugging
- **Console.app**: System-wide log viewer with advanced filtering capabilities
- **Instruments**: Correlate logs with performance data
- **Command Line**: Use `log show --predicate 'subsystem == "com.yourapp.bundleid"'`

### Global Framework Import
If you want to use logging functions throughout your project without importing PrettyLogger in every file, add this to your AppDelegate:
```swift
@_exported import PrettyLogger
```

## Migration from v3 to v4

Version 4.0.0 introduces OSLog integration while maintaining the same familiar function names. The main changes are:

- **Enhanced API**: New optional `category` and `privacy` parameters
- **Better Performance**: Uses Apple's optimized logging system
- **System Integration**: Logs appear in Console.app, Instruments, and other system tools
- **Privacy Controls**: Built-in support for sensitive data handling

Your existing code will continue to work with deprecation warnings guiding you to the new API:

```swift
// v3 style (still works, but deprecated)
logInfo("User:", username, "logged in")

// v4 style (recommended)
logInfo("User: \(username) logged in", category: "Authentication")
```

## Requirements

- iOS 14.0+ / tvOS 14.0+ / watchOS 7.0+ / macOS 11.0+
- Swift 5.5+
- Xcode 13.0+
