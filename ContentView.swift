//
//  ContentView.swift
//  MiniSQL Client
//
//  Created by Yuanlin Lin on 2021/6/13.
//

import SwiftUI
import Foundation
import AppKit

struct Attribute: Codable {
    var name: String
    var dataType: String
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
    var error: String
}

func executeSQL(url: String, query: String, callback: @escaping (String?, SQLServerResponse?) -> Void) {
    
    let url = URL(string: "http://" + url + "/minisql")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = query.data(using: String.Encoding.utf8)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
            callback(error?.localizedDescription ?? "Unknown error", nil)
            return
        }

        guard (200 ... 299) ~= response.statusCode else {
            callback("statusCode of server response should be 2xx, but is \(response.statusCode)", nil)
            print("statusCode should be 2xx, but is \(response.statusCode), response = \(response)")
            return
        }

        let decoder = JSONDecoder()

        do {
            let parsedRes = try decoder.decode(SQLServerResponse.self, from: data)
            callback(nil, parsedRes)
        } catch {
            callback(error.localizedDescription, nil)
        }
    }

    task.resume()
    
}

let mockQuery = "CREATE TABLE todo (\n\tid int PRIMARY KEY,\n\ttitle varchar(255)\n)"

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

struct ContentView: View {
    
    @State private var host: String = "localhost:3306"

    @State private var command: String = mockQuery
    
    @State private var data: [[String]] = mockData
    
    @State private var fields: [Attribute] = mockFields
    
    @State private var messages: [Message] = mockMsgs
    
    @State private var showingAlert = false
    
    @State private var alertTitle = ""
    
    @State private var alertMsg = ""
    
    let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        return formatter
    }()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            
            Text("Host")
            TextField("localhost:3306", text: $host).padding(.bottom)
            
            
            Text("Query")
            SQLEditor(command: $command)
            
            HStack{
                Spacer()
                Button("Execute") {
                    executeSQL(url: host, query: command) { (err, res) in
                        if(res != nil) {
                            messages.append(
                                Message(query: command.replacingOccurrences(of: "\n", with: ""),
                                        content: res?.error ?? "Operation Successed without message.",
                                        time: Date()
                                )
                            )
                            data = res?.results ?? []
                            fields = res?.fields ?? []
                        } else {
                            messages.append(
                                Message(query: command.replacingOccurrences(of: "\n", with: ""),
                                        content: err ?? "Encountered unexpected error Q_Q",
                                        time: Date()
                                )
                            )
                            alertTitle = "Error Occured"
                            alertMsg = err ?? "Encountered unexpected error Q_Q"
                            showingAlert = true
                        }
                    }
                }
            }
            
            
            if(data.count > 0) {
                
                Text("Results")
                
                DataTable(fields: $fields, data: $data)
                
            }
            
            Text("Logs").padding(.top)
            
            VStack {
                ScrollView {
                    ForEach(messages, id: \.id) { i in
                        HStack {
                            Text("\(i.time, formatter: taskDateFormat)").foregroundColor(Color.gray)
                            Divider()
                            Text(i.query).lineLimit(1).frame(width: 180, alignment: .leading)
                            Divider()
                            Text(i.content)
                            Spacer()
                        }
                    }
                }
            }.padding().background(Color.white)
            
        }.padding().alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("Close")))
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
