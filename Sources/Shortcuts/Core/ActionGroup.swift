//
//  ActionGroup.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/9/26.
//

import Foundation

public protocol ActionGroup {
    associatedtype Body: ActionGroup
    
    func compileActionGroup() -> [RawAction]
    
    @ActionGroupBuilder
    var body: Body { get }
}

extension ActionGroup {
    public func compileActionGroup() -> [RawAction] {
        body.compileActionGroup()
    }
}




