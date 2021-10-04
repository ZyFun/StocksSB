//
//  CompanyLogoImageView.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 03.10.2021.
//
//  Комментарии в этом файле используются как конспект
//  TODO: Найти, как очищать кэш принудительно (ради интереса)

import UIKit

class CompanyLogoImageView: UIImageView {
    
    func getLogo(from url: String) {
        guard let url = URL(string: url) else {
            print("invalidURL")
            // TODO: передать сюда картинку с заготовленным изображением, чтобы не отображалась пустота
            return
        }
        
        // Используем изображение из кэша, если оно там есть
        if let cachedImage = getCachedImage(from: url) {
            image = cachedImage
            return
        }
        
        // Если изображение нету, грузим его из сети
        NetworkDataFetcher.shared.fetchLogoToImageView(from: url) { [weak self] data, response in
            self?.image = UIImage(data: data)
            self?.saveDataToCache(with: data, response: response)
        }
    }
    
    private func saveDataToCache(with data: Data, response: URLResponse) {
        
        // Создаём запрос для поиска кешируемого объекта по url адресу
        guard let url = response.url else { return }
        // TODO: Удалить после тестирования
        print("save to cache")
        let urlRequest = URLRequest(url: url)
        
        // создаём объект для хранения данных в кэше
        let cachedResponse = CachedURLResponse(response: response, data: data)
        
        // сохраняем объект в кэш и помещаем запрос, по которому мы будем искать данные в кэше
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
    
    private func getCachedImage(from url: URL) -> UIImage? {
        // Создаём запрос для поиска по кэшу
        let request = URLRequest(url: url)
        
        // Восстанавливаем закэшированные данные
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            // TODO: Удалить после тестирования
            print("get from cache")
            return UIImage(data: cachedResponse.data)
        }
        
        return nil
    }
}
