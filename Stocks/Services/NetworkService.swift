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
        guard let url = URL(string: urlString) else {
            //TODO: С помощью Result вернуть сбда ошибку, создав кейс ошибок в менеджере сети. Этот кейс нужно подписать под протокол error, и его указать в блоке ошибок вмето Error
//            completion(.success(.invalidURL))
            return
            
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                completion(.success(data))
            } else {
                guard let error = error else { return }
                completion(.failure(error))
                print(error.localizedDescription + "#www")
                return
            }
            
        }.resume()
        
    }
    
    private init(){}
    
}
