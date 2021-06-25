//
//  Models.swift
//  MiniSQL Client
//
//  Created by Yuanlin Lin on 2021/6/14.
//

import Foundation

struct Attribute: Codable {
    var name: String
    var type: String
}

struct ExecutionMessage: Codable {
    var command: String
    var message: String
}

struct Message {
    let id = UUID()
    var query: String
    var content: String
    var time: Date
}

struct SQLServerResponse: Codable {
    var results: [[String]]
    var fields: [Attribute]
    var messages: [ExecutionMessage]
}
