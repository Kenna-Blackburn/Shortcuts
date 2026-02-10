//
//  ActionGroup.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/9/26.
//

import Foundation

public protocol ActionGroup {
    associatedtype Body: ActionGroup
    
    var trailingInstanceID: UUID { get }
    
    func compile() -> [RawAction]
    
    @ActionGroupBuilder
    var body: Body { get }
}

extension ActionGroup {
    public var trailingInstanceID: UUID {
        body.trailingInstanceID
    }
    
    public func compile() -> [RawAction] {
        body.compile()
    }
}

extension ActionGroup {
    public func bind(to magicVariable: inout MagicVariable) -> Self {
        magicVariable.actionInstanceID = trailingInstanceID
        return self
    }
}
