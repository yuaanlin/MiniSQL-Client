//
//  DataTable.swift
//  MiniSQL Client
//
//  Created by Yuanlin Lin on 2021/6/13.
//

import Foundation
import SwiftUI

struct DataTable:View {
    
    @Binding var fields: [Attribute];
    @Binding var data: [[String]];
    
    var body: some View {
        
        Text("Total " + String(data.count) + " records")
        LazyVStack(spacing: 0) {
            
            HStack(spacing: 0) {
                
                ForEach(fields, id: \.name) { i in
                    Text(i.name).foregroundColor(Color.white).padding().frame(width: 120,height: 36)
                    Divider()
                }
                Spacer()
                
            }.background(Color.gray)
            
            Divider()
            
            ScrollView {
            
                ForEach(data.prefix(200), id: \.self) { i in
                
                HStack(spacing: 0) {
                    
                    ForEach(i, id: \.self) { j in
                        Text(j).padding().frame(width: 120,height: 18)
                        Divider()
                    }
                    
                    Spacer()
                }
                
                Divider()
                
            }
                
            }.frame(height: 240)
            
        }.background(Color.white)
            
        }
        
}
