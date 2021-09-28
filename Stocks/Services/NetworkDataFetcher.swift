//
//  NetworkDataFetcher.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 26.09.2021.
//

import Foundation

class NetworkDataFetcher {
    static let shared = NetworkDataFetcher()
    
    func fetch<T: Decodable>(dataType: T.Type, urlString: String, response: @escaping (T) -> Void) {
        NetworkService.shared.request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let type = try JSONDecoder().decode(T.self, from: data)
                    // TODO: ПОместить в основной поток, чтобы при вызове функции не делать это во вью контроллере
                    response(type)
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    // TODO: Переписать тип под 1 метод используя данные с урока 2.11 (тайминг 1 час 8 минут)
    func fetchLogo(urlString: String, response: @escaping (Data) -> Void) {
        NetworkService.shared.request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                response(data)
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private init(){}
    
}
