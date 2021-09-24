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
    
    private init(){}
}
