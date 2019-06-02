//
//  Handler.swift
//  RequiemLib
//
//  Created by Jacob Neil Taylor on 25/5/19.
//  Copyright © 2019 Jacob Neil Taylor. All rights reserved.
//

typealias BoolMap = Dictionary<String,Bool>
typealias ExecutionCallback = (ExecutionResult) -> Void

protocol ExecutionContext {
    func run(request: Request, callback: @escaping ExecutionCallback)
}
