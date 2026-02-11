//
//  _Unsorted.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/7/26.
//

import Foundation
import Helpers

protocol Shortcut: ActionGroup {
    
}

extension Shortcut {
    func compile(
        to outputURL: URL,
        using service: some SigningService,
    ) async throws {
        
    }
}

struct RawShortcut: Encodable {
    
}

protocol SigningService {
    
}

// MARK: AnalogousTypes
extension String: AnalogousType {
    
}

extension Int: AnalogousType {
    
}

extension Double: AnalogousType {
    
}

extension Bool: AnalogousType {
    
}

extension Array: AnalogousType where Element: AnalogousType {
    public func encodeForShortcuts(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try element.encodeForShortcuts(to: container.superEncoder())
        }
    }
}

// MARK: Never
extension Never: ActionGroup {
    public func compile() -> [RawAction] {
        fatalError()
    }
    
    public var body: some ActionGroup {
        fatalError()
    }
}

extension Never: AnalogousType {
    
}

// MARK: ActionGroups
public struct Comment: ActionGroup {
    
    public var trailingInstanceID: UUID
    
    public var text: ValueProvider // String
    
    public init(_ text: ValueProvider = Constant("")) {
        self.trailingInstanceID = .init()
        self.text = text
    }
    
    public init(_ text: String = "") {
        self.init(Constant(text))
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
    public var iterations: ValueProvider // Int
    public var content: Content
    
    public init(
        _ iterations: ValueProvider,
        @ActionGroupBuilder content: () -> Content,
    ) {
        self.trailingInstanceID = .init()
        self.groupingID = .init()
        self.iterations = iterations
        self.content = content()
    }
    
    public init(
        _ iterations: Int,
        @ActionGroupBuilder content: () -> Content,
    ) {
        self.init(Constant(iterations), content: content)
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
    
    public var value: ValueProvider // Any
    
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
    
    public var number: ValueProvider // Double | Int
    
    public init(_ number: ValueProvider) {
        self.trailingInstanceID = .init()
        self.number = number
    }
    
    public init(_ double: Double) {
        self.init(Constant(double))
    }
    
    public var body: some ActionGroup {
        RawAction("is.workflow.actions.number", [
            "WFNumberActionNumber": number
        ])
        .instanceID(trailingInstanceID)
    }
}

public struct Menu: ActionGroup {
    
    public var groupingID: UUID
    public var title: ValueProvider // String
    public var items: [Item]
    
    public init(
        _ title: ValueProvider,
        @ArrayBuilder<Item> items: () -> [Item]
    ) {
        self.groupingID = .init()
        self.title = title
        self.items = items()
    }
    
    public init(
        _ title: String,
        @ArrayBuilder<Item> items: () -> [Item]
    ) {
        self.init(Constant(title), items: items)
    }
    
    public var body: some ActionGroup {
        RawAction("is.workflow.actions.choosefrommenu", [
            "WFMenuPrompt": title,
            "WFMenuItems": items.map(\.title),
            "GroupingIdentifier": groupingID,
            "WFControlFlowMode": 0,
        ])
        
        for item in items {
            RawAction("is.workflow.actions.choosefrommenu", [
                "WFMenuItemTitle": item.title,
                "GroupingIdentifier": groupingID,
                "WFControlFlowMode": 1,
            ])
            
            item.content
        }
        
        RawAction("is.workflow.actions.choosefrommenu", [
            "GroupingIdentifier": groupingID,
            "WFControlFlowMode": 2,
        ])
    }
}

extension Menu {
    public struct Item {
        public var title: String
        public var content: AnyActionGroup
        
        public init(
            _ title: String,
            @ActionGroupBuilder content: () -> some ActionGroup
        ) {
            self.title = title
            self.content = .init(content())
        }
    }
}
