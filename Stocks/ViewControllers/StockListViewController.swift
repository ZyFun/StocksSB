//
//  StockListViewController.swift
//  Stocks
//
//  Created by Дмитрий Данилин on 24.09.2021.
//

import UIKit

class StockListViewController: UITableViewController {
    
    // MARK: - Private properties
    private var stocks: [Stock] = []
    private var activityIndicator = UIActivityIndicatorView() // Срабатывает только при старте приложения

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Defaults setting
        tableView.rowHeight = 150
        setupRefreshControl()
        
        setActivityIndicator(in: tableView, for: &activityIndicator)
        
        // Network requests
        activityIndicator.startAnimating()
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
    @objc private func getStocks() {
        let token = Token.publicKey.rawValue
        
        title = "Gainers stocks"
        let stockJSONUrlString = "https://cloud.iexapis.com/stable/stock/market/list/gainers%20./quote?token=\(token)"
        
        NetworkDataFetcher.shared.fetchJSON(dataType: [Stock].self, urlString: stockJSONUrlString) { [weak self] result in
            switch result {
            case .success(let stock):
                self?.stocks = stock
                
                if stock.isEmpty {
                    // Использование заглушки, чтобы при отсутствии данных с сервера, загрузилось хоть что-то и было видно что приложение работает. Такое решение было принято, потому что при получении массива с сервера, стал приходить пустой массив
                    self?.title = "Stocks"
                    self?.showAlertReloadData(title: "Inline data loaded", message: "No data received, to retry?")
                    
                    DataManager.shared.companySymbols.forEach { symbol in
                        let hardcodeStockJSONUrlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(token)"
                        
                        NetworkDataFetcher.shared.fetchJSON(dataType: Stock.self, urlString: hardcodeStockJSONUrlString) { result in
                            switch result {
                            case .success(let stock):
                                self?.stocks.append(stock)
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
                
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
                
            case .failure(let error):
                // TODO: Доделать обработку ошибок от сервера
                switch error {
                case .networkError:
                    self?.showAlertReloadData(title: "Network error",
                                              message: "No internet connection, to retry?")
                case .invalidURL:
                    break
                case .noData:
                    break
                case .decodingError:
                    break
                case .serverError:
                    self?.showAlertReloadData(title: "503 Service Unavailable",
                                              message: "Service temporarily unavailable, to retry?")
                }
            }
            
            if self?.refreshControl != nil {
                self?.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl() // Конспект: инициализация refreshControl для его активации в интерфейсе
        refreshControl?.attributedTitle = NSAttributedString(string: "Loading data")
        refreshControl?.addTarget(self, action: #selector(getStocks), for: .valueChanged) // Конспект: self, класс в котором должно произойти действие при взаимодействии с элементом интерфейса.
    }
    
    private func setActivityIndicator(in view: UIView, for activityIndicator: inout UIActivityIndicatorView){
        
        //        activityIndicator.center = view.center // тоже самое что и ручная настройка, но без фрейма
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: view.frame.width / 2 - 50,
                                                                  y: view.frame.height / 2 - 150,
                                                                  width: 100, height: 100))
        activityIndicator.backgroundColor = .systemGray4
        activityIndicator.layer.cornerRadius = 15
        activityIndicator.style = .large
        activityIndicator.color = .label // цвет установлен для того, чтобы при применении прозрачности, индикатор оставался насыщенным. А именно этот цвет, для поддержания темной темы
        activityIndicator.alpha = 0.5

        view.addSubview(activityIndicator)
    }
    
    func showAlertReloadData(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let loadAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.activityIndicator.startAnimating()
            self.getStocks()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
        
        alert.addAction(loadAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
