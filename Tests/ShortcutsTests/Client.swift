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
            Menu("Title") {
                for i in 1...3 {
                    Menu.Item("Item #\(i)") {
                        QuickLook(Constant(i))
                    }
                }
            }
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
