//
//  Constant.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/10/26.
//

import Foundation

public struct Constant<Value: AnalogousType>: ValueProvider {
    public var value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
    
    public func encode(to encoder: any Encoder) throws {
        try value.encodeForShortcuts(to: encoder)
    }
}
