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
    struct DebugActionGroup: ActionGroup {
        var body: some ActionGroup {
            Comment(text: Constant("""
            Made by Kenna Blackburn on 02/10/26 with SPM/Shortcuts
            """))
            
            var number = MagicVariable()
            Number(Constant(42))
                .bind(to: &number)
            
            Repeat(10) {
                QuickLook(number)
            }
        }
    }
    
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    
    let data = try encoder.encode(DebugActionGroup().compileActionGroup())
    let string = String(data: data, encoding: .utf8)!
    
    print(string)
}
