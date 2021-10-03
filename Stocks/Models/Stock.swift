//
//  Stock.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 24.09.2021.
//

struct Stock: Decodable {
    // TODO: добавить в модель данных валюту
    let companyName: String?
    let symbol: String?
    let latestPrice: Double?
    let change: Double?
}

struct CompanyLogo: Decodable {
    let url: String
}
