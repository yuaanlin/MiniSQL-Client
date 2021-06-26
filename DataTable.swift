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
    @Binding var page: Int;
    
    func dataFromIndex() -> Int {
        return 60 * (page-1) > data.count ? data.count - 1 : 60 * (page-1)
    }
    
    func dataToIndex() -> Int {
        return 60 * (page) > data.count ? data.count : 60 * page
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack(spacing: 0) {
                
                ForEach(fields, id: \.name) { i in
                    Text(i.name).foregroundColor(Color.white).padding().frame(width: 120,height: 24)
                    Divider()
                }
                Spacer()
                
            }.background(Color.gray).frame(height: 24)
            
            Divider()
            
            ScrollView {
                
                ForEach( data.count == 0 ? [] : data[dataFromIndex()..<dataToIndex()], id: \.self) { i in
                    
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
            
            HStack {
                
                Spacer()
                if(page > 1) {
                    Button("Next Page") {
                        page-=1
                    }
                }
                Text("Page " + String(page))
                Button("Next Page") {
                    page+=1
                }
            }.padding(12)
            
        }.background(Color.white)
            
        }
        
}
