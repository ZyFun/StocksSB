//
//  DataManager.swift
//  Stock
//
//  Created by Дмитрий Данилин on 24.09.2021.
//

class DataManager {
    
    static let shared = DataManager()
    
    let testCompany = ["Apple", "Microsoft"]
    
    let company = [
        "Apple": "AAPL",
        "Microsoft": "MSFT",
        "Google": "GOOG",
        "Amazon": "AMZN",
        "Facebook": "FB",
    ]
    
    private init(){}
}
