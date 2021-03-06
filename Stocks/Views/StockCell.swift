//
//  StockCell.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 24.09.2021.
//

import UIKit

class StockCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changePriceLabel: UILabel!
    @IBOutlet weak var companyLogoImageView: CompanyLogoImageView!
    
    // MARK: - Public method
    func configure(with stock: Stock) {
        changeLabelTextColor(getting: stock.change ?? 0)
        
        companyNameLabel.text = stock.companyName
        symbolLabel.text = stock.symbol
        priceLabel.text = setCurrencySymbol(currency: stock.currency ?? "") + String(stock.latestPrice ?? 0)
        changePriceLabel.text = setCurrencySymbol(currency: stock.currency ?? "") + String(stock.change ?? 0)
        
        getLogo(stock.symbol ?? "", Token.publicKey.rawValue)
        
    }
    
}

// MARK: - Private func
extension StockCell {
    private func changeLabelTextColor(getting resultChangePrice: Double) {
        switch resultChangePrice {
        case _ where resultChangePrice < 0:
            changePriceLabel.textColor = .systemRed
        case _ where resultChangePrice > 0:
            changePriceLabel.textColor = .systemGreen
        default:
            changePriceLabel.textColor = .label
        }
    }
    
    private func setCurrencySymbol(currency: String) -> String {
        var currencySymbol: String
        
        switch currency {
        case "USD":
            currencySymbol = "$"
        default:
            currencySymbol = currency
        }
        return currencySymbol
    }
    
    private func getLogo(_ symbol: String, _ token: String) {
        let logoJSONUrlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/logo/quote?token=\(token)"
        
        NetworkDataFetcher.shared.fetchJSON(dataType: CompanyLogo.self, urlString: logoJSONUrlString) { [weak self] result in
            switch result {
            case .success(let logo):
                self?.companyLogoImageView.getLogo(from: logo.url)
//                // Загрузка без кеширования
//                NetworkDataFetcher.shared.fetchLogo(urlString: logo.url) { [weak self] imageData in
//                    self?.companyLogoImageView.image = UIImage(data: imageData)
//                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
