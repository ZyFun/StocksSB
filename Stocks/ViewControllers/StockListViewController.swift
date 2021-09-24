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
        activityIndicator.startAnimating()
        
        for symbol in DataManager.shared.companySymbols {
            fetchStock(for: symbol)
        }
        
    }
}

// MARK: - Network requests
extension StockListViewController {
    private func fetchStock(for symbol: String) {
        let token = "pk_92287e65be054541b0a167b0ac4fa0aa"
        guard let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let stock = try JSONDecoder().decode(Stock.self, from: data)
                self.stocks.append(stock)
                print(stock)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
            
        }
        
        dataTask.resume()
        
    }
}
