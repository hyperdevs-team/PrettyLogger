# PrettyLogger Usage Examples

This document provides examples of how to use PrettyLogger with the new OSLog-based API.

## Basic Usage

### Simple Logging

```swift
import PrettyLogger

// Basic logging with different levels
logFatal("Application crashed with critical error")
logError("Failed to load user data")
logWarning("Low memory warning")
logInfo("User logged in successfully")
logDebug("Processing request with ID: 12345")
logTrace("Entering function: processUserData()")
```

### Logging with Categories

Categories help organize logs in different subsystems of your app:

```swift
// Network-related logs
logError("Connection timeout", category: "Network")
logInfo("API request completed", category: "Network")

// UI-related logs
logWarning("Button animation took longer than expected", category: "UI")
logDebug("View controller loaded", category: "UI")

// Database-related logs
logError("Failed to save user preferences", category: "Database")
logInfo("Database migration completed", category: "Database")
```

### Privacy Levels

Control the privacy of sensitive information in logs:

```swift
let userID = "user123"
let email = "user@example.com"
let password = "secretPassword"

// Default behavior - sensitive data is automatically handled
logInfo("User \(userID) logged in")

// Explicitly public - visible in all log viewers
logInfo("App version: 1.2.3", privacy: .public)

// Explicitly private - hidden in release builds
logDebug("User email: \(email)", privacy: .private)
logWarning("Authentication failed for user", privacy: .private)

// Auto privacy (recommended) - system decides based on context
logError("Login failed for user \(userID)", privacy: .auto)
```

## Advanced Usage

### Conditional Logging with Levels

You can control which logs are shown by setting the global log level:

```swift
// Only show fatal and error logs
PrettyLogger.shared.level = .error

// Show all logs including trace
PrettyLogger.shared.level = .all

// Disable all logging
PrettyLogger.shared.level = .disable
```

### Real-time Log Monitoring

Subscribe to log outputs for real-time monitoring:

```swift
import Combine

var cancellables = Set<AnyCancellable>()

PrettyLogger.shared.output
    .sink { logOutput in
        print("Log received:")
        print("Level: \(logOutput.level)")
        print("Message: \(logOutput.message)")
        print("File: \(logOutput.file)")
        print("Line: \(logOutput.line)")
        print("Formatted: \(logOutput.formatted)")
    }
    .store(in: &cancellables)

// Now any log will be captured by the subscriber
logInfo("This will be captured by the subscriber")
```

### Custom Categories for Different Features

```swift
// Authentication
logInfo("User authentication started", category: "Auth")
logError("Invalid credentials provided", category: "Auth")

// Payment Processing
logDebug("Processing payment for amount: $\(amount)", category: "Payment")
logWarning("Payment gateway response slow", category: "Payment")

// Analytics
logTrace("User action tracked: button_tap", category: "Analytics")
logInfo("Analytics batch sent successfully", category: "Analytics")
```

## Migration from Legacy API

### Before (Deprecated - print-based)

```swift
// Old print-based API (deprecated)
logInfo("User logged in", "additional data")
logError("Something went wrong", error.localizedDescription)
logDebug("Debug info:", debugData, "more info")
```

### After (Recommended - OSLog-based)

```swift
// New OSLog-based API - same function names!
logInfo("User logged in with additional data")
logError("Something went wrong: \(error.localizedDescription)")
logDebug("Debug info: \(debugData) - more info")

// With categories for better organization
logInfo("User logged in", category: "Authentication")
logError("Network request failed", category: "Network")
logDebug("Cache miss for key: \(key)", category: "Cache")
```

### Easy Migration Steps

1. **Replace variadic parameters with string interpolation:**
   ```swift
   // Old
   logInfo("User:", username, "logged in")
   
   // New
   logInfo("User: \(username) logged in")
   ```

2. **Add optional categories:**
   ```swift
   // Before
   logError("Database connection failed")
   
   // After (enhanced)
   logError("Database connection failed", category: "Database")
   ```

