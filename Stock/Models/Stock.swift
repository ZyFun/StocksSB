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
                companyName: "Apple",
                symbol: "AAPL",
                latestPrice: 146.15,
                change: -0.68
            ),
            Stock(
                companyName: "Microsoft",
                symbol: "MSFT",
                latestPrice: 297.93,
                change: -1.63
            )
        ]
    }
}
