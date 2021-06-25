//
//  ExecuteSQL.swift
//  MiniSQL Client
//
//  Created by Yuanlin Lin on 2021/6/14.
//

import Foundation

let serial = DispatchQueue(label: "serial",attributes: .init(rawValue:0))

func executeSQL(url: String, query: String, callback: @escaping (String?, SQLServerResponse?) -> Void) {
    serial.async{
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
    
}
