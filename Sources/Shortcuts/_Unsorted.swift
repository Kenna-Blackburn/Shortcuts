//
//  _Unsorted.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/7/26.
//

import Foundation
import Helpers















// MARK: AnalogousTypes
extension String: AnalogousType {
    
}

extension Int: AnalogousType {
    
}

extension Double: AnalogousType {
    
}

extension Bool: AnalogousType {
    
}

extension Never: AnalogousType {
    
}

extension Array: AnalogousType where Element: AnalogousType {
    public func encodeForShortcuts(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try element.encodeForShortcuts(to: container.superEncoder())
        }
    }
}

// MARK: ActionGroups
extension Never: ActionGroup {
    public func compile() -> [RawAction] {
        fatalError()
    }
    
    public var body: some ActionGroup {
        fatalError()
    }
}

public struct Comment: ActionGroup {
    
    public var trailingInstanceID: UUID
    
    public var text: ValueProvider
    
    public init(text: ValueProvider = Constant("")) {
        self.trailingInstanceID = .init()
        self.text = text
    }
    
    public var body: some ActionGroup {
        RawAction("is.workflow.actions.comment", [
            "WFCommentActionText": text,
        ])
        .instanceID(trailingInstanceID)
    }
}

public struct Repeat<Content: ActionGroup>: ActionGroup {
    
    public var trailingInstanceID: UUID
    
    public var groupingID: UUID
    public var iterations: ValueProvider
    public var content: Content
    
    public init(_ iterations: ValueProvider, @ActionGroupBuilder content: () -> Content) {
        self.trailingInstanceID = .init()
        self.groupingID = .init()
        self.iterations = iterations
        self.content = content()
    }
    
    public var body: some ActionGroup {
        RawAction("is.workflow.actions.repeat.count", [
            "WFRepeatCount": iterations,
            "GroupingIdentifier": groupingID,
            "WFControlFlowMode": 0,
        ])
        
        content
        
        RawAction("is.workflow.actions.repeat.count", [
            "GroupingIdentifier": groupingID,
            "WFControlFlowMode": 2,
        ])
        .instanceID(trailingInstanceID)
    }
}

public struct QuickLook: ActionGroup {
    
    public var trailingInstanceID: UUID
    
    public var value: ValueProvider
    
    public init(_ value: ValueProvider) {
        self.trailingInstanceID = .init()
        self.value = value
    }
    
    public var body: some ActionGroup {
        RawAction("is.workflow.actions.previewdocument", [
            "WFInput": value,
        ])
        .instanceID(trailingInstanceID)
    }
}

public struct Number: ActionGroup {
    
    public var trailingInstanceID: UUID
    
    public var number: ValueProvider
    
    public init(_ number: ValueProvider) {
        self.trailingInstanceID = .init()
        self.number = number
    }
    
    public var body: some ActionGroup {
        RawAction("is.workflow.actions.number", [
            "WFNumberActionNumber": number
        ])
        .instanceID(trailingInstanceID)
    }
}
