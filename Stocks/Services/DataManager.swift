//
//  DataManager.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 24.09.2021.
//

class DataManager {
    
    static let shared = DataManager()
    
    let companySymbols = [
        "AAPL",
        "MSFT",
        "GOOG",
        "AMZN",
        "FB",
    ]
    
    // TODO: Добавить сюда или в отдельный файл enum для ссылок на сайт
    
    private init(){}
}
