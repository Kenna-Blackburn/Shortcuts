//
//  SigningService.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/11/26.
//

import Foundation

public protocol SigningService {
    func sign(
        _ shortcut: RawShortcut,
        to outputURL: URL,
    ) async throws
}
