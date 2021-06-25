//
//  Constants.swift
//  MiniSQL Client
//
//  Created by Yuanlin Lin on 2021/6/14.
//

import Foundation

let mockQuery = """
CREATE TABLE student2(
    id int,
    name string,
    score float
);
"""

let mockMsgs = [
    Message(query: "Let's getting start", content:"Enter the SQL query on the editor and click \"excute\" button", time: Date())
]

let mockData : [[String]] = [
    ["1", "Title1"],
    ["2", "title2"],
    ["3", "title3"]
]

let mockFields : [Attribute] = [
    Attribute(name: "id", type: "int"),
    Attribute(name: "title", type: "string")
];
