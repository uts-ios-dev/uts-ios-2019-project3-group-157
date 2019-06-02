//
//  NetworkingClient.swift
//  GetApp
//
//  Created by Shadman Mahmood on 26/5/19.
//  Copyright © 2019 uts. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingClient {
    
    typealias webServiceResponse = ([[String:Any]]?,Error?)->Void
    
    
    
    func execute(_ url:URL,completion:@escaping webServiceResponse){
        var urlRequest=URLRequest(url: url)
        urlRequest.httpMethod="GET"
        Alamofire.request(urlRequest)
        
        Alamofire.request(url).validate().responseJSON
    {
        
        
            response in
            if let error=response.error
            {
               completion(nil,error)
                
            }
            else if let jsonArray=response.result.value as? [[String:Any]]
            {
                completion(jsonArray,nil)
            }
                
                
        
        else if let jsonDict=response.result.value as? [String:Any]
        {
            completion([jsonDict],nil)
        }
        
        
        
    }
    }
}
