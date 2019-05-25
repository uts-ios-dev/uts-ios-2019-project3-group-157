//
//  Response.swift
//  RequiemLib
//
//  Created by Jacob Neil Taylor on 25/5/19.
//  Copyright © 2019 Jacob Neil Taylor. All rights reserved.
//

import Foundation

class Response {
    private let uri: String
    private let responseCode: Int
    private var body: String
    private var headers = StringMap()
    
    init(uri: String, responseCode: Int, body: String) {
        self.uri = uri
        self.responseCode = responseCode
        self.body = body
    }
    
    func getUri() -> String {
        return uri
    }
    
    func getResponseCode() -> Int {
        return responseCode
    }
    
    func getBody() -> String {
        return body
    }
    
    func setHeader(name: String, value: String) {
        headers[name] = value
    }
    
    func getHeader(name: String) -> String {
        return headers[name]!
    }
    
    func getHeaderNames() -> [String] {
        return Array(headers.keys)
    }
}
