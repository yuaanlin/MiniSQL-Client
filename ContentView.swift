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
    
    @State private var page = 1;
    
    func handleExecuted(err: String?, res: SQLServerResponse?) {
        if(res != nil) {
            var tempArray = [Message]()
            for item in messages {
                tempArray.append(item)
            }
            for msg in res?.messages ?? [] {
                tempArray.append(
                    Message(query: msg.command, content: msg.message, time: Date())
                )
            }
            messages = tempArray
            data = res?.results ?? []
            fields = res?.fields ?? []
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
        
        VStack(alignment: .leading) {
            
            Text("Host")
            TextField("localhost:3306", text: $host).padding(.bottom)
            
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
                
                HStack{
                    Text("Results")
                    Text("Total " + String(data.count) + " records").foregroundColor(.gray)
                }
                
                DataTable(fields: $fields, data: $data, page: $page)
                
            }
            
            Text("Logs").padding(.top)
            
            MessageTable(messages: $messages)
            
        }.padding().alert(isPresented: $showingAlert) {
            
            Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("Close")))
            
        }
        

    }
}
