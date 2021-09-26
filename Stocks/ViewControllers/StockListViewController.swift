//
//  StockListViewController.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 24.09.2021.
//

import UIKit

class StockListViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private properties
    private var stocks: [Stock] = []

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150
        
        activityIndicator.hidesWhenStopped = true
        
        getStocks()
        
        // TODO: Добавить кнопку обновления данных
        // TODO: Добавить алерт контроллер с кнопкой обновления данных при отсутствии сети или отменой с остановкой анимации индикатора.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stocks.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockCell

        let stock = stocks[indexPath.row]
        cell.configure(with: stock)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - Private method
extension StockListViewController {
    private func getStocks() {
        let token = "pk_92287e65be054541b0a167b0ac4fa0aa"
        
        activityIndicator.startAnimating()
        
        DataManager.shared.companySymbols.forEach { [weak self] symbol in
            let stockUrlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)"
            
            NetworkDataFetcher.shared.fetchStock(urlString: stockUrlString) { stock in
                self?.stocks.append(stock)
                
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.reloadData()
                }
                
            }
        }
    }
}
