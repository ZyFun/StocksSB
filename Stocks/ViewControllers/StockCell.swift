//
//  StockCell.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 24.09.2021.
//

import UIKit

class StockCell: UITableViewCell {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changePriceLabel: UILabel!
    
    func configure(with stock: Stock) {
        companyNameLabel.text = stock.companyName
        symbolLabel.text = stock.symbol
        priceLabel.text = String(stock.latestPrice)
        changePriceLabel.text = String(stock.change)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
