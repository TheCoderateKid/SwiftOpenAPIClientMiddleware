# SwiftOpenAPIClientMiddleware

[![Build](https://github.com/thecoderatekid/SwiftOpenAPIClientMiddleware/actions/workflows/swift-test.yml/badge.svg)](https://github.com/your-username/SwiftOpenAPIClientMiddleware/actions)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015%2B%20|%20macOS%2012%2B-blue)]()
[![License](https://img.shields.io/github/license/thecoderatekid/SwiftOpenAPIClientMiddleware)](LICENSE)

> A lightweight Swift package with plug-and-play `ClientMiddleware` for Apple's OpenAPI client — featuring JWT authentication, message signing, percent-decoding, and client cert stubs.

## 📦 Features

- Header and Path Decoding Middleware
- JWT Authentication Middleware
- Client Certificate Auth (stub)
- Request Message Signing Middleware

## 🧪 Requirements

- Swift 5.9+ (Swift 6 recommended)
- iOS 15+ / macOS 12+
- [swift-openapi-urlsession](https://github.com/apple/swift-openapi-urlsession)

## 🛠 Installation

Add the package to your `Package.swift`:

```swift
.package(url: "https://github.com/your-org/SwiftOpenAPIClientMiddleware.git", from: "0.1.0")
```

Then add it as a dependency to your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "SwiftOpenAPIClientMiddleware", package: "SwiftOpenAPIClientMiddleware")
    ]
)
```

## 🚀 Usage Examples

### ✅ Header and Path Decoding
```swift
let middleware = HeaderAndPathDecodingMiddleware()
```

### ✅ JWT Authentication
```swift
let jwtMiddleware = JWTMiddleware(tokenProvider: {
    // Fetch or generate your JWT token
    return "your.jwt.token"
})
```

### ✅ Message Signing
```swift
let signingMiddleware = MessageSigningMiddleware(signer: { request, body in
    // Your custom signing logic here
    return "signed-value"
})
```

### ✅ Combined Usage with Client
```swift
let client = Client(
  serverURL: URL(string: "https://api.example.com")!,
  transport: OpenAPITransport(
    middlewares: [
      HeaderAndPathDecodingMiddleware(),
      JWTMiddleware(tokenProvider: { "mock.jwt.token" }),
      MessageSigningMiddleware(signer: { req, body in "signed-value" })
    ]
  )
)
```

## 📚 Middleware Summary

### `HeaderAndPathDecodingMiddleware`
Removes percent-encoding from headers and paths before sending requests.

### `JWTMiddleware`
Injects `Authorization: Bearer <token>` into the request headers.

### `ClientCertificateAuthMiddleware`
Stub middleware — typically TLS-level cert handling is configured via `URLSession` delegate.

### `MessageSigningMiddleware`
Signs requests and adds the result as a custom header (e.g., `X-Signature`).

---

## 📄 License
MIT
