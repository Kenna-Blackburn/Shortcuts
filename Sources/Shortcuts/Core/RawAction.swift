//
//  RawAction.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/9/26.
//

import Foundation
import Helpers

public struct RawAction: Action, Encodable {
    
    public var actionID: String
    public var parameters: [String: Any]
    
    public var instanceID: UUID
    
    init(
        actionID: String,
        parameters: [String: Any],
        instanceID: UUID = .init(),
    ) {
        self.actionID = actionID
        self.parameters = parameters
        self.instanceID = instanceID
    }
    
    public init(_ actionID: String, _ parameters: [String: Any]) {
        self.init(actionID: actionID, parameters: parameters)
    }
    
    public func compileAction() -> RawAction {
        return self
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(actionID, forKey: .actionID)
        
        var parameters = parameters
        parameters["UUID"] = instanceID
        try container.encode(AnyEncodable(parameters), forKey: .parameters)
    }
    
    private enum CodingKeys: String, CodingKey {
        case actionID = "WFWorkflowActionIdentifier"
        case parameters = "WFWorkflowActionParameters"
    }
}

extension RawAction {
    public func instanceID(_ instanceID: UUID) -> Self {
        var copy = self
        copy.instanceID = instanceID
        return copy
    }
}
