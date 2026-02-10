//
//  MagicVariable.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/10/26.
//

import Foundation

public struct MagicVariable: ValueProvider {
    public var actionInstanceID: UUID?
    public var customName: String?
    
    public init(_ customName: String? = nil) {
        self.actionInstanceID = nil
        self.customName = customName
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var valueContainer = container.nestedContainer(keyedBy: CodingKeys.ValueKeys.self, forKey: .value)
        try valueContainer.encode(actionInstanceID, forKey: .actionInstanceID)
        try valueContainer.encode(customName, forKey: .customName)
        try valueContainer.encode("ActionOutput", forKey: .type)
        
        try container.encode("WFTextTokenAttachment", forKey: .serializationType)
    }
    
    private enum CodingKeys: String, CodingKey {
        case value = "Value"
        case serializationType = "WFSerializationType"
        
        enum ValueKeys: String, CodingKey {
            case actionInstanceID = "OutputUUID"
            case customName = "OutputName"
            case type = "Type"
        }
    }
}
