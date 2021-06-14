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
    
    @State private var showingAlert = false
    
    @State private var alertTitle = ""
    
    @State private var alertMsg = ""
    
    func handleExecuted(err: String?, res: SQLServerResponse?) {
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
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            
            Text("Host")
            TextField("localhost:3306", text: $host).padding(.bottom)
            
            
            Text("Query")
            SQLEditor(command: $command)
            
            HStack{
                Spacer()
                Button("Execute") {
                    executeSQL(url: host, query: command, callback: handleExecuted)
                }
            }
            
            
            if(data.count > 0) {
                
                Text("Results")
                
                DataTable(fields: $fields, data: $data)
                
            }
            
            Text("Logs").padding(.top)
            
            MessageTable(messages: $messages)
            
        }.padding().alert(isPresented: $showingAlert) {
            
            Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("Close")))
            
        }

    }
}
