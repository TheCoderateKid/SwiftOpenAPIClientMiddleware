//
//  JWTMiddleware.swift
//  SwiftOpenAPIClientMiddleware
//
//  Created by CL on 4/1/25.
//

import Foundation
import OpenAPIURLSession
import HTTPTypes
import HTTPTypesFoundation
import OpenAPIRuntime

// MARK: - JWT Middleware

public struct JWTMiddleware: ClientMiddleware {
    private let tokenProvider: @Sendable () async throws -> String
    public init(tokenProvider: @escaping @Sendable () async throws -> String) {
        self.tokenProvider = tokenProvider
    }

    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var modifiedRequest = request
        let token = try await tokenProvider()
        modifiedRequest.headerFields.replaceOrAdd(name: "Authorization", value: "Bearer \(token)")
        return try await next(modifiedRequest, body, baseURL)
    }
}
