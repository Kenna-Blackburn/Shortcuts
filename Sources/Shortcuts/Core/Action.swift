//
//  Action.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/10/26.
//

import Foundation

public protocol Action: ActionGroup {
    var instanceID: UUID { get }
    
    func compileAction() -> RawAction
}

extension Action {
    public func compileActionGroup() -> [RawAction] {
        var rawAction = self.compileAction()
        rawAction.instanceID = self.instanceID
        return [rawAction]
    }
    
    public var body: some ActionGroup {
        self
    }
}

extension Action {
    public func bind(to magicVariable: inout MagicVariable) -> Self {
        magicVariable.actionInstanceID = self.instanceID
        return self
    }
}
