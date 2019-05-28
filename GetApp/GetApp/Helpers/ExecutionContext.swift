//
//  Handler.swift
//  RequiemLib
//
//  Created by Jacob Neil Taylor on 25/5/19.
//  Copyright © 2019 Jacob Neil Taylor. All rights reserved.
//

import Alamofire

typealias BoolMap = Dictionary<String,Bool>
typealias ExecutionCallback = (ExecutionResult) -> Void

protocol ExecutionContext {
    func run(request: Request, callback: @escaping ExecutionCallback)
}

class LocalExecutionContext: ExecutionContext {
    static let methodBodyMap: BoolMap = [
        "GET": false,
        "POST": true,
        "PUT": true,
        "PATCH": true,
        "DELETE": false,
        "OPTIONS": false,
    ]
    
    private func getHeaders(request: Request) -> HTTPHeaders {
        var headers = HTTPHeaders()
        
        for name in request.getHeaderNames() {
            headers[name] = request.getHeader(name: name)
        }
        
        return headers
    }
    
    private func getParameters(request: Request) -> Parameters? {
        let names = request.getParameterNames()
        
        if names.count > 0 {
            var params = Parameters()
        
            for name in request.getParameterNames() {
                params[name] = request.getParameter(name: name)
            }
        
            return params
        }
        return nil
    }
    
    func run(request: Request, callback: @escaping ExecutionCallback) {
        Alamofire.request(
            request.getUri(),
            method: HTTPMethod(rawValue: request.getMethod())!,
            parameters: self.getParameters(request: request),
            headers: self.getHeaders(request: request)
            ).responseString(completionHandler: { (response: DataResponse<String>) in
                let result: ExecutionResult
                
                if let error = response.error {
                    result = ExecutionResult(request: request)
                    result.message = error.localizedDescription
                }
                else {
                    let httpResponse = response.response!
                    let headers = httpResponse.allHeaderFields as! StringMap
                    let response = Response(
                        uri: request.getUri(),
                        responseCode: httpResponse.statusCode,
                        body: response.value!
                    )
                    
                    let names = Array(headers.keys)
                    
                    for name in names {
                        response.setHeader(name: name, value: headers[name]!)
                    }
                    
                    result = ExecutionResult(request: request, response: response)
                }
                
                callback(result)
            })
    }
}
