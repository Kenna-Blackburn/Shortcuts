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
            
            var repeatResults = MagicVariable()
            Repeat(Constant(10)) {
                QuickLook(number)
            }
            .bind(to: &repeatResults)
            
            QuickLook(repeatResults)
        }
    }
    
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    
    for action in DebugActionGroup().compile() {
        let data = try encoder.encode(action)
        let string = String(data: data, encoding: .utf8)!
        
        print(string)
    }
}
