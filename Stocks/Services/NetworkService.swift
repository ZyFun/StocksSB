//
//  NetworkService.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 25.09.2021.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            completion(.success(data))
        }.resume()
        
    }
    
    private init(){}
    
}
