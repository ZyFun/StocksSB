//
//  NetworkService.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 25.09.2021.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func request(urlString: String, completion: @escaping (Result<(Data, URLResponse), NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
             
             // TODO: Доработать обработку ошибок для отображения различной информации в алерте
             // Заготовка для обработки ошибок и вывода сообщений
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(.failure(.networkError))
                return
            }
            
            if !(200..<300).contains(statusCode) {
                switch statusCode {
                case 403:
                    print("Forbidden")
                case 503:
                    completion(.failure(.serverError))
                default:
                    print("Не зарегистрированная ошибка")
                    print(statusCode)
                }
            }
            
            guard let response = response else { return }
            
            if let data = data,
               error == nil {
                
                DispatchQueue.main.async {
                    completion(.success((data, response)))
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
