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
                
            ScrollViewReader { scrollProxy in
                
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
                        .id(i.id)
                        
                    }
                    
                }
                .onChange(of: messages.count) { id in
                    withAnimation {
                        scrollProxy.scrollTo(messages.last?.id)
                    }
                }
                
            }
            
        }.padding().background(Color.white)
        
    }
    
}
