//
//  ActionGroupBuilder.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/9/26.
//

import Helpers

@resultBuilder
public enum ActionGroupBuilder {
    public static func buildBlock<each T: ActionGroup>(_ actionGroup: repeat each T) -> some ActionGroup {
        AnyActionGroup(repeat each actionGroup)
    }
}
