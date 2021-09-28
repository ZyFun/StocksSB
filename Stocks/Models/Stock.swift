//
//  Stock.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 24.09.2021.
//

struct Stock: Decodable {
    let companyName: String?
    let symbol: String?
    let latestPrice: Double?
    let change: Double?
    
    // TODO: Сделать отдельную модель для получения логотипа так как ссылка на него совсем другого типа и это отдельная модель данных.
    // TODO: Задание звучит так: В использованном нами API есть возможность получить ссылку на логотип компании методом /stock/{symbol}/logo, который возвращает URL на картинку вида https:// storage.googleapis.com/iex/api/logos/{symbol}.png. Можно скачать по нему логотип и отобразить его на экране с помощью UIImage.
    // TODO: Полная ссылка на json выглядит так: https://cloud.iexapis.com/stable/stock/\(symbol)/logo/quote?token=\(token)
}
