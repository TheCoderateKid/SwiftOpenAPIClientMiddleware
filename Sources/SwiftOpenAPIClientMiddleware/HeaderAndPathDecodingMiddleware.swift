//
//  HeaderAndPathDecodingMiddleware.swift
//  SwiftOpenAPIClientMiddleware
//
//  Created by CL on 4/1/25.
//

import Foundation
import OpenAPIURLSession
import HTTPTypes
import OpenAPIRuntime

// MARK: - Header and Path Decoding Middleware

public struct HeaderAndPathDecodingMiddleware: ClientMiddleware {
    public init() {}
    public func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var modifiedRequest = request

        modifiedRequest.headerFields = HTTPFields(
            request.headerFields.map { field in
                HTTPField(
                    name: field.name,
                    value: field.value.removingPercentEncoding ?? field.value
                )
            }
        )

        if let decodedPath = modifiedRequest.path?.removingPercentEncoding {
            modifiedRequest = HTTPRequest(
                method: modifiedRequest.method,
                scheme: modifiedRequest.scheme,
                authority: modifiedRequest.authority,
                path: decodedPath,
                headerFields: modifiedRequest.headerFields
            )
        }

        return try await next(modifiedRequest, body, baseURL)
    }
}
