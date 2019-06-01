//
//  RequiemLib.swift
//  RequiemLib
//
//  Created by Jacob Neil Taylor on 25/5/19.
//  Copyright © 2019 Jacob Neil Taylor. All rights reserved.
//

typealias StringMap = Dictionary<String,String>

class Request: Codable {
    private let uri: String
    private let method: String
    private var headers = StringMap()
    private var parameters = StringMap()
    var encoding = "urlencoded"
    
    init(uri: String, method: String) {
        self.uri = uri
        self.method = method
    }
    
    func getUri() -> String {
        return uri
    }
    
    func getMethod() -> String {
        return method
    }
    
    func setHeader(name: String, value: String) {
        headers[name] = value
    }
    
    func setParameter(name: String, value: String) {
        parameters[name] = value
    }
    
    func getHeader(name: String) -> String {
        return headers[name]!
    }
    
    func getParameter(name: String) -> String {
        return parameters[name]!
    }
    
    func getHeaderNames() -> [String] {
        return Array(headers.keys)
    }
    
    func getParameterNames() -> [String] {
        return Array(parameters.keys)
    }
 }
