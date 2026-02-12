//
//  RawShortcut.swift
//  Shortcuts
//
//  Created by Kenna Blackburn on 2/11/26.
//

import Foundation
import Helpers

public struct RawShortcut: Encodable {
    public var actions: [RawAction]
    public var icon: Icon?
    
    public init(actions: [RawAction], icon: Icon? = nil) {
        self.actions = actions
        self.icon = icon
    }
    
    public init(icon: Icon? = nil, _ actions: [RawAction]) {
        self.init(actions: actions, icon: icon)
    }
    
    public init(_ base: some Shortcut) {
        self.init(actions: base.compile(), icon: base.icon)
    }
    
    public func encode(to encoder: any Encoder) throws {
        let dictionary: [String: Any] = [
            "WFWorkflowActions": actions,
            "WFQuickActionSurfaces": [],
            "WFWorkflowImportQuestions": [],
            "WFWorkflowInputContentItemClasses": [
                "WFAppContentItem",
                "WFAppStoreAppContentItem",
                "WFArticleContentItem",
                "WFContactContentItem",
                "WFDateContentItem",
                "WFEmailAddressContentItem",
                "WFFolderContentItem",
                "WFGenericFileContentItem",
                "WFImageContentItem",
                "WFiTunesProductContentItem",
                "WFLocationContentItem",
                "WFDCMapsLinkContentItem",
                "WFAVAssetContentItem",
                "WFPDFContentItem",
                "WFPhoneNumberContentItem",
                "WFRichTextContentItem",
                "WFSafariWebPageContentItem",
                "WFStringContentItem",
                "WFURLContentItem",
            ],
            "WFWorkflowHasShortcutInputVariables": false,
            "WFWorkflowOutputContentItemClasses": [
                "Watch",
                "WFWorkflowTypeShowInSearch",
            ],
            "WFWorkflowHasOutputFallback": false,
            "WFWorkflowIcon": icon as Any,
            "WFWorkflowClientVersion": "4046.0.2.1.102",
            "WFWorkflowMinimumClientVersion": 900,
            "WFWorkflowMinimumClientVersionString": "900",
        ]
        
        try AnyEncodable(dictionary).encode(to: encoder)
    }
}

extension RawShortcut: Shortcut {
    public var body: some ActionGroup {
        AnyActionGroup(children: actions)
    }
}
