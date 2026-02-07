//
//  _Unsorted.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/7/26.
//

import Foundation
import Helpers

public protocol AnalogousType {
    func encodeForShortcuts(to encoder: any Encoder) throws
}

extension AnalogousType where Self: Encodable {
    public func encodeForShortcuts(to encoder: any Encoder) throws {
        try self.encode(to: encoder)
    }
}

public protocol ValueProvider<Value>: Encodable {
    associatedtype Value: AnalogousType
}

public struct Constant<_Value: AnalogousType>: ValueProvider {
    public typealias Value = _Value
    
    public var value: Value
    
    public func encode(to encoder: any Encoder) throws {
        try value.encodeForShortcuts(to: encoder)
    }
}

public struct MagicVariable<_Value: AnalogousType>: ValueProvider {
    public typealias Value = _Value
    
    public var actionInstanceID: UUID?
    public var customName: String?
    
    public init(_ customName: String? = nil, for type: Value.Type) {
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

public protocol Action: ActionGroup {
    var instanceID: UUID { get }
    
    func compileAction() -> RawAction
}

extension Action {
    public func compileActionGroup() -> [RawAction] {
        [self.compileAction()]
    }
    
    public var body: some ActionGroup {
        self
    }
}

extension Action {
    public func bind<T: AnalogousType>(to magicVariable: inout MagicVariable<T>) -> Self {
        magicVariable.actionInstanceID = self.instanceID
        return self
    }
}



extension String: AnalogousType {}
extension Int: AnalogousType {}
extension Double: AnalogousType {}
extension Bool: AnalogousType {}
extension Never: AnalogousType {}

extension Array: AnalogousType where Element: AnalogousType {
    public func encodeForShortcuts(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try element.encodeForShortcuts(to: container.superEncoder())
        }
    }
}

extension Never: ActionGroup {
    public func compile() -> [RawAction] {
        fatalError()
    }
    
    public var magicVariable: MagicVariable<Never>? {
        fatalError()
    }
    
    public var body: some ActionGroup {
        fatalError()
    }
}
