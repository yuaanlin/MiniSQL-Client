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
        pattern: "CREATE|DROP|TABLE|INSERT|INTO|UPDATE|INDEX|DELETE|PRIMARY|KEY|VALUES|SELECT|FROM|WHERE",
        options: NSRegularExpression.Options.caseInsensitive
    )

    private static let dataTypeRegex = try! NSRegularExpression(
        pattern: "INT|VARCHAR(.*)|FLOAT",
        options: NSRegularExpression.Options.caseInsensitive
    )

    private static let keywordFormat: [TextFormattingRule] = [
        TextFormattingRule(key: .foregroundColor, value: NSColor(Color.blue))
    ]

    private static let dataTypeFormat: [TextFormattingRule] = [
        TextFormattingRule(key: .foregroundColor, value: NSColor(Color.gray))
    ]
    
    private let rules: [HighlightRule] = [
        HighlightRule(pattern: keywordRegex, formattingRules: keywordFormat),
        HighlightRule(pattern: dataTypeRegex, formattingRules: dataTypeFormat)
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
