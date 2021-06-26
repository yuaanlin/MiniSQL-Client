//
//  ContentView.swift
//  MiniSQL Client
//
//  Created by Yuanlin Lin on 2021/6/13.
//

import SwiftUI
import Foundation
import AppKit

struct ContentView: View {
    
    @State private var host: String = "localhost:3306"
    
    @State private var command: String = mockQuery
    
    @State private var data: [[String]] = mockData
    
    @State private var fields: [Attribute] = mockFields
    
    @State private var messages: [Message] = mockMsgs
    
    @State private var tables: [String] = ["student2"]
    
    @State private var indexes: [String] = ["test"]
    
    @State private var showingAlert = false
    
    @State private var alertTitle = ""
    
    @State private var alertMsg = ""
    
    @State private var page = 1;
    
    func handleExecuted(err: String?, res: SQLServerResponse?) {
        if(res != nil) {
            var tempArray = [Message]()
            for item in messages {
                tempArray.append(item)
            }
            
            guard let res = res else {
                return
            }
            
            if(res.messages.count > 20) {
                tempArray.append(
                    Message(query: "Info", content: "Skip " + String(res.messages.count - 20) + " messages ...", time: Date())
                )
            }
            
            for msg in res.messages.count > 20 ? res.messages[0...19] : res.messages[0...res.messages.count-1] {
                tempArray.append(
                    Message(query: msg.command, content: msg.message, time: Date())
                )
            }
            
            messages = tempArray
            data = res.results
            fields = res.fields
            page = 1
            
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
    
    var body: some View {
        
        HSplitView {
            
            List {
                Text("Host")
                    .foregroundColor(.gray)
                
                TextField("localhost:3306", text: $host)
                    .padding(.bottom)
                
                Text("Tables")
                    .foregroundColor(.gray)
                
                ForEach(tables, id: \.self) { table in
                    
                    Text(table)
                        .onTapGesture {
                            command += table
                        }
                    
                }.padding(.bottom)
                
                Text("Indexes")
                    .foregroundColor(.gray)
                
                ForEach(indexes, id: \.self) { index in
                    Text(index)
                }.padding(.bottom)
                
            }
            .listStyle(SidebarListStyle())
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Query")
                    Button("select File") {
                        let panel = NSOpenPanel()
                        panel.allowsMultipleSelection = false
                        panel.canChooseDirectories = false
                        if panel.runModal() == .OK {
                            
                            guard let url = panel.url else {
                                return
                            }
                            
                            do {
                                command = try String(contentsOf: url, encoding: .utf8)
                            } catch {
                                alertTitle = "Error"
                                alertMsg = "Cannot open this file"
                                showingAlert = true
                            }
                        }
                    }
                    
                }
                
                SQLEditor(command: $command)
                
                HStack{
                    Spacer()
                    Button("Execute") {
                        executeSQL(url: host, query: command, callback: handleExecuted)
                    }
                }
                
                if(data.count > 0) {
                    
                    Divider().padding()
                    
                    HStack{
                        Text("Results")
                        Text("Total " + String(data.count) + " records").foregroundColor(.gray)
                    }
                    
                    DataTable(fields: $fields, data: $data, page: $page)
                    
                }
                
                Divider().padding()
                
                HStack {
                    
                    Text("Logs")
                    
                    Spacer()
                    
                    Button("Clear") {
                        messages = []
                    }
                    
                }
                
                MessageTable(messages: $messages)
                
                
                
            }.padding().alert(isPresented: $showingAlert) {
                
                Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("Close")))
                
            }  
            
            
        }
        
        
    }
}
