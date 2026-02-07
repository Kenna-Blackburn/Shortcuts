//
//  Client.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/7/26.
//

import Foundation
import Testing
@testable import Shortcuts

@Test("Client")
func client() async throws {
    struct DebugAction1: Action {
        var instanceID: UUID
        
        var value1: any ValueProvider<String>
        
        func compileAction() -> RawAction {
            RawAction("spm.shortcuts.debug.action1", [
                "value1": value1
            ])
            .instanceID(instanceID)
        }
    }
    
    struct DebugActionGroup: ActionGroup {
        var body: some ActionGroup {
            RawAction("is.workflow.actions.comment", [
                "WFCommentActionText": """
                v0.0.0
                Made by Kenna Blackburn on 02/09/26 with SPM/Shortcuts
                """,
            ])
            
            var magicVar1 = MagicVariable("Magic Var 1", for: String.self)
            DebugAction1(instanceID: .init(), value1: Constant(value: "Hello"))
                .bind(to: &magicVar1)
            
            DebugAction1(instanceID: .init(), value1: magicVar1)
        }
    }
    
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    
    let data = try encoder.encode(DebugActionGroup().compileActionGroup())
    let string = String(data: data, encoding: .utf8)!
    
    print(string)
}
