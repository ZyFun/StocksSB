//
//  Stock.swift
//  Stock
//
//  Created by Дмитрий Данилин on 24.09.2021.
//

struct Stock {
    let companyName: String
    let symbol: String
    let latestPrice: Double
    let change: Double
    
    static func getStock() -> [Stock] {
        [
            Stock(
                companyName: DataManager.shared.testCompany.randomElement() ?? "",
                symbol: "AAPL",
                latestPrice: 208,
                change: 10
            )
        ]
    }
}
