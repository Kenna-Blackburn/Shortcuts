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
    struct DebugShortcut: Shortcut {
        var body: some ActionGroup {
            Comment("""
            v0.0.1
            Made by Kenna Blackburn on 02/11/26 with SPM/Shortcuts
            """)
            
            var payload = MagicVariable()
            AskFor.Text(
                with: "Payload",
                default: "The Answer to the Great Question... Of Life, the Universe and Everything... Is... Forty-two,' said Deep Thought, with infinite majesty and calm.",
                multiline: true,
            )
            .bind(to: &payload)
            
            var target = MagicVariable()
            SelectContacts(multiple: true)
                .bind(to: &target)
            
            var splitText = MagicVariable()
            SplitText(payload, by: " ")
                .bind(to: &splitText)
            
            RepeatEach(splitText) { (i, token) in
                ShowResult(token)
            }
        }
    }
    
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml
    let data = try encoder.encode(DebugShortcut().compile())
    let string = String(data: data, encoding: .utf8)!
    print(string)
    
    let url = URL.downloadsDirectory.appending(path: "DebugShortcut.shortcut")
    try await DebugShortcut().compile(to: url, using: .cli())
}
