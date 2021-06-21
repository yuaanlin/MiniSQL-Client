//
//  Constants.swift
//  MiniSQL Client
//
//  Created by Yuanlin Lin on 2021/6/14.
//

import Foundation

let mockQuery = """
    CREATE TABLE Persons (
        PersonID int,
        LastName varchar,
        FirstName varchar,
        Address varchar,
        City varchar
    );
    """

let mockMsgs = [
    Message(query: mockQuery.replacingOccurrences(of: "\n", with: ""), content:"Created table \"todo\" successfully.", time: Date())
]

let mockData : [[String]] = [
    ["1", "Title1"],
    ["2", "title2"],
    ["3", "title3"]
]

let mockFields : [Attribute] = [
    Attribute(name: "id", dataType: "int"),
    Attribute(name: "title", dataType: "string")
];
