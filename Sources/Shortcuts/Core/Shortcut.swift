//
//  Shortcut.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/11/26.
//

import Foundation

public protocol Shortcut: ActionGroup {
    var icon: Icon? { get }
}

extension Shortcut {
    public var icon: Icon? {
        nil
    }
}

extension Shortcut {
    public func compile(
        to outputURL: URL,
        using service: some SigningService,
    ) async throws {
        let rawShortcut = RawShortcut(self)
        try await service.sign(rawShortcut, to: outputURL)
    }
}
