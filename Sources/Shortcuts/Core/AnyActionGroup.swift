//
//  AnyActionGroup.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/9/26.
//

import Foundation

public struct AnyActionGroup: ActionGroup {
    public var _compileActionGroup: () -> [RawAction]
    
    public init(_ compileActionGroup: @escaping () -> [RawAction]) {
        self._compileActionGroup = compileActionGroup
    }
    
    public init(_ base: some ActionGroup) {
        self.init(base.compileActionGroup)
    }
    
    public init(_ rawActions: [RawAction]) {
        self.init({ rawActions })
    }
    
    public init<each T: ActionGroup>(_ actionGroup: repeat each T) {
        self.init {
            var result = [RawAction]()
            for actionGroup in repeat each actionGroup {
                result.append(contentsOf: actionGroup.compileActionGroup())
            }
            
            return result
        }
    }
    
    public func compileActionGroup() -> [RawAction] {
        _compileActionGroup()
    }
    
    public var body: some ActionGroup {
        fatalError("tried to access \(#function) on \(Self.self)")
    }
}
