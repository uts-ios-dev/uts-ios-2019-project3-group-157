//
//  LocalExecutionContext.swift
//  GetApp
//
//  Created by Jacob Neil Taylor on 2/6/19.
//  Copyright © 2019 uts. All rights reserved.
//

import Alamofire

class LocalExecutionContext: ExecutionContext {
    var encoding: ParameterEncoding = URLEncoding.default
    
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
            encoding: self.encoding,
            headers: self.getHeaders(request: request)
            ).response(completionHandler: { (response: DefaultDataResponse) in
                let result: ExecutionResult
                
                if let error = response.error {
                    result = ExecutionResult(request: request)
                    result.message = error.localizedDescription
                }
                else {
                    var value = ""
                    
                    if let data = response.data {
                        value = String(decoding: data, as: UTF8.self)
                    }
                    
                    let httpResponse = response.response!
                    let headers = httpResponse.allHeaderFields as! StringMap
                    let response = Response(
                        uri: request.getUri(),
                        responseCode: httpResponse.statusCode,
                        body: value
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
