//
//  NetworkDataFetcher.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 26.09.2021.
//

import Foundation

class NetworkDataFetcher {
    static let shared = NetworkDataFetcher()
    
    func fetchStock(urlString: String, response: @escaping (Stock) -> Void) {
        NetworkService.shared.request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    let stock = try JSONDecoder().decode(Stock.self, from: data)
                    response(stock)
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private init(){}
    
}
