//
//  ClientCertificateAuthMiddleware.swift
//  SwiftOpenAPIClientMiddleware
//
//  Created by CL on 4/1/25.
//

import Foundation
import OpenAPIURLSession
import HTTPTypes
import OpenAPIRuntime

// MARK: - Client Certificate Auth Middleware

public struct ClientCertificateAuthMiddleware: ClientMiddleware {
    public init() {}
    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        return try await next(request, body, baseURL)
    }
}
