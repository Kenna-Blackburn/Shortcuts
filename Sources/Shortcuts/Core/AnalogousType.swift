//
//  AnalogousType.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/10/26.
//

import Foundation

public protocol AnalogousType {
    func encodeForShortcuts(to encoder: any Encoder) throws
}

extension AnalogousType where Self: Encodable {
    public func encodeForShortcuts(to encoder: any Encoder) throws {
        try self.encode(to: encoder)
    }
}
