//
//  ArrayBuilder.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/11/26.
//

import Foundation

@resultBuilder
public enum ArrayBuilder<Element> {
    public static func buildExpression(_ element: Element) -> [Element] {
        return [element]
    }
    
    public static func buildExpression(_ array: [Element]) -> [Element] {
        return array
    }
    
    public static func buildBlock(_ arrays: [Element]...) -> [Element] {
        return buildArray(arrays)
    }
    
    public static func buildArray(_ arrays: [[Element]]) -> [Element] {
        return arrays.flatMap({ $0 })
    }
}
