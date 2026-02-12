//
//  MagicVariable.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/10/26.
//

import Foundation
import Helpers

public struct MagicVariable: ValueProvider {
    
    public var actionInstanceID: UUID?
    public var customName: String?
    
    public init(_ customName: String? = nil) {
        self.actionInstanceID = nil
        self.customName = customName
    }
    
    public func encode(to encoder: any Encoder) throws {
        let dictionary: [String: Any] = [
            "Value": [
                "Type": "ActionOutput",
                "OutputUUID": actionInstanceID as Any,
                "OutputName": customName as Any,
            ],
            "WFSerializationType": "WFTextTokenAttachment",
        ]
        
        try AnyEncodable(dictionary).encode(to: encoder)
    }
}
