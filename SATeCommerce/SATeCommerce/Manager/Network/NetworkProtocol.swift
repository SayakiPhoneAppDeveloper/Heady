//
//  NetworkProtocol.swift
//  SATeCommerce
//
//  Created by Sayak Khatua on 16/08/20.
//  Copyright © 2020 Sayak Khatua. All rights reserved.
//

import Foundation

protocol APIConnection {
    func fetchData(completion: @escaping (Bool, String?)->())
}
extension APIConnection{
    func fetchData(completion: @escaping (Bool, String?)->()){
        guard let requestUrl = URL(string: "https://stark-spire-93433.herokuapp.com/json") else { return }
        
        URLSession.shared.dataTask(with: requestUrl) { (data, response
            , error) in
            
            guard let data = data else {
                completion(false, "Error fetching data")
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.dateFormatr)
                
                let responseData = try decoder.decode(Response.self, from: data)
                SATCoreDataManager.shared.upsertSyncData(responseData) { (isSuccess) in
                    if isSuccess{
                        completion(true, nil)
                    }
                }
            } catch let err {
                completion(false, "Error fetching data")
                print("Err", err)
            }
        }.resume()
    }
}
