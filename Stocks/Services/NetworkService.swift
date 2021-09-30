//
//  NetworkService.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 25.09.2021.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func request(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
            
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            /*
             
             // Заготовка для обработки ошибок и вывода сообщений
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(.failure(.networkError))
                print("нет сети")
                return
            }
            
            if (200...300).contains(statusCode) {
                switch statusCode {
                case 200:
                    print("OK")
                case 403:
                    print("Forbidden")
                default:
                    print("Неизвестная ошибка")
                    print(statusCode)
                    return
                }
            }
             
            */
            
            if let data = data,
               (response as? HTTPURLResponse)?.statusCode == 200,
               error == nil {
                
                DispatchQueue.main.async {
                    completion(.success(data))
                }
                
            } else {
                guard let error = error else { return }
                completion(.failure(.noData))
                print(error.localizedDescription + "#www")
                return
            }
            
        }.resume()
        
    }
    
    private init(){}
    
}
