//
//  AnyCodingKey.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/9/26.
//

import Foundation

public struct AnyCodingKey: CodingKey, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral {
    public var stringValue: String
    public var intValue: Int?
    
    public init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
    
    public init(_ base: some CodingKey) {
        self.init(stringValue: base.stringValue, intValue: base.intValue)
    }
    
    public init(stringValue: String) {
        self.init(stringValue: stringValue, intValue: Int(stringValue))
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(stringValue: value)
    }
    
    public static func string(_ stringValue: String) -> Self {
        .init(stringValue: stringValue)
    }
    
    public init(intValue: Int) {
        self.init(stringValue: String(intValue), intValue: intValue)
    }
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(intValue: value)
    }
    
    public static func int(_ intValue: Int) -> Self {
        .init(intValue: intValue)
    }
}
