//
//  AnyEncodable.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/9/26.
//

import Foundation

public struct AnyEncodable: Encodable {
    public var _encode: (any Encoder) throws -> Void
    
    public init(_ encode: @escaping (any Encoder) throws -> Void) {
        self._encode = encode
    }
    
    public init(_ base: some Encodable) {
        self.init(base.encode)
    }
    
    public init(_ value: Any) {
        self.init { encoder in
            func encode(_ value: Any, to encoder: Encoder) throws {
                switch value {
                case let value as any Encodable:
                    try value.encode(to: encoder)
                case let value as [String: Any]:
                    var container = encoder.container(keyedBy: AnyCodingKey.self)
                    for (key, value) in value {
                        try encode(value, to: container.superEncoder(forKey: .string(key)))
                    }
                case let value as [Any]:
                    var container = encoder.unkeyedContainer()
                    for element in value {
                        try encode(element, to: container.superEncoder())
                    }
                default:
                    fatalError("cannot encode \(type(of: value))")
                }
            }
            
            try encode(value, to: encoder)
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        try _encode(encoder)
    }
}
