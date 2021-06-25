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
    
    @State private var currExeLine = 0
    
    @State private var executing = false
    
    @State private var totalLine = 0
    
    @State private var cmds: [String] = [];
    
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
            
            if(executing && totalLine > currExeLine + 1 && cmds[currExeLine + 1] != "") {
                currExeLine += 1
                executeSQL(url: host, query: cmds[currExeLine], callback: handleExecuted)
                
            } else {
                currExeLine = 0
                executing = false
            }
            
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
            currExeLine = 0
            executing = false
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
                
                        cmds = command.components(separatedBy: ";")
                        currExeLine = 0
                        executing = true
                        totalLine = cmds.count
                        executeSQL(url: host, query: cmds[0], callback: handleExecuted)
                    
                }
                if(executing) {
                  
                    Text("Executing line " + String(currExeLine) + "/" + String(totalLine))
                    Button("Cancel") {
                        executing = false
                    }
                    
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
