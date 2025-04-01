// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftOpenAPIClientMiddleware",
    platforms: [
        .iOS(.v15), .macOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftOpenAPIClientMiddleware",
            targets: ["SwiftOpenAPIClientMiddleware"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-urlsession.git", from: "1.0.2"),
        .package(url: "https://github.com/apple/swift-http-types.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftOpenAPIClientMiddleware",
            dependencies: [
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "HTTPTypesFoundation", package: "swift-http-types")
            ]
        ),
        .testTarget(
            name: "SwiftOpenAPIClientMiddlewareTests",
            dependencies: [
                "SwiftOpenAPIClientMiddleware",
            ]
        )
    ]
)
