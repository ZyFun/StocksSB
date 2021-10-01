//
//  NetworkDataFetcher.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 26.09.2021.
//

import Foundation

class NetworkDataFetcher {
    static let shared = NetworkDataFetcher()
    
    func fetch<T: Decodable>(dataType: T.Type, urlString: String, response: @escaping (Result<T, NetworkError>) -> Void) {
        NetworkService.shared.request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let type = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        response(.success(type))
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    response(.failure(error))
                }
            }
            
        }
    }
    
    func fetchLogo(urlString: String, response: @escaping (Data) -> Void) {
        NetworkService.shared.request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    response(data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private init(){}
    
}
