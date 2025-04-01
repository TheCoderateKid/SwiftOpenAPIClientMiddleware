//
//  MessageSigningMiddleware.swift
//  SwiftOpenAPIClientMiddleware
//
//  Created by CL on 4/1/25.
//

import Foundation
import OpenAPIURLSession
import HTTPTypes
import OpenAPIRuntime

// MARK: - Message Signing Middleware

public struct MessageSigningMiddleware: ClientMiddleware {
    private let signer: @Sendable (HTTPRequest, HTTPBody?) async throws -> String
    public init(signer: @escaping @Sendable (HTTPRequest, HTTPBody?) async throws -> String) {
        self.signer = signer
    }

    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var modifiedRequest = request
        let signature = try await signer(request, body)
        modifiedRequest.headerFields.replaceOrAdd(name: "X-Signature", value: signature)
        return try await next(modifiedRequest, body, baseURL)
    }
}
