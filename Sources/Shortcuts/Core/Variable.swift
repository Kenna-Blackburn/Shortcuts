//
//  Variable.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/11/26.
//

import Foundation
import Helpers

public struct Variable: ValueProvider {
    
    public var name: String
    
    public init(_ name: String) {
        self.name = name
    }
    
    public func encode(to encoder: any Encoder) throws {
        let dictionary: [String: Any] = [
            "Value": [
                "Type": "Variable",
                "VariableName": name,
            ],
            "WFSerializationType": "WFTextTokenAttachment",
        ]
        
        try AnyEncodable(dictionary).encode(to: encoder)
    }
}
