//
//  ActionGroupBuilder.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/9/26.
//

import Helpers

// TODO: finish
@resultBuilder
public enum ActionGroupBuilder {
    public static func buildBlock<each T: ActionGroup>(_ actionGroup: repeat each T) -> AnyActionGroup {
        AnyActionGroup(repeat each actionGroup)
    }
    
    public static func buildArray(_ components: [any ActionGroup]) -> AnyActionGroup {
        AnyActionGroup(children: components)
    }
}
