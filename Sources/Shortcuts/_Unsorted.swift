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
    public func compileActionGroup() -> [RawAction] {
        fatalError()
    }
    
    public var body: some ActionGroup {
        fatalError()
    }
}

// MARK: Actions
extension Never: Action {
    public var instanceID: UUID {
        fatalError()
    }
    
    public func compileAction() -> RawAction {
        fatalError()
    }
}

public struct Comment: Action {
    public var instanceID: UUID
    
    public var text: ValueProvider
    
    public init(text: ValueProvider = Constant("")) {
        self.instanceID = .init()
        self.text = text
    }
    
    public func compileAction() -> RawAction {
        RawAction("is.workflow.actions.comment", [
            "WFCommentActionText": text,
        ])
    }
}

public struct Repeat<Content: ActionGroup>: ActionGroup {
    public var groupingID: UUID
    public var iterations: Int
    public var content: Content
    
    public init(_ iterations: Int, @ActionGroupBuilder content: () -> Content) {
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
    }
}

public struct QuickLook: Action {
    public var instanceID: UUID
    
    public var value: ValueProvider
    
    public init(_ value: ValueProvider) {
        self.instanceID = .init()
        self.value = value
    }
    
    public func compileAction() -> RawAction {
        RawAction("is.workflow.actions.previewdocument", [
            "WFInput": value,
        ])
    }
}

public struct Number: Action {
    public var instanceID: UUID
    
    public var number: ValueProvider
    
    public init(_ number: ValueProvider) {
        self.instanceID = .init()
        self.number = number
    }
    
    public func compileAction() -> RawAction {
        RawAction("is.workflow.actions.number", [
            "WFNumberActionNumber": number
        ])
    }
}
