# PrettyLogger Migration Guide

This guide shows how easy it is to migrate from the old print-based API to the new OSLog-based API while keeping the same function names.

## Overview

PrettyLogger now uses Apple's unified logging system (OSLog) instead of `print` statements, providing better performance, privacy controls, and integration with system tools. The best part? **You keep using the same function names!**

## Quick Migration

### What Changes
- **Function signatures**: New parameters for `category` and `privacy`
- **Parameter format**: String interpolation instead of variadic parameters
- **Logging backend**: OSLog instead of print statements

### What Stays the Same
- **Function names**: `logInfo`, `logError`, `logWarning`, etc.
- **Import statement**: `import PrettyLogger`
- **Basic usage patterns**

## Step-by-Step Migration

### 1. Simple Messages (No Changes Needed!)

```swift
// Before and After - EXACTLY THE SAME!
logInfo("User logged in successfully")
logError("Network connection failed")
logWarning("Low memory warning")
logDebug("Processing user data")
```

### 2. Multiple Parameters → String Interpolation

```swift
// Before (deprecated)
logInfo("User:", username, "logged in at:", timestamp)
logError("Error code:", errorCode, "message:", error.localizedDescription)

// After (recommended)
logInfo("User: \(username) logged in at: \(timestamp)")
logError("Error code: \(errorCode) message: \(error.localizedDescription)")
```

### 3. Add Categories for Better Organization (Optional)

```swift
// Before
logInfo("API request completed")
logError("Database connection failed")
logDebug("Cache hit for key: user_123")

// After (enhanced with categories)
logInfo("API request completed", category: "Network")
logError("Database connection failed", category: "Database")
logDebug("Cache hit for key: user_123", category: "Cache")
```

### 4. Add Privacy Controls for Sensitive Data (Optional)

```swift
// Before
logDebug("Auth token: abc123xyz")
logInfo("User email: user@example.com")

// After (with privacy)
logDebug("Auth token: \(token)", category: "Auth", privacy: .private)
logInfo("User email: \(email)", category: "Auth", privacy: .private)
```

## Real-World Example

### Before (Old API)
```swift
class AuthManager {
    func login(email: String, password: String) -> Bool {
        logInfo("Starting login process")
        logDebug("Email:", email, "Password length:", password.count)
        
        if email.isEmpty {
            logError("Login failed:", "Email is empty")
            return false
        }
        
        // Simulate API call
        logTrace("Making API call to:", "/auth/login")
        
        // Success
        logInfo("Login successful for user:", email)
        return true
    }
}
```

### After (New API)
```swift
class AuthManager {
    func login(email: String, password: String) -> Bool {
        logInfo("Starting login process", category: "Auth")
        logDebug("Email: \(email) Password length: \(password.count)", 
                category: "Auth", privacy: .private)
        
        if email.isEmpty {
            logError("Login failed: Email is empty", category: "Auth")
            return false
        }
        
        // Simulate API call
        logTrace("Making API call to: /auth/login", category: "Network")
        
        // Success
        logInfo("Login successful for user: \(email)", 
               category: "Auth", privacy: .private)
        return true
    }
}
```

## Migration Strategies

### Strategy 1: Minimal Changes (Easiest)
1. Replace variadic parameters with string interpolation
2. Remove any `separator` and `terminator` parameters
3. Done! Your logs now use OSLog

### Strategy 2: Gradual Enhancement (Recommended)
1. Start with minimal changes (Strategy 1)
2. Gradually add categories to group related logs
3. Add privacy controls for sensitive data
4. Test with Console.app and Instruments

### Strategy 3: Complete Modernization
1. Apply minimal changes
2. Define category constants
3. Add comprehensive privacy controls
4. Update log messages for better structure
5. Add performance monitoring

## Category Best Practices

### Define Constants
```swift
extension String {
    static let auth = "Authentication"
    static let network = "Network"
    static let database = "Database"
    static let ui = "UserInterface"
    static let cache = "Cache"
}

// Usage
logError("Connection timeout", category: .network)
logInfo("User authenticated", category: .auth)
```

### Hierarchical Categories
```swift
// Use dot notation for subcategories
logDebug("Cache miss", category: "Cache.User")
logInfo("Database query", category: "Database.Read")
logError("Network timeout", category: "Network.API")
```

## Privacy Guidelines

| Data Type | Recommended Privacy | Example |
|-----------|-------------------|---------|
| User IDs | `.auto` | `logInfo("User \(userID) logged in", privacy: .auto)` |
| Email addresses | `.private` | `logDebug("Email: \(email)", privacy: .private)` |
| Passwords/Tokens | `.private` | `logTrace("Token refreshed", privacy: .private)` |
| App version | `.public` | `logInfo("App version: \(version)", privacy: .public)` |
| Error messages | `.auto` | `logError("Network error: \(error)", privacy: .auto)` |

## Testing Your Migration

### 1. Compile and Run
```bash
# Make sure everything compiles
swift build

# Run your tests
swift test
```

### 2. Check Console.app
1. Open Console.app on macOS
2. Filter by your app's bundle identifier
3. Verify logs appear with proper categories
4. Test privacy settings

### 3. Use Command Line Tools
```bash
# Show logs from your app
log show --predicate 'subsystem == "com.yourapp.bundleid"' --last 1h

# Filter by category
log show --predicate 'category == "Network"' --last 30m
```

## Common Issues and Solutions

### Issue: Too Many Parameters
```swift
// Problem: Old habit of many parameters
logInfo("User:", user.id, "action:", action, "result:", result, "time:", time)

// Solution: Use string interpolation
logInfo("User: \(user.id) action: \(action) result: \(result) time: \(time)")
```

### Issue: Missing Privacy Controls
```swift
// Problem: Sensitive data exposed
logDebug("Processing payment for card: \(cardNumber)")

// Solution: Mark as private
logDebug("Processing payment for card: \(cardNumber)", 
        category: "Payment", privacy: .private)
```

### Issue: No Categories
```swift
// Problem: All logs mixed together
logError("Database connection failed")
logError("Network request timeout")

// Solution: Use categories
logError("Database connection failed", category: "Database")
logError("Network request timeout", category: "Network")
```

## Benefits After Migration

✅ **Better Performance**: OSLog is faster and more efficient than print  
✅ **Privacy Controls**: Automatic handling of sensitive data  
✅ **System Integration**: Works with Console.app, Instruments, and log command  
✅ **Structured Logging**: Categories help organize and filter logs  
✅ **Production Ready**: Proper log levels for release builds  
✅ **Same Function Names**: No need to learn new API  

## Need Help?

- Check `USAGE_EXAMPLES.md` for comprehensive examples
- Use Console.app to verify your logs are working
- Test privacy settings in release builds
- Consider gradual migration for large codebases

The migration is designed to be as smooth as possible while providing modern logging capabilities!