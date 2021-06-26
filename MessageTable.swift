//
//  MessageTable.swift
//  MiniSQL Client
//
//  Created by Yuanlin Lin on 2021/6/14.
//

import SwiftUI

struct MessageTable: View {
    
    @Binding var messages: [Message]
    
    let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        return formatter
    }()
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text("Time")
                    .frame(width: 60,alignment: .leading)
                    .foregroundColor(Color.white)
                
                Divider().frame(height: 12)
                
                Text("Query")
                    .frame(width: 180, alignment: .leading)
                    .foregroundColor(Color.white)
                
                Divider().frame(height: 12)
                
                Text("Message").frame(width: 90, alignment: .leading)
                    .foregroundColor(Color.white)
                
                Spacer()
                
            }
            .padding(4)
            .background(Color.gray)
            
            ScrollViewReader { scrollProxy in
                
                ScrollView {
                    
                    ForEach(messages, id: \.id) { i in
                        
                        HStack {
                            
                            Text("\(i.time, formatter: taskDateFormat)").frame(width: 60, alignment: .leading).foregroundColor(Color.gray)
                            Divider()
                            Text(i.query).lineLimit(1).frame(width: 180, alignment: .leading)
                            Divider()
                            Text(i.content)
                            Spacer()
                            
                        }
                        .id(i.id)
                        
                    }
                    
                }
                .padding(4)
                .onChange(of: messages.count) { id in
                    withAnimation {
                        scrollProxy.scrollTo(messages.last?.id)
                    }
                }
                
            }
            
        }.background(Color.white)
        
    }
    
}
