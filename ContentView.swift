//
//  ContentView.swift
//  MiniSQL Client
//
//  Created by Yuanlin Lin on 2021/6/13.
//

import SwiftUI
import Foundation
import AppKit

struct Attribute {
    var name: String
    var dataType: String
}

struct Message {
    var content: String
    var time: Date
}

struct ContentView: View {
    
    @State private var name: String = "localhost:3306"
    
    @State private var command: String = "CREATE TABLE todo (\n\tid int PRIMARY KEY,\n\ttitle varchar(255)\n)"
    
    @State private var mock: [[String]] = [
        ["1", "Title1"],
        ["2", "title2"],
        ["3", "title3"]
    ]
    
    @State private var mockFields: [Attribute] = [
        Attribute(name: "id", dataType: "int"),
        Attribute(name: "title", dataType: "string")
    ];
    
    @State private var messages: [Message] = [
        Message(content:"Created table \"todo\" successfully.", time: Date())
    ]
    
    static let taskDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm:ss"
            return formatter
        }()
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            
            Text("Host")
            TextField("localhost:3306", text: $name).padding(.bottom)
            
            
            Text("Query")
            SQLEditor(command: $command)
            
            HStack{
                Spacer()
                Button("Execute") {
                   print(mock[0][0])
                }
            }
            
            Text("Results")
        
            DataTable(fields: $mockFields, data: $mock)
            
            Text("Logs").padding(.top)
            
            VStack {
                ForEach(messages, id: \.content) { i in
                    HStack {
                        Text("\(i.time, formatter: Self.taskDateFormat)").foregroundColor(Color.gray)
                        Text(i.content)
                        Spacer()
                    }
                }
            }.padding().background(Color.white)
            
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
