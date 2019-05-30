//
//  Result.swift
//  RequiemLib
//
//  Created by Jacob Neil Taylor on 25/5/19.
//  Copyright © 2019 Jacob Neil Taylor. All rights reserved.
//

import Foundation

class ExecutionResult {
    let request: Request
    let response: Response?
    
    var success: Bool {
        get {
            if let _ = response {
                return true
            }
            return false
        }
    }
    
    var message = ""
    
    init(request: Request, response: Response? = nil) {
        self.request = request
        self.response = response
    }
}
