//
//  Utils.swift
//  SwiftOpenAPIClientMiddleware
//
//  Created by CL on 4/1/25.
//


import HTTPTypes

extension HTTPFields {
    mutating func replaceOrAdd(name: String, value: String) {
        let fieldName = HTTPField.Name(name)
        if let fieldName = fieldName {
            if let index = firstIndex(where: { $0.name == fieldName }) {
                self[index] = HTTPField(name: fieldName, value: value)
            } else {
                append(HTTPField(name: fieldName, value: value))
            }
        } else {
            assertionFailure("Invalid HTTP field name: \(name)")
        }
    }
}

