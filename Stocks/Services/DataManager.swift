//
//  DataManager.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 24.09.2021.
//

/// Используется для формирования массива, с помощью захардкоженных тикеров акций на случай, когда json на сервере не сформирован и не доступен.
class DataManager {
    
    static let shared = DataManager()
    
    let companySymbols = [
        "AAPL",
        "MSFT",
        "GOOG",
        "AMZN",
        "FB",
    ]
    
    private init(){}
}
