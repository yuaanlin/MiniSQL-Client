//
//  SQLEditor.swift
//  MiniSQL Client
//
//  Created by Yuanlin Lin on 2021/6/13.
//

import Foundation
import SwiftUI
import HighlightedTextEditor

struct SQLEditor: View {
    @Binding var command: String;
    
    private static let keywordRegex = try! NSRegularExpression(
        pattern: "(?<![a-zA-Z0-9])(CREATE|DROP|TABLE|INSERT|INTO|UPDATE|INDEX|DELETE|PRIMARY|KEY|VALUES|SELECT|FROM|WHERE)(?![a-zA-Z0-9])",
        options: NSRegularExpression.Options.caseInsensitive
    )
    
    private static let logicRegex = try! NSRegularExpression(
        pattern: "(?<![a-zA-Z0-9])(AND|OR)(?![a-zA-Z0-9])",
        options: NSRegularExpression.Options.caseInsensitive
    )

    private static let dataTypeRegex = try! NSRegularExpression(
        pattern: "(?<![a-zA-Z0-9])(INT|VARCHAR|FLOAT|=|<|>|!)(?![a-zA-Z0-9])",
        options: NSRegularExpression.Options.caseInsensitive
    )

    private static let keywordFormat: [TextFormattingRule] = [
        TextFormattingRule(key: .foregroundColor, value: NSColor(Color.blue))
    ]

    private static let dataTypeFormat: [TextFormattingRule] = [
        TextFormattingRule(key: .foregroundColor, value: NSColor(Color.gray))
    ]
    
    private static let logicFormat: [TextFormattingRule] = [
        TextFormattingRule(key: .foregroundColor, value: NSColor(Color.green))
    ]
    
    private let rules: [HighlightRule] = [
        HighlightRule(pattern: keywordRegex, formattingRules: keywordFormat),
        HighlightRule(pattern: dataTypeRegex, formattingRules: dataTypeFormat),
        HighlightRule(pattern: logicRegex, formattingRules: logicFormat)
    ]
    
    var body: some View {
        HighlightedTextEditor(text: $command, highlightRules: self.rules).frame(
            minWidth: 360,
            idealWidth: 720,
            maxWidth: 1280,
            minHeight: 240,
            idealHeight: 240,
            maxHeight: 240,
            alignment: .leading)
    }
}
