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
    
    var logoUrl: String {
        "https://storage.googleapis.com/iex/api/logos/\(symbol ?? "").png"
    }
}
