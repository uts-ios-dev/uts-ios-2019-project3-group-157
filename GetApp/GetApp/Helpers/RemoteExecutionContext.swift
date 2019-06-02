//
//  RemoteExecutionContext.swift
//  GetApp
//
//  Created by Jacob Neil Taylor on 2/6/19.
//  Copyright © 2019 uts. All rights reserved.
//

import Alamofire

extension Data: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = self
        return request
    }
}

let PROXY_API_URL = "https://utils.jacobtaylor.id.au/default/requestProxy"

class RemoteExecutionContext: ExecutionContext {
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
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(request)
            Alamofire.request(
                PROXY_API_URL,
                method: HTTPMethod.post,
                parameters: [:],
                encoding: data,
                headers: ["Content-type":"application/json"]
                ).response(completionHandler: { (response: DefaultDataResponse) in
                    let result: ExecutionResult
                    
                    if let error = response.error {
                        result = ExecutionResult(request: request)
                        result.message = error.localizedDescription
                    }
                    else {
                        let httpResponse = response.response!
                        let outerCode = httpResponse.statusCode
                        
                        if outerCode == 200 {
                            let decoder = JSONDecoder()
                            let data = response.data!
                            do {
                                let innerResponse = try decoder.decode(Response.self, from: data)
                                result = ExecutionResult(request: request, response: innerResponse)
                            }
                            catch {
                                result = ExecutionResult(request: request)
                                result.message = error.localizedDescription
                            }
                        }
                        else {
                            result = ExecutionResult(request: request)
                            result.message = "Unexpected proxy response code: \(outerCode)"
                        }
                    }
                    
                    callback(result)
                })
        }
        catch {
            let result = ExecutionResult(request: request)
            result.message = error.localizedDescription
            callback(result)
        }
    }
}