3. **Add privacy controls when needed:**
   ```swift
   // For sensitive data
   logDebug("Auth token: \(token)", category: "Auth", privacy: .private)
   
   // For public information
   logInfo("App version: \(version)", privacy: .public)
   ```

## Best Practices

### 1. Use Appropriate Log Levels

```swift
// Fatal: Only for crashes or critical failures
logFatal("Database corruption detected - app cannot continue")

// Error: For errors that don't crash the app but are significant
logError("Failed to save user data to disk")

// Warning: For unexpected but recoverable situations
logWarning("Using fallback configuration due to missing config file")

// Info: For general information about app flow
logInfo("User completed onboarding process")

// Debug: For detailed debugging information
logDebug("Cache hit rate: \(hitRate)% for session")

// Trace: For very detailed execution flow
logTrace("Entering method: calculateUserScore()")
```

### 2. Use Categories Consistently

```swift
// Create constants for category names to avoid typos
extension String {
    static let networkCategory = "Network"
    static let authCategory = "Authentication"
    static let cacheCategory = "Cache"
    static let uiCategory = "UI"
}

// Use them consistently
logError("Connection failed", category: .networkCategory)
logInfo("User authenticated", category: .authCategory)
logDebug("Cache cleared", category: .cacheCategory)
```

### 3. Handle Privacy Appropriately

```swift
let userID = getCurrentUserID()
let sensitiveToken = getAuthToken()

// Good: Sensitive data marked as private
logDebug("Auth token refreshed", category: "Auth", privacy: .private)

// Good: Non-sensitive data can be public
logInfo("App launched in \(environment) environment", privacy: .public)

// Good: Let system decide for user IDs
logInfo("Processing request for user \(userID)", privacy: .auto)
```

### 4. Structured Logging

```swift
// Good: Structured and searchable
logInfo("API request completed", category: "Network")
logDebug("Request details - URL: \(url), Status: \(statusCode), Duration: \(duration)ms", category: "Network")

// Better: Even more structured
logInfo("API_REQUEST_COMPLETED url=\(url) status=\(statusCode) duration=\(duration)", category: "Network")
```

## Function Overview

| Function | OSLog Level | Use Case |
|----------|-------------|----------|
| `logFatal()` | `.fault` | Critical errors that crash the app |
| `logError()` | `.error` | Errors that don't crash but are significant |
| `logWarning()` | `.default` | Unexpected but recoverable situations |
| `logInfo()` | `.info` | General information about app flow |
| `logDebug()` | `.debug` | Detailed debugging information |
| `logTrace()` | `.debug` | Very detailed execution flow |

## Console and Instruments Integration

When using the new OSLog-based API, your logs will automatically appear in:

1. **Xcode Console**: Filter by subsystem and category
2. **Console.app**: System-wide log viewing with advanced filtering
3. **Instruments**: Performance analysis with log correlation
4. **Command Line**: Using `log show` command

### Viewing Logs in Console.app

1. Open Console.app on macOS
2. Filter by your app's bundle identifier
3. Use category filters to focus on specific subsystems
4. Search for specific log messages or patterns

### Using log command line tool

```bash
# Show logs from your app
log show --predicate 'subsystem == "com.yourapp.bundleid"'

# Filter by category
log show --predicate 'subsystem == "com.yourapp.bundleid" AND category == "Network"'

# Show only errors and above
log show --predicate 'subsystem == "com.yourapp.bundleid" AND messageType >= error'
```

## Complete Example

```swift
import PrettyLogger

class NetworkManager {
    func login(username: String, password: String) {
        logInfo("Starting user authentication", category: "Auth")
        
        guard !username.isEmpty else {
            logError("Username cannot be empty", category: "Auth")
            return
        }
        
        logDebug("Validating credentials for user", category: "Auth", privacy: .private)
        
        // Simulate network request
        logTrace("Making API request to /auth/login", category: "Network")
        
        // Success case
        logInfo("User authenticated successfully", category: "Auth")
        logDebug("Session token received", category: "Auth", privacy: .private)
        
        // Or error case
        // logError("Authentication failed: Invalid credentials", category: "Auth")
    }
}
```

This approach maintains backward compatibility while providing all the benefits of OSLog!