//
//  NetworkError.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 30.09.2021.
//


enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError
}
