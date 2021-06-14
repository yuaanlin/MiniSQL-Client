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
        
        VStack(spacing: 0) {
            
            HStack(spacing: 0) {
                ForEach(fields, id: \.name) { i in
                    Text(i.name).padding().frame(width: 120,height: 18)
                    Divider()
                }
                Spacer()
            }
            
            Divider()
            
            ForEach(data, id: \.self) { i in
                
                HStack(spacing: 0) {
                    
                    ForEach(i, id: \.self) { j in
                        Text(j).padding().frame(width: 120,height: 18)
                        Divider()
                    }
                    
                    Spacer()
                }
                
                Divider()
                
            }
            
        }.background(Color.white)
        
    }
}
