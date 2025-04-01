import Testing
import Foundation
import HTTPTypes
import OpenAPIURLSession
@testable import SwiftOpenAPIClientMiddleware

@Test
func headerAndPathDecoding() async throws {
    let middleware = HeaderAndPathDecodingMiddleware()

    let encodedPath = "/test%20path"
    let encodedHeader = HTTPField(name: .init("X-Test-Header")!, value: "value%20encoded")

    let request = HTTPRequest(
        method: .get,
        scheme: "https",
        authority: "api.example.com",
        path: encodedPath,
        headerFields: HTTPFields([encodedHeader])
    )


    let (response, _) = try await middleware.intercept(
        request,
        body: nil,
        baseURL: URL(string: "https://api.example.com")!,
        operationID: "test",
        next: { req, _, _ in
            #expect(req.path == "/test path")

            let headerName = HTTPField.Name("X-Test-Header")!
            #expect(req.headerFields[headerName] == "value encoded")

            return (HTTPResponse(status: .ok), nil)
        }
    )

    #expect(response.status == .ok)
}

@Test
func jwtMiddlewareInjection() async throws {
    let token = "mock.jwt.token"
    let middleware = JWTMiddleware(tokenProvider: { token })

    let request = HTTPRequest(
        method: .get,
        scheme: "https",
        authority: "api.example.com",
        path: "/protected",
        headerFields: [:]
    )

    let (response, _) = try await middleware.intercept(
        request,
        body: nil,
        baseURL: URL(string: "https://api.example.com")!,
        operationID: "auth",
        next: { req, _, _ in
            let authHeader = HTTPField.Name("Authorization")!
            #expect(req.headerFields[authHeader] == "Bearer \(token)")
            return (HTTPResponse(status: .ok), nil)
        }
    )

    #expect(response.status == .ok)
}

@Test
func messageSigningMiddleware() async throws {
    let middleware = MessageSigningMiddleware(signer: { _, _ in "signed-value" })

    let request = HTTPRequest(
        method: .post,
        scheme: "https",
        authority: "api.example.com",
        path: "/submit",
        headerFields: [:]
    )

    let (response, _) = try await middleware.intercept(
        request,
        body: nil,
        baseURL: URL(string: "https://api.example.com")!,
        operationID: "sign",
        next: { req, _, _ in
            let signatureHeader = HTTPField.Name("X-Signature")!
            #expect(req.headerFields[signatureHeader] == "signed-value")
            return (HTTPResponse(status: .ok), nil)
        }
    )

    #expect(response.status == .ok)
}
