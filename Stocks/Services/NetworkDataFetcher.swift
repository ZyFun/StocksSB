//
//  NetworkDataFetcher.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 26.09.2021.
//

import Foundation

class NetworkDataFetcher {
    static let shared = NetworkDataFetcher()
    
    func fetchJSON<T: Decodable>(dataType: T.Type, urlString: String, response: @escaping (Result<T, NetworkError>) -> Void) {
        NetworkService.shared.request(urlString: urlString) { result in
            switch result {
            case .success(let (data, _)):
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
    
//    func fetchLogo(urlString: String, response: @escaping (Data) -> Void) {
//        NetworkService.shared.request(urlString: urlString) { result in
//            switch result {
//            case .success(let data):
//                DispatchQueue.main.async {
//                    response(data)
//                }
//            case .failure(let error):
//                print("Load image data: \(error)")
//            }
//        }
//    }
    
    // TODO: Переписать этот метод, оставив в нём только передачу полученных данных с помощью сетевого запроса
    func fetchLogoToImageView(from url: URL, response: @escaping (Data, URLResponse) -> Void) {
        let urlString = url.absoluteString
        
        NetworkService.shared.request(urlString: urlString) { result in
            switch result {
            case .success(let(data, urlResponse)):
                // Используется как защита. Без этого ячейка таблицы может получить неправильные данные и например напротив apple будет логотип facebook
                guard url == urlResponse.url else { return }
                
                DispatchQueue.main.async {
                    response(data, urlResponse)
                }
            case .failure(let error):
                print("Load image data: \(error)")
            }
        }
    }
    
    private init(){}
    
}
