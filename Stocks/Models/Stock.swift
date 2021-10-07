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
    var currency: String?
}

struct CompanyLogo: Decodable {
    let url: String
}
