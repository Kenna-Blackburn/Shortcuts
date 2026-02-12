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
    public var content: (Variable) -> Content
    
    public init(
        _ iterations: ValueProvider,
        @ActionGroupBuilder content: @escaping (Variable) -> Content,
    ) {
        self.trailingInstanceID = .init()
        self.groupingID = .init()
        self.iterations = iterations
        self.content = content
    }
    
    public init(
        _ iterations: Int,
        @ActionGroupBuilder content: @escaping (Variable) -> Content,
    ) {
        self.init(Constant(iterations), content: content)
    }
    
    public var body: some ActionGroup {
        RawAction("is.workflow.actions.repeat.count", [
            "WFRepeatCount": iterations,
            "GroupingIdentifier": groupingID,
            "WFControlFlowMode": 0,
        ])
        
        let repeatIndex = Variable("Repeat Index") // this won't work with nested Repeats
        content(repeatIndex)
        
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

public struct ShowResult: ActionGroup {
    
    public var trailingInstanceID: UUID
    
    public var value: ValueProvider // String | Any
    
    public init(_ value: ValueProvider) {
        self.trailingInstanceID = .init()
        self.value = value
    }
    
    public init(_ value: String) {
        self.init(Constant(value))
    }
    
    public var body: some ActionGroup {
        RawAction("is.workflow.actions.showresult", [
            "Text": value,
        ])
        .instanceID(trailingInstanceID)
    }
}

typealias ShowContent = ShowResult

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
    
    public var trailingInstanceID: UUID
    
    public var groupingID: UUID
    public var title: ValueProvider // String
    public var items: [Item]
    
    public init(
        _ title: ValueProvider,
        @ArrayBuilder<Item> items: () -> [Item]
    ) {
        self.trailingInstanceID = .init()
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
        .instanceID(trailingInstanceID)
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

public enum AskFor {
    public struct Text: ActionGroup {
        
        public var trailingInstanceID: UUID
        
        public var prompt: ValueProvider // String
        public var defaultAnswer: ValueProvider // String
        public var allowMultipleLines: ValueProvider // Bool
        
        public init(
            with prompt: ValueProvider,
            default defaultAnswer: ValueProvider,
            multiline allowMultipleLines: ValueProvider,
        ) {
            self.trailingInstanceID = .init()
            self.prompt = prompt
            self.defaultAnswer = defaultAnswer
            self.allowMultipleLines = allowMultipleLines
        }
        
        public init(
            with prompt: String = "",
            default defaultAnswer: String = "",
            multiline allowMultipleLines: Bool = true,
        ) {
            self.init(
                with: Constant(prompt),
                default: Constant(defaultAnswer),
                multiline: Constant(allowMultipleLines),
            )
        }
        
        public var body: some ActionGroup {
            RawAction("is.workflow.actions.ask", [
                "WFInputType": "Text",
                "WFAskActionPrompt": prompt,
                "WFAskActionDefaultAnswer": defaultAnswer,
                "WFAllowsMultilineText": allowMultipleLines
            ])
            .instanceID(trailingInstanceID)
        }
    }
}

public struct SelectContacts: ActionGroup {
    
    public var trailingInstanceID: UUID
    
    public var allowMultiple: ValueProvider // Bool
    
    public init(multiple allowMultiple: ValueProvider ) {
        self.trailingInstanceID = .init()
        self.allowMultiple = allowMultiple
    }
    
    public init(multiple allowMultiple: Bool) {
        self.init(multiple: Constant(allowMultiple))
    }
    
    public var body: some ActionGroup {
        RawAction("is.workflow.actions.selectcontacts", [
            "WFSelectMultiple": allowMultiple,
        ])
        .instanceID(trailingInstanceID)
    }
}

public struct SplitText: ActionGroup {
    
    public var trailingInstanceID: UUID
    
    public var text: ValueProvider // String
    public var delimiter: ValueProvider // String
    
    public init(_ text: ValueProvider, by delimiter: ValueProvider) {
        self.trailingInstanceID = .init()
        self.text = text
        self.delimiter = delimiter
    }
    
    public init(_ text: ValueProvider, by delimiter: String) {
        self.init(text, by: Constant(delimiter))
    }
    
    public var body: some ActionGroup {
        RawAction("is.workflow.actions.text.split", [
            "text": text,
            "WFTextSeparator": "Custom",
            "WFTextCustomSeparator": delimiter,
        ])
        .instanceID(trailingInstanceID)
    }
}

public struct RepeatEach<Content: ActionGroup>: ActionGroup {
    
    public var trailingInstanceID: UUID
    
    public var groupingID: UUID
    public var sequence: ValueProvider // [Any]
    public var content: (Variable, Variable) -> Content
    
    public init(
        _ sequence: ValueProvider,
        @ActionGroupBuilder content: @escaping (Variable, Variable) -> Content,
    ) {
        self.trailingInstanceID = .init()
        self.groupingID = .init()
        self.sequence = sequence
        self.content = content
    }
    
    public var body: some ActionGroup {
        RawAction("is.workflow.actions.repeat.each", [
            "WFInput": sequence,
            "GroupingIdentifier": groupingID,
            "WFControlFlowMode": 0,
        ])
        
        let repeatIndex = Variable("Repeat Index") // this won't work with nested Repeats
        let repeatItem = Variable("Repeat Item") // this won't work with nested Repeats
        content(repeatIndex, repeatItem)
        
        RawAction("is.workflow.actions.repeat.each", [
            "GroupingIdentifier": groupingID,
            "WFControlFlowMode": 2,
        ])
        .instanceID(trailingInstanceID)
    }
}

public struct SendMessage: ActionGroup {
    
    public var trailingInstanceID: UUID
    
    public var message: ValueProvider // String
    public var recipients: ValueProvider // Contact | [Contact]
    
    public init(_ message: ValueProvider, to recipients: ValueProvider) {
        self.trailingInstanceID = .init()
        self.message = message
        self.recipients = recipients
    }
    
    public var body: some ActionGroup {
        RawAction("is.workflow.actions.sendmessage", [
            "WFSendMessageContent": message,
            "WFSendMessageActionRecipients": recipients,
        ])
        .instanceID(trailingInstanceID)
    }
}
