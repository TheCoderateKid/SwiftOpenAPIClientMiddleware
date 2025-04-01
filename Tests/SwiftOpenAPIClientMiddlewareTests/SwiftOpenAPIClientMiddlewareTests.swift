
import XCTest
import HTTPTypes
import HTTPTypesFoundation
import Foundation
import OpenAPIURLSession
@testable import SwiftOpenAPIClientMiddleware

final class SwiftOpenAPIClientMiddlewareTests: XCTestCase {

    func testHeaderAndPathDecoding() async throws {
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
                XCTAssertEqual(req.path, "/test path")

                let headerName = HTTPField.Name("X-Test-Header")!
                XCTAssertEqual(req.headerFields[headerName], "value encoded")

                return (HTTPResponse(status: .ok), nil)
            }
        )

        XCTAssertEqual(response.status, .ok)
    }

    func testJWTMiddlewareInjection() async throws {
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
                XCTAssertEqual(req.headerFields[authHeader], "Bearer \(token)")
                return (HTTPResponse(status: .ok), nil)
            }
        )

        XCTAssertEqual(response.status, .ok)
    }

    func testMessageSigningMiddleware() async throws {
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
                XCTAssertEqual(req.headerFields[signatureHeader], "signed-value")
                return (HTTPResponse(status: .ok), nil)
            }
        )

        XCTAssertEqual(response.status, .ok)
    }
}
