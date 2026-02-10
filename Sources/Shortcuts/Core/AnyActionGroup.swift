//
//  AnyActionGroup.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/9/26.
//

import Foundation

public struct AnyActionGroup: ActionGroup {
    
    public var children: [any ActionGroup]
    
    public init(children: [any ActionGroup]) {
        self.children = children
    }
    
    public init<each T: ActionGroup>(_ actionGroup: repeat each T) {
        var children = [any ActionGroup]()
        for actionGroup in repeat each actionGroup {
            children.append(actionGroup)
        }
        
        self.init(children: children)
    }
    
    public var trailingInstanceID: UUID {
        children.last!.trailingInstanceID
    }
    
    public func compile() -> [RawAction] {
        children.flatMap({ $0.compile() })
    }
    
    public var body: some ActionGroup {
        fatalError("tried to access \(#function) on \(Self.self)")
    }
}
